# Exercise 02 — Fix an Init Container Bypass

## Scenario

Your team wrote a ValidatingAdmissionPolicy to enforce approved registries. In production review, a security engineer found that the policy only checks `spec.containers` — an attacker or misconfigured workload could pull an unapproved image via an init container without being blocked.

## Task

1. Apply the incomplete policy:

```bash
kubectl apply -f modules/02-cel/exercises/02-fix-init-bypass/challenge.yaml
```

2. Apply a Pod that uses an unapproved registry in an init container only:

```bash
kubectl apply -f modules/02-cel/exercises/02-fix-init-bypass/test-bypass.yaml
```

3. Observe that the Pod is admitted (the policy does not block it).

4. Fix the policy to also check `initContainers` and `ephemeralContainers`.

## Acceptance criteria

- Pods with unapproved registries in `spec.containers` are denied
- Pods with unapproved registries in `spec.initContainers` are denied
- Pods with unapproved registries in `spec.ephemeralContainers` are denied
- Pods from approved registries in all container types are admitted

## Why this matters

Every container type is an execution path. Policies that check only `spec.containers` leave init and ephemeral containers as blind spots for supply chain control, malware injection, and data exfiltration.

## Solution

See `solution/` for the complete policy covering all three container types.
