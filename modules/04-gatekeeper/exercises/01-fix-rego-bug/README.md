# Exercise 01 — Fix a Rego Bug

## Scenario

A ConstraintTemplate was written to enforce required labels on Pods. The template was applied, a Constraint was created, but Pods without required labels are being admitted without error. The policy appears active — `kubectl get constraints` shows it exists — but it has no effect.

## Task

1. Apply the broken ConstraintTemplate and Constraint:

```bash
kubectl apply -f modules/04-gatekeeper/exercises/01-fix-rego-bug/challenge/
```

2. Apply a Pod that should be denied:

```bash
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-bad-labels.yaml
# Expect: denied — but it will be admitted with the broken policy
```

3. Read the Rego in the ConstraintTemplate. Identify why the violation rule never fires.

4. Fix the ConstraintTemplate.

5. Verify:

```bash
kubectl delete pod gatekeeper-bad-labels -n gatekeeper-lab
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-bad-labels.yaml
# Expect: admission denied
```

## Debugging approach

```bash
kubectl describe constrainttemplate challenge-k8srequiredlabels
# Look at status.byPod[].errors for Rego compilation errors

kubectl describe k8schallengerequiredlabels challenge-pods-must-have-labels
# Look at status.violations — if empty when violations should exist, the Rego has a logic bug
```

## The Rego model

In OPA/Rego:
- `input.review.object` is the Kubernetes resource being admitted
- `input.review.object.metadata.labels` is where labels live
- `input.review.object.spec.labels` does not exist — `spec` does not have a `labels` field on a Pod

## Solution

See `solution/` for the corrected ConstraintTemplate.
