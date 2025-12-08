"""
Rate limiter for Gemini API calls to prevent quota exhaustion.
Implements a token bucket algorithm with per-minute tracking.
"""
import time
from threading import Lock
from collections import deque
from typing import Optional

# --- Improved RateLimiter Class ---

class RateLimiter:
    """Thread-safe rate limiter for API calls."""
    
    def __init__(self, calls_per_minute: int = 15, burst_size: int = 5):
        """
        Initialize rate limiter.
        
        Args:
            calls_per_minute: Maximum API calls allowed per 60-second window.
                              This is the primary limit to respect.
            burst_size: Maximum burst calls allowed (for brief spikes).
        """
        self.calls_per_minute = calls_per_minute
        self.burst_size = burst_size
        # Use maxlen for automatic old call removal, though _clean_old_timestamps
        # is more explicit for a sliding window.
        self.call_timestamps = deque() 
        self.lock = Lock()
        self.window_seconds = 60.0
        # This 10.0s window for burst is from your original code
        self.burst_window_seconds = 10.0
        
    def _clean_old_timestamps(self, current_time: float):
        """
        Remove timestamps older than the 60-second time window.
        This is the "sliding" part of the window.
        """
        cutoff_time = current_time - self.window_seconds
        
        # Remove from the left (oldest) until the oldest call is within the window
        while self.call_timestamps and self.call_timestamps[0] < cutoff_time:
            self.call_timestamps.popleft()
    
    def acquire(self, timeout: Optional[float] = None) -> bool:
        """
        Attempt to acquire permission for an API call, waiting if necessary.
        
        Args:
            timeout: Maximum seconds to wait (None = wait indefinitely)
            
        Returns:
            True if call is allowed, False if timeout exceeded
        """
        start_time = time.time()
        
        while True:
            with self.lock:
                current_time = time.time()
                self._clean_old_timestamps(current_time)
                
                # --- Check Main Per-Minute Limit ---
                if len(self.call_timestamps) < self.calls_per_minute:
                    
                    # --- Check Burst Limit ---
                    # This logic checks if a burst would be *violated* by this new call
                    recent_calls = sum(1 for ts in self.call_timestamps 
                                     if current_time - ts < self.burst_window_seconds)
                    
                    if recent_calls < self.burst_size:
                        # We are under BOTH limits. Success!
                        self.call_timestamps.append(current_time)
                        return True

                # --- If we're here, a limit was hit. Calculate wait time. ---
                # We must wait for the oldest call in the 60s window to expire.
                if not self.call_timestamps:
                    # Should be impossible if limits hit, but a good safeguard
                    wait_time = 0.1 
                else:
                    oldest_timestamp = self.call_timestamps[0]
                    # Calculate time until the oldest call is 60s old
                    wait_time = (oldest_timestamp + self.window_seconds) - current_time
                    # Ensure we always wait a small positive amount to avoid
                    # a "busy-loop" (spinning 100% CPU)
                    wait_time = max(0.01, wait_time) 
            
            # --- Wait *outside* the lock to allow other threads to run ---
            
            # Check for timeout
            if timeout is not None:
                elapsed = time.time() - start_time
                if elapsed + wait_time > timeout:
                    return False  # Will exceed timeout
                # Adjust wait_time if it would go over the timeout
                wait_time = min(wait_time, timeout - elapsed)

            time.sleep(wait_time)

    def get_stats(self) -> dict:
        """Get current rate limiter statistics."""
        with self.lock:
            # Pass time to ensure stats are for "now"
            self._clean_old_timestamps(time.time()) 
            available = self.calls_per_minute - len(self.call_timestamps)
            return {
                "calls_in_window": len(self.call_timestamps),
                "calls_per_minute_limit": self.calls_per_minute,
                "available_calls": max(0, available) # Can't be negative
            }

# --- Improved rate_limited_call Function ---

# Global rate limiter instance for Gemini API
gemini_rate_limiter = RateLimiter(calls_per_minute=15, burst_size=5)


def _is_transient_error(error_obj) -> bool:
    """
    Helper to check if an error is temporary and worth retrying.
    Checks for 429 (Rate Limit) and 5xx (Server) errors.
    """
    error_str = str(error_obj).lower()
    
    # Check for 429 Rate Limit
    if "429" in error_str or "rate_limit" in error_str or "resource_exhausted" in error_str:
        return True
        
    # Check for 5xx Server Errors (500, 502, 503, 504)
    if any(code in error_str for code in ["500", "502", "503", "504", "server error"]):
        return True
        
    return False


def rate_limited_call(func, *args, max_retries: int = 3, **kwargs):
    """
    Execute a function with rate limiting and robust retry logic.
    
    Args:
        func: Function to call (typically an LLM function)
        max_retries: Maximum retry attempts on failure
        *args, **kwargs: Arguments to pass to func
        
    Returns:
        Function result or error dict
    """
    for attempt in range(max_retries):
        # 1. Acquire rate limit token
        if not gemini_rate_limiter.acquire(timeout=30.0):
            return {
                "error": "rate_limit_exceeded",
                "message": "Rate limit timeout after 30 seconds"
            }
        
        try:
            # 2. Attempt the API call
            result = func(*args, **kwargs)
            
            # 3. Check if the *result itself* is an error (common with LLM wrappers)
            if isinstance(result, dict) and "error" in result:
                if _is_transient_error(result["error"]) and attempt < max_retries - 1:
                    wait_time = (attempt + 1) * 2  # Exponential backoff
                    print(f"LLM call failed (transient error), retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                    time.sleep(wait_time)
                    continue
                else:
                    # Not a transient error or max retries hit
                    return result 
            
            # 4. Success
            return result
            
        except Exception as e:
            # 5. Catch *raised exceptions* (e.g., litellm.RateLimitError)
            print(f"Exception in LLM call: {e}")
            if _is_transient_error(e) and attempt < max_retries - 1:
                wait_time = (attempt + 1) * 2
                print(f"Retrying in {wait_time}s... (attempt {attempt + 1}/{max_retries})")
                time.sleep(wait_time)
            else:
                # Not a transient error or max retries hit, fail fast
                return {
                    "error": "execution_failed",
                    "message": str(e)
                }
    
    # 6. Fallback error if loop finishes (should be rare)
    return {
        "error": "max_retries_exceeded",
        "message": f"Failed after {max_retries} attempts"
    }