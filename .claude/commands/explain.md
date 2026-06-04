Ask the user to share the admission control error they received, or read it from recent context.

1. Identify the admission layer from the error text using this mapping:
   - `violates PodSecurity` → PSA
   - `admission webhook "validate.kyverno..." denied` → Kyverno
   - `ValidatingAdmissionPolicy ... denied` → CEL/VAP
   - `admission webhook "validation.gatekeeper..." denied` → Gatekeeper
   - `forbidden: User ... cannot` → RBAC (not an admission policy)

2. Explain why that specific rule fired — name the policy object and the field or condition that triggered the denial.

3. Show what the workload needs to change to pass. Reference the relevant policy file from the module's `policies/` directory if one exists.

Keep the explanation concise. This audience is experienced — skip basics, go straight to the specific cause and fix.
