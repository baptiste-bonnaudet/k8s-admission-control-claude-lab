# Exercise 02 — Write a Constraint for an Existing Template

## Scenario

The `K8sAllowedRegistries` ConstraintTemplate has been applied to the cluster by another team. Your job is to write a Constraint that uses it to enforce approved registries in the `gatekeeper-lab` namespace.

The template is already deployed:

```bash
kubectl get constrainttemplate k8sallowedregistries
```

You only need to write and apply the Constraint.

## Task

Write a `K8sAllowedRegistries` Constraint that:

1. Targets Pods in the `gatekeeper-lab` namespace
2. Uses `enforcementAction: deny`
3. Passes these approved registry prefixes as parameters:
   - `registry.k8s.io/`
   - `nginxinc/`

## Acceptance criteria

```bash
# Should be denied — unapproved registry
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-bad-registry.yaml

# Should be admitted — approved registry
kubectl apply -f modules/04-gatekeeper/manifests/good/gatekeeper-good.yaml
```

## How Constraint parameters work

The `K8sAllowedRegistries` template expects:

```yaml
spec:
  parameters:
    registries:
      - "registry.k8s.io/"
      - "nginxinc/"
```

The template Rego reads these via `input.parameters.registries`.

## Useful reference

See `modules/04-gatekeeper/policies/02-allowed-registries/constraint.yaml` for the reference Constraint using the same template.

## Solution

See `solution/` for the complete Constraint.
