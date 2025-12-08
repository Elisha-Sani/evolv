import from byllm.lib { Model }

# glob llm = Model(model_name="gemin/gemini-2.0-flash");


# This acts like a schema for the AI response
obj AssessmentResult {
    has score: int;             # 0-10 feasibility score
    has verdict: str;           # "GO", "NO GO", "CAUTION"
    has red_flags: list[str];   # Specific technical risks
    has alternative_plan: str;  # The "Boring" solution
}

sem AssessmentResult = """The schema that structures the output""";
sem AssessmentResult.score = """This is the feasibility score for the suggested or recommended integration""";
sem AssessmentResult.verdict = """This is the verdict that tells the user whether to 'GO', 'NO GO' or 'CAUTION'""";
sem AssessmentResult.red_flags = """This are the specific technical risks that comes with the integration""";
sem AssessmentResult.alternative_plan = """This is the 'generic/boring' solution. The one that is not cool but works wonders.""";

# self.final_report = spawn here impl assessment_result by llm(
#             temperature=0.7,
#             method="reason", # Uses Chain of Thought if available
#             context = "You are EVOLV, a skeptical Senior Principal Engineer. "
#                       "Your goal is to prevent over-engineering. "
#                       "Review the following project details. "
#                       "If the USER ROLE is a beginner and the STACK is complex, lower the score. "
#                       "If LATENCY is 'Real-time' but the stack uses slow APIs, flag it as a critical failure."
#                       f"USER ROLE: {self.role} "
#                       f"CURRENT STACK: {self.stack} "
#                       f"PROPOSAL: {self.tech_idea} "
#                       f"LATENCY CONSTRAINT: {self.latency_req} "
#         );

#         # Return the report to the API
#         report self.final_report;


def do_assessment(role: str, stack: str, proposal: str, latency_req: str) -> AssessmentResult by llm(method = "reason", context="You are EVOLV, a skeptical Senior Principal Engineer. "
                      "Your goal is to prevent over-engineering. "
                      "Review the following project details. "
                      "If the USER ROLE is a beginner and the STACK is complex, lower the score. "
                      "If LATENCY is 'Real-time' but the stack uses slow APIs, flag it as a critical failure."
                      f"USER ROLE: {role} "
                      f"CURRENT STACK: {stack}"
                      f"PROPOSAL: {proposal} "
                      f"LATENCY CONSTRAINT: {latency_req}");

# Nodes
# User
node UserContext {
    has role: str; # e.g., "Solo Founder", "Enterprise Architect"
    has industry: str; # e.g., "FinTech", "HealthCare"
    has current_stack: str; # e.g., "React + Firebase" (Keep it a string for easier AI parsing)
}

# Tech idea
node TechProposal {
    has proposed_tech: str; # e.g., "LangChain + Pinecone"
    has target_feature: str; # e.g., "Chatbot for Customer Support"
    has primary_goal: str; # e.g., "Reduce support tickets"
}

# Constraints
node Constraints {
    has latency_req: str; # e.g., "Real-time (<200ms)", "Async (Seconds)"
    has budget_model: str; # e.g., "Fixed Cost", "Pay-as-you-go"
    has reliability: str; # e.g., "Critical (99.9%)", "Experimental"
}


walker FeasibilityConsoltant {
    has role: str;
    has stack: str;
    has tech_idea: str;
    has latency_req: str;

    has final_report: AssessmentResult;


    can assess_project with `root entry {

        

        # Return the report to the API
        report self.final_report;b
    }
}

with entry {
    content = 
}