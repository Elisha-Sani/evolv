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