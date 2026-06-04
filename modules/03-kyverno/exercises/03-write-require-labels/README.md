# Exercise 03 — Write a require-labels Policy

## Scenario

Your platform team wants to enforce that every Deployment in `kyverno-lab` includes standard ownership metadata: `team`, `app`, and `cost-center` labels. This is needed for cost attribution and incident routing.

Note: this exercise targets **Deployments**, not Pods directly. Think about how Kyverno matches resources and whether a ClusterPolicy rule needs to be adjusted for Deployment resources versus Pod resources.

## Task

Write a `ClusterPolicy` that:

1. Matches Deployments in the `kyverno-lab` namespace
2. Requires the labels: `team`, `app`, and `cost-center` in `metadata.labels`
3. Denies the Deployment at admission if any label is missing
4. Uses `Enforce` mode

## Acceptance criteria

```bash
# Should be denied — missing required labels
kubectl apply -f modules/03-kyverno/exercises/03-write-require-labels/test-bad-deployment.yaml

# Should be admitted
kubectl apply -f modules/03-kyverno/exercises/03-write-require-labels/test-good-deployment.yaml
```

## Useful reference

See `modules/03-kyverno/policies/01-require-labels.yaml` for a Pod-targeted require-labels example. Adapt it for Deployments.

The Kyverno `pattern` validate approach with `?*` matches any non-empty string.

## Solution

See `solution/` for the complete policy.
