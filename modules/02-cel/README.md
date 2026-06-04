# Module 02 — ValidatingAdmissionPolicy + CEL

## What this module covers

ValidatingAdmissionPolicy (VAP) is native Kubernetes admission validation using the CEL expression language. It runs inside the API server — no external webhook controller required.

Two objects work together:

```
ValidatingAdmissionPolicy    = the policy logic (CEL expressions)
ValidatingAdmissionPolicyBinding = scope and enforcement action
```

Enforcement actions on the Binding:

```yaml
validationActions: [Deny]           # blocks admission
validationActions: [Warn]           # warns client, allows
validationActions: [Audit]          # records to audit log, allows
validationActions: [Warn, Audit]    # warn + audit, allows
```

Do not combine `Deny` with `Warn` or `Audit` in the same binding.

## Prerequisites

- Kubernetes 1.30+ (VAP GA)
- `kubectl` connected to your cluster
- Check support: `kubectl api-resources | grep -i validatingadmission`

## Scenario

Your platform team needs custom policy beyond what PSA provides: required ownership labels, approved container registries, and hardened security context settings. PSA cannot enforce these — they are organization-specific rules. You will implement them using ValidatingAdmissionPolicy.

## Setup

```bash
kubectl apply -f modules/02-cel/setup/
```

This creates the `cel-lab` namespace with the label that the policy bindings target.

Verify:

```bash
kubectl get ns cel-lab --show-labels
```

## Apply all reference policies

```bash
kubectl apply -f modules/02-cel/policies/
```

This applies all five policies. Check they are active:

```bash
kubectl get validatingadmissionpolicy
kubectl get validatingadmissionpolicybinding
```

## Test bad manifests

```bash
kubectl apply -f modules/02-cel/manifests/bad/cel-bad-labels.yaml
# Expected: denied — missing required labels

kubectl apply -f modules/02-cel/manifests/bad/cel-bad-registry.yaml
# Expected: denied — unapproved registry

kubectl apply -f modules/02-cel/manifests/bad/cel-bad-hostpath.yaml
# Expected: denied — hostPath volume

kubectl apply -f modules/02-cel/manifests/bad/cel-bad-privileged.yaml
# Expected: denied — privileged container
```

## Test good manifests

```bash
kubectl apply -f modules/02-cel/manifests/good/cel-good-labels.yaml
kubectl apply -f modules/02-cel/manifests/good/cel-good-registry.yaml
kubectl apply -f modules/02-cel/manifests/good/cel-good-restricted.yaml
```

## Switch from deny to warn/audit

To observe without blocking, patch the binding (not the policy):

```bash
kubectl patch validatingadmissionpolicybinding required-workload-labels-binding.lab.example.com \
  --type='json' \
  -p='[{"op":"replace","path":"/spec/validationActions","value":["Warn","Audit"]}]'
```

## CEL rules of thumb

Use CEL when:
- The rule is simple and stable
- The field path is clear
- No mutation is needed
- No rich exception lifecycle is needed
- You want to avoid a webhook dependency

Avoid CEL or use Kyverno/Gatekeeper when:
- Expressions become deeply nested
- You need mutation
- You need PolicyReports
- You need image signature verification
- You need complex, governed exceptions

## Exercises

- [Exercise 01 — Fix a missing has() guard](exercises/01-fix-missing-has-guard/README.md)
- [Exercise 02 — Fix an init container bypass](exercises/02-fix-init-bypass/README.md)
- [Exercise 03 — Write a disallow-hostpath policy](exercises/03-write-disallow-hostpath/README.md)
- [Exercise 04 — Write a require-seccomp policy](exercises/04-write-require-seccomp/README.md)
