def lint_iam_policy(policy: dict) -> list:
    """
    Analyzes a generated IAM policy and returns a list of warnings.
    """
    warnings = []

    # Check version
    if policy.get("Version") != "2012-10-17":
        warnings.append("⚠️ Unusual policy version; expected '2012-10-17'.")

    # Check for Statement(s)
    statements = policy.get("Statement", [])
    if not isinstance(statements, list):
        statements = [statements]

    for i, stmt in enumerate(statements):
        location = f"Statement[{i}]"

        # Effect
        if stmt.get("Effect") not in ["Allow", "Deny"]:
            warnings.append(f"❗ {location}: Invalid or missing 'Effect'")

        # Action
        actions = stmt.get("Action", [])
        if isinstance(actions, str):
            actions = [actions]

        if "*" in actions:
            warnings.append(f"❗ {location}: Uses overly permissive Action '*'")

        # Resource
        resources = stmt.get("Resource", [])
        if isinstance(resources, str):
            resources = [resources]

        if "*" in resources:
            warnings.append(f"⚠️ {location}: Uses wildcard Resource '*'")

        # Missing keys
        for key in ["Action", "Resource", "Effect"]:
            if key not in stmt:
                warnings.append(f"❗ {location}: Missing required key '{key}'")

    return warnings
