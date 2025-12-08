import from byllm.lib {Model}
import utils.rate_limiter as limiter;

# 1. SETUP THE BRAIN 🧠
# Make sure you have your GEMINI_API_KEY set in your environment variables!
glob llm = Model(model_name="gpt-4o");

# 2. DEFINE THE OUTPUT SCHEMA 📝
obj AssessmentResult {
    has score: int;             # 0-10 feasibility score
    has verdict: str;           # "GO", "NO GO", "CAUTION"
    has red_flags: list[str];   # Specific technical risks
    has alternative_plan: str;  # The "Boring" solution
}

# 3. DEFINE SEMANTICS (Guidance for the AI) 🧭
sem AssessmentResult.score = "A feasibility score from 0 to 10. 10 is perfect, 0 is impossible.";
sem AssessmentResult.verdict = "A short verdict: 'GO', 'NO GO', or 'CAUTION'.";
sem AssessmentResult.red_flags = "A list of specific technical bottlenecks (e.g., latency, cost).";
sem AssessmentResult.alternative_plan = "A boring, standard, non-AI or simpler alternative solution.";

# 4. THE AI-POWERED ASSESSMENT FUNCTION 🤖
"""
You are EVOLV, a skeptical Senior Principal Engineer.
Your goal is to prevent over-engineering.
Review the following project details.
If the USER ROLE is a beginner and the STACK is complex, lower the score.
If LATENCY is 'Real-time' but the stack uses slow APIs, flag it as a critical failure.
"""
def do_assessment(role: str, stack: str, proposal: str, latency_req: str) -> AssessmentResult 
    by llm(method="reason");

# 5. THE CONSULTANT WALKER 🕵️‍♂️
walker FeasibilityConsultant {
    # Inputs
    has role: str;
    has stack: str;
    has tech_idea: str;
    has latency_req: str;

    # Output container (initialized to None, will be populated by AI)
    has final_report: AssessmentResult | None = None;

    can assess_project with `root entry {
        # Call the AI assessment function with the walker's attributes
        self.final_report = limiter.rate_limited_call(
            do_assessment(
                self.role, 
                self.stack, 
                self.tech_idea, 
                self.latency_req
            );
        );

        # Report the result (this makes it available to the spawning context)
        report self.final_report;
    }
}

# 6. RUN IT (The Entry Point) 🚀
with entry {
    # Create the consultant with the data
    consultant = FeasibilityConsultant(
        role="Solo Founder",
        stack="Python, Django, PostgreSQL",
        tech_idea="I want to use a heavy LangChain Agent for a simple Contact Form validator.",
        latency_req="Real-time (<200ms)"
    );

    # Spawn the consultant walker at the root node
    result = consultant spawn root;
    
    # Print the assessment
    if result.final_report {
        print("=== FEASIBILITY ASSESSMENT REPORT ===");
        print(f"Score: {result.final_report.score}/10");
        print(f"Verdict: {result.final_report.verdict}");
        print(f"Red Flags: {result.final_report.red_flags}");
        print(f"Alternative: {result.final_report.alternative_plan}");
    }
}