"""
EVOLV - The Ruthless CTO
A Decision Support System that prevents tech gluttony and over-engineering.
"""

import from byllm.lib {Model}



# ============================================================================
# BACKEND: AI Brain & Data Models
# ============================================================================

# Setup the AI model
glob llm = Model(model_name="gemini/gemini-2.0-flash");

# Output Schema
obj AssessmentResult {
    has score: int;
    has verdict: str;
    has red_flags: list[str];
    has alternative_plan: str;
}

# Semantic Guidance
sem AssessmentResult.score = "Feasibility score 0-10. 10=perfect, 0=impossible.";
sem AssessmentResult.verdict = "Short verdict: 'GO', 'NO GO', or 'CAUTION'.";
sem AssessmentResult.red_flags = "Specific technical bottlenecks (latency, cost, complexity).";
sem AssessmentResult.alternative_plan = "Boring, standard, non-AI alternative solution.";

# AI Assessment Function
"""
You are EVOLV, a skeptical Senior Principal Engineer who prevents over-engineering.
Your mission: Identify "tech gluttony" where developers use complex AI/blockchain
for simple problems that need basic solutions.

CRITICAL RULES:
1. If USER ROLE is "Solo Founder" or "Junior Dev" and STACK is complex → lower score
2. If LATENCY is "Real-time (<200ms)" but PROPOSAL uses slow APIs/LLMs → score < 4
3. If proposal mentions AI/LLM/Agents for simple CRUD/forms → flag as over-engineering
4. Default to BORING solutions (regex, basic validation, SQL queries)

Be ruthless. Be logical. Anti-hype.
"""
def do_assessment(role: str, stack: str, proposal: str, latency_req: str) -> AssessmentResult 
    by llm(method="reason");

# Walker: Process Assessment Request
walker FeasibilityConsultant {
    has role: str;
    has stack: str;
    has tech_idea: str;
    has latency_req: str;

    can assess with `root entry {
        # Call AI assessment
        result = do_assessment(
            self.role, 
            self.stack, 
            self.tech_idea, 
            self.latency_req
        );
        
        # Report result to frontend
        report result;
    }
}

# ============================================================================
# FRONTEND: React Interface
# ============================================================================

cl import from react {useState}
#cl import ".styles.css";
cl {
    # Main App Component
    def app() -> any {
        # State Management
        let [role, setRole] = useState("Solo Founder");
        let [stack, setStack] = useState("");
        let [techIdea, setTechIdea] = useState("");
        let [latencyReq, setLatencyReq] = useState("Real-time (<200ms)");
        let [result, setResult] = useState(None);
        let [loading, setLoading] = useState(False);
        let [loadingText, setLoadingText] = useState("Analyzing Architecture...");

        # Loading Messages Rotation
        async def rotateLoadingMessages() -> None {
            messages = [
                "Analyzing Architecture...",
                "Calculating Latency Risks...",
                "Evaluating Tech Stack...",
                "Checking for Over-Engineering..."
            ];
            for msg in messages {
                setLoadingText(msg);
                await Promise(lambda resolve: any -> None {
                    setTimeout(resolve, 800);
                });
            }
        }

        # Submit Assessment
        async def handleSubmit() -> None {
            setLoading(True);
            setResult(None);
            
            # Start loading message rotation
            rotateLoadingMessages();

            # Call backend walker
            response = root spawn FeasibilityConsultant(
                role=role,
                stack=stack,
                tech_idea=techIdea,
                latency_req=latencyReq
            );

            # Get result from reports
            if response.reports and len(response.reports) > 0 {
                assessment = response.reports[0];
                setResult(assessment);
                print("Here are results");
            }
            
            setLoading(False);
        }

        # Determine UI color based on score
        def getScoreColor(score: int) -> str {
            if score >= 7 { return "#10B981"; }  # Green
            elif score >= 5 { return "#F59E0B"; }  # Amber
            return "#EF4444";  # Red
        }

        # Render
        return <div style={{
            "minHeight": "100vh",
            "background": "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
            "padding": "40px 20px",
            "fontFamily": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
        }}>
            <div style={{
                "maxWidth": "800px",
                "margin": "0 auto",
                "background": "white",
                "borderRadius": "20px",
                "padding": "40px",
                "boxShadow": "0 20px 60px rgba(0,0,0,0.3)"
            }}>
                # Header
                <div style={{"textAlign": "center", "marginBottom": "40px"}}>
                    <h1 style={{
                        "fontSize": "48px",
                        "fontWeight": "800",
                        "background": "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
                        "WebkitBackgroundClip": "text",
                        "WebkitTextFillColor": "transparent",
                        "marginBottom": "10px"
                    }}>EVOLV</h1>
                    <p style={{
                        "fontSize": "18px",
                        "color": "#6B7280",
                        "fontWeight": "500"
                    }}>The Ruthless CTO - Preventing Tech Gluttony</p>
                </div>

              #Form
                <div style={{"display": "flex", "flexDirection": "column", "gap": "24px"}}>
                    # Role Selection 
                    <div>
                        <label style={{
                            "display": "block",
                            "fontSize": "14px",
                            "fontWeight": "600",
                            "color": "#374151",
                            "marginBottom": "8px"
                        }}>Your Role</label>
                        <select 
                            value={role}
                            onChange={lambda e: any -> None { setRole(e.target.value); }}
                            style={{
                                "width": "100%",
                                "padding": "12px 16px",
                                "fontSize": "16px",
                                "border": "2px solid #E5E7EB",
                                "borderRadius": "10px",
                                "outline": "none"
                            }}
                        >
                            <option value="Solo Founder">Solo Founder</option>
                            <option value="Junior Developer">Junior Developer</option>
                            <option value="Senior Engineer">Senior Engineer</option>
                            <option value="Enterprise Team">Enterprise Team</option>
                        </select>
                    </div>

                    #Current Stack
                    <div>
                        <label style={{
                            "display": "block",
                            "fontSize": "14px",
                            "fontWeight": "600",
                            "color": "#374151",
                            "marginBottom": "8px"
                        }}>Current Tech Stack</label>
                        <input
                            type="text"
                            value={stack}
                            onChange={lambda e: any -> None { setStack(e.target.value); }}
                            placeholder="e.g., Python, Django, PostgreSQL"
                            style={{
                                "width": "100%",
                                "padding": "12px 16px",
                                "fontSize": "16px",
                                "border": "2px solid #E5E7EB",
                                "borderRadius": "10px",
                                "outline": "none"
                            }}
                        />
                    </div>

                    # Tech Idea
                    <div>
                        <label style={{
                            "display": "block",
                            "fontSize": "14px",
                            "fontWeight": "600",
                            "color": "#374151",
                            "marginBottom": "8px"
                        }}>Proposed Tech Idea</label>
                        <textarea
                            value={techIdea}
                            onChange={lambda e: any -> None { setTechIdea(e.target.value); }}
                            placeholder="e.g., Use LangChain Agent for contact form validation"
                            rows="4"
                            style={{
                                "width": "100%",
                                "padding": "12px 16px",
                                "fontSize": "16px",
                                "border": "2px solid #E5E7EB",
                                "borderRadius": "10px",
                                "outline": "none",
                                "resize": "vertical",
                                "fontFamily": "inherit"
                            }}
                        />
                    </div>

                    # Latency Requirement
                    <div>
                        <label style={{
                            "display": "block",
                            "fontSize": "14px",
                            "fontWeight": "600",
                            "color": "#374151",
                            "marginBottom": "8px"
                        }}>Latency Requirement</label>
                        <select 
                            value={latencyReq}
                            onChange={lambda e: any -> None { setLatencyReq(e.target.value); }}
                            style={{
                                "width": "100%",
                                "padding": "12px 16px",
                                "fontSize": "16px",
                                "border": "2px solid #E5E7EB",
                                "borderRadius": "10px",
                                "outline": "none"
                            }}
                        >
                            <option value="Real-time (<200ms)">Real-time (&lt;200ms)</option>
                            <option value="Fast (<1s)">Fast (&lt;1s)</option>
                            <option value="Moderate (<5s)">Moderate (&lt;5s)</option>
                            <option value="Async (No Constraint)">Async (No Constraint)</option>
                        </select>
                    </div>

                    #Submit Button
                    <button
                        onClick={handleSubmit}
                        disabled={loading or not stack or not techIdea}
                        style={{
                            "width": "100%",
                            "padding": "16px",
                            "fontSize": "18px",
                            "fontWeight": "700",
                            "color": "white",
                            "background": ("#9CA3AF" if loading or not stack or not techIdea else "linear-gradient(135deg, #667eea 0%, #764ba2 100%)"),
                            "border": "none",
                            "borderRadius": "10px",
                            "cursor": ("not-allowed" if loading or not stack or not techIdea else "pointer"),
                            "transition": "transform 0.2s"
                        }}
                    >
                        {"Consulting..." if loading else "Get Assessment"}
                    </button>
                </div>

                #Loading State
                {loading and <div style={{
                    "marginTop": "32px",
                    "padding": "24px",
                    "background": "#F3F4F6",
                    "borderRadius": "12px",
                    "textAlign": "center"
                }}>
                    <div style={{
                        "fontSize": "18px",
                        "fontWeight": "600",
                        "color": "#667eea",
                        "animation": "pulse 2s infinite"
                    }}>{loadingText}</div>
                </div>}

                # Results Display
                {result and not loading and <div style={{
                    "marginTop": "32px",
                    "padding": "32px",
                    "background": getScoreColor(result.score) if result.score < 5 else "#F3F4F6",
                    "borderRadius": "16px",
                    "border": "3px solid " + getScoreColor(result.score),
                    "animation": "fadeIn 0.5s"
                }}>
                    # Score Badge
                    <div style={{"textAlign": "center", "marginBottom": "24px"}}>
                        <div style={{
                            "display": "inline-block",
                            "padding": "16px 32px",
                            "background": "white",
                            "borderRadius": "50px",
                            "boxShadow": "0 4px 12px rgba(0,0,0,0.1)"
                        }}>
                            <span style={{
                                "fontSize": "48px",
                                "fontWeight": "800",
                                "color": getScoreColor(result.score)
                            }}>{result.score}/10</span>
                        </div>
                    </div>

                    # Verdict 
                    <div style={{
                        "textAlign": "center",
                        "marginBottom": "24px"
                    }}>
                        <span style={{
                            "fontSize": "28px",
                            "fontWeight": "700",
                            "color":("white" if result.score < 5 else getScoreColor(result.score)),
                            "textTransform": "uppercase",
                            "letterSpacing": "2px"
                        }}>{result.verdict}</span>
                    </div>

                    # Red Flags
                    {len(result.red_flags) > 0 and <div style={{
                        "marginTop": "24px",
                        "padding": "20px",
                        "background": "white",
                        "borderRadius": "12px"
                    }}>
                        <h3 style={{
                            "fontSize": "18px",
                            "fontWeight": "700",
                            "color": "#EF4444",
                            "marginBottom": "12px"
                        }}>🚨 Red Flags</h3>
                        <ul style={{
                            "margin": "0",
                            "paddingLeft": "20px",
                            "color": "#374151"
                        }}>
                            {result.red_flags.map(lambda flag: any -> any {
                                return <li key={flag} style={{
                                    "marginBottom": "8px",
                                    "fontSize": "15px",
                                    "lineHeight": "1.6"
                                }}>{flag}</li>;
                            })}
                        </ul>
                    </div>}

                    # Alternative Solution
                    <div style={{
                        "marginTop": "24px",
                        "padding": "20px",
                        "background": "white",
                        "borderRadius": "12px"
                    }}>
                        <h3 style={{
                            "fontSize": "18px",
                            "fontWeight": "700",
                            "color": "#10B981",
                            "marginBottom": "12px"
                        }}>💡 Boring Alternative (That Actually Works)</h3>
                        <p style={{
                            "margin": "0",
                            "color": "#374151",
                            "fontSize": "15px",
                            "lineHeight": "1.6"
                        }}>{result.alternative_plan}</p>
                    </div>
                </div>}
            </div>

        </div>;
    }
}