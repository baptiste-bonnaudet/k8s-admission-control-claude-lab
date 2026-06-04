# Module 04 — OPA/Gatekeeper

## What this module covers

Gatekeeper is the Kubernetes admission-controller integration for Open Policy Agent (OPA). Policies are written in Rego, a purpose-built declarative policy language.

Two objects work together:

```
ConstraintTemplate    = Rego logic + CRD definition for the constraint kind
Constraint            = instance of the template, with scope and parameters
```

This separation allows reusable policy logic (templates) with instance-specific configuration (constraints).

```yaml
# ConstraintTemplate defines the Rego and the CRD kind
kind: ConstraintTemplate
metadata:
  name: k8srequiredlabels  # becomes the constraint kind

# Constraint is an instance of that template
kind: K8sRequiredLabels    # the kind defined by the template
```

## Prerequisites

- Gatekeeper installed in the cluster (see `setup/docker-desktop.md` or `setup/kind.md`)
- Basic Rego familiarity (see `REFERENCE.md` section on OPA/Gatekeeper)

Verify Gatekeeper is running:

```bash
kubectl -n gatekeeper-system get pods
kubectl get validatingwebhookconfigurations | grep gatekeeper
```

## Scenario

Your organization uses OPA/Rego across multiple systems (Kubernetes, Terraform, CI pipelines). You need to implement the same admission controls as previous modules — required labels, approved registries, no privileged containers — using Gatekeeper so the policy logic is consistent with the broader governance stack.

## Setup

```bash
kubectl apply -f modules/04-gatekeeper/setup/
```

Verify the namespace:

```bash
kubectl get ns gatekeeper-lab
```

## Apply reference policies

ConstraintTemplates must be applied before the Constraints that use them. Apply the templates first:

```bash
kubectl apply -f modules/04-gatekeeper/policies/01-required-labels/constraint-template.yaml
kubectl apply -f modules/04-gatekeeper/policies/02-allowed-registries/constraint-template.yaml
kubectl apply -f modules/04-gatekeeper/policies/03-disallow-privileged/constraint-template.yaml
```

Wait for the CRDs to be created, then apply the constraints:

```bash
kubectl apply -f modules/04-gatekeeper/policies/01-required-labels/constraint.yaml
kubectl apply -f modules/04-gatekeeper/policies/02-allowed-registries/constraint.yaml
kubectl apply -f modules/04-gatekeeper/policies/03-disallow-privileged/constraint.yaml
```

Check the constraints are active and have no violations:

```bash
kubectl get constraints
kubectl describe k8srequiredlabels pods-must-have-required-labels
```

## enforcementAction: deny vs warn vs dryrun

On the Constraint (not the ConstraintTemplate):

```yaml
enforcementAction: deny     # blocks admission
enforcementAction: warn     # warns client, allows
enforcementAction: dryrun   # records violation, no client feedback
```

Start new policies with `dryrun`, inspect violations, then switch to `warn`, then `deny`:

```bash
kubectl get k8srequiredlabels pods-must-have-required-labels -o yaml
# Check status.violations for current violations
```

## Test bad manifests

```bash
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-bad-labels.yaml
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-bad-registry.yaml
kubectl apply -f modules/04-gatekeeper/manifests/bad/gatekeeper-privileged.yaml
```

## Test good manifest

```bash
kubectl apply -f modules/04-gatekeeper/manifests/good/gatekeeper-good.yaml
```

## Debugging Gatekeeper

```bash
kubectl get constrainttemplates
kubectl get constraints -A
kubectl describe k8srequiredlabels pods-must-have-required-labels
# Check status.violations for current violations

kubectl -n gatekeeper-system get pods
kubectl -n gatekeeper-system logs deployment/gatekeeper-controller-manager --tail=100
kubectl get validatingwebhookconfigurations | grep gatekeeper
```

Gatekeeper denial error shape:

```text
admission webhook "validation.gatekeeper.sh" denied the request
[pods-must-have-required-labels] Missing required labels: {"env", "owner"}
```

## Exercises

- [Exercise 01 — Fix a Rego bug](exercises/01-fix-rego-bug/README.md)
- [Exercise 02 — Write a Constraint for an existing template](exercises/02-write-constraint/README.md)
