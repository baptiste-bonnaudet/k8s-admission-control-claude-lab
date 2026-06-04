# Exercise 02 — Fix a Namespace Mismatch

## Scenario

A security engineer wrote a registry policy and applied it, but reports that Pods with unapproved images are still being admitted in `kyverno-lab`. After investigation, you find the policy exists but is targeting the wrong namespace.

## Task

1. Apply the broken policy:

```bash
kubectl apply -f modules/03-kyverno/exercises/02-fix-namespace-mismatch/challenge.yaml
```

2. Verify that a Pod with an unapproved registry is admitted in `kyverno-lab`:

```bash
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-registry.yaml
# Expect: Pod is created — policy is not matching
```

3. Inspect the policy to find why it is not matching `kyverno-lab`.

4. Fix the policy to correctly target `kyverno-lab`.

5. Verify the fix:

```bash
kubectl delete pod kyverno-bad-registry -n kyverno-lab
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-registry.yaml
# Expect: admission denied
```

## Debugging tip

```bash
kubectl describe cpol challenge-registry-wrong-namespace
# Look at the match.any[].resources.namespaces field
```

## Acceptance criteria

- Pods with unapproved registries are denied in `kyverno-lab`
- The policy does not affect other namespaces unintentionally

## Solution

See `solution/` for the corrected policy.
