# Exercise 04 — Write a require-seccomp Policy

## Scenario

Your platform team wants every Pod in the `cel-lab` namespace to have a seccomp profile set at the Pod level. Seccomp restricts the system calls available to container processes and is required by the restricted PSS profile. The `RuntimeDefault` or `Localhost` types are both acceptable.

Write a ValidatingAdmissionPolicy that enforces this.

## Task

Write a `ValidatingAdmissionPolicy` and `ValidatingAdmissionPolicyBinding` that:

1. Targets Pods in namespaces with label `admission.lab.example.com/cel-lab: "true"`
2. Denies any Pod that does not have a `seccompProfile` set at `spec.securityContext`
3. Accepts `RuntimeDefault` or `Localhost` types
4. Denies `Unconfined` and missing seccomp settings

## Acceptance criteria

```bash
# Should be denied (no seccompProfile)
kubectl apply -f modules/01-psa/manifests/bad/missing-seccomp.yaml
# (apply in a cel-lab namespace copy if needed)

# Should be admitted
kubectl apply -f modules/02-cel/manifests/good/cel-good-restricted.yaml
```

## CEL hint

`spec.securityContext` and `spec.securityContext.seccompProfile` are both optional fields on a Pod. You need to guard each level of access. The final check needs to compare the `type` string field.

## Useful reference

See `modules/02-cel/policies/05-require-security-context.yaml` for a complete security context policy that includes seccomp enforcement alongside other controls.

## Solution

See `solution/` for the standalone seccomp policy.
