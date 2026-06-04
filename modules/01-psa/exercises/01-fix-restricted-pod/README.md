# Exercise 01 — Fix a Restricted Pod

## Scenario

A developer submitted a Pod spec that was written before the namespace enforced the restricted PSS profile. The namespace `policy-lab` now has `enforce: restricted`. The Pod is being rejected at admission.

Your task is to fix the Pod so it passes the restricted profile without changing what the application does.

## Task

1. Apply the challenge manifest and observe the admission error:

```bash
kubectl apply -f modules/01-psa/exercises/01-fix-restricted-pod/challenge.yaml
```

2. Read the error. Identify which restricted requirements the Pod is missing.

3. Edit `challenge.yaml` (work in a copy) to fix all violations.

4. Apply again — the Pod should be admitted.

## Acceptance criteria

- `kubectl apply` succeeds with no warnings
- The Pod reaches `Running` status
- No security context fields are set to values that bypass the restricted profile

## Useful reference

The restricted profile requires all of the following on every Pod:

- `spec.securityContext.runAsNonRoot: true`
- `spec.securityContext.seccompProfile.type: RuntimeDefault` (or `Localhost`)
- Per container: `securityContext.allowPrivilegeEscalation: false`
- Per container: `securityContext.capabilities.drop: [ALL]`
- No `privileged: true`
- No `hostPath` volumes
- No host namespaces (`hostNetwork`, `hostPID`, `hostIPC`)

## Test

```bash
kubectl get pod challenge-restricted-pod -n policy-lab
kubectl describe pod challenge-restricted-pod -n policy-lab
```

## Clean up

```bash
kubectl delete pod challenge-restricted-pod -n policy-lab
```
