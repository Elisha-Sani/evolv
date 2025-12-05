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