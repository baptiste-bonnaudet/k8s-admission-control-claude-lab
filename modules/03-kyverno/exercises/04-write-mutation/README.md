# Exercise 04 — Write a Mutation Policy

## Scenario

Your team has agreed that all Pods in `kyverno-lab` should have `allowPrivilegeEscalation: false` set per container. Rather than blocking developers who forget, you want to add this field automatically if it is missing — with a mutation policy.

This is a common "safe defaults" pattern: mutate to add secure fields that are missing, validate to block fields that are explicitly wrong.

## Task

Write a `ClusterPolicy` that:

1. Matches Pods in the `kyverno-lab` namespace
2. Mutates each container to add `securityContext.allowPrivilegeEscalation: false` if the field is not already set
3. Does not overwrite the field if it is already explicitly set to `false`
4. Uses the `+(field)` Kyverno patch operator (add-if-missing)

## Acceptance criteria

```bash
# Apply a Pod without allowPrivilegeEscalation
kubectl apply -f modules/03-kyverno/exercises/04-write-mutation/test-pod.yaml

# Inspect the admitted Pod — the field should be present
kubectl get pod test-mutation-pod -n kyverno-lab -o jsonpath='{.spec.containers[0].securityContext}'
# Expected output includes: "allowPrivilegeEscalation":false
```

## Useful reference

See `modules/03-kyverno/policies/05-mutate-add-seccomp.yaml` for the seccomp mutation pattern using `+(field)` at the pod level.

For container-level mutation, you need to target `spec.containers[*]` with a `patchStrategicMerge`.

## Solution

See `solution/` for the complete mutation policy.
