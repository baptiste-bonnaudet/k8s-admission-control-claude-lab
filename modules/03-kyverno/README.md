# Module 03 — Kyverno

## What this module covers

Kyverno is a Kubernetes-native policy engine that runs as an admission webhook and controller. Policies are written as Kubernetes custom resources in YAML.

Kyverno can:
- **Validate** — allow or deny resources
- **Mutate** — modify resources before persistence (defaults, patches)
- **Generate** — create resources when other resources are created
- **Verify images** — enforce signature and attestation requirements
- **Report** — produce PolicyReport objects for audit and visibility

## Prerequisites

- Kyverno installed in the cluster (see `setup/docker-desktop.md` or `setup/kind.md`)
- Kyverno CLI installed for offline validation (`brew install kyverno` on macOS)

Verify Kyverno is running:

```bash
kubectl -n kyverno get pods
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | grep kyverno
```

## Scenario

Your platform team is rolling out Kyverno as the primary policy engine. You need to implement ownership labels, registry restrictions, and security context requirements. You will also write a mutation policy to automatically add safe defaults when they are missing, reducing friction for developers.

## Setup

```bash
kubectl apply -f modules/03-kyverno/setup/
```

Verify the namespace:

```bash
kubectl get ns kyverno-lab --show-labels
```

## Apply reference policies

```bash
kubectl apply -f modules/03-kyverno/policies/
```

Check policies are active:

```bash
kubectl get cpol -A
kubectl describe cpol require-workload-labels
```

## failureAction: Audit vs Enforce

```yaml
failureAction: Audit    # allows, reports to PolicyReport
failureAction: Enforce  # blocks admission
```

Start new policies in `Audit` mode, collect reports, fix common patterns, then switch to `Enforce`:

```bash
# Check policy reports
kubectl get policyreport -A
kubectl describe policyreport -n kyverno-lab
```

## Test bad manifests

```bash
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-labels.yaml
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-registry.yaml
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-privileged.yaml
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-missing-security.yaml
```

## Test good manifest

```bash
kubectl apply -f modules/03-kyverno/manifests/good/kyverno-good.yaml
```

## Debugging Kyverno

```bash
kubectl get cpol,pol -A
kubectl describe cpol <policy-name>
kubectl -n kyverno get pods
kubectl -n kyverno logs deploy/kyverno-admission-controller --tail=100
kubectl get policyreport -A
```

Kyverno denial error shape:

```text
admission webhook "validate.kyverno.svc-fail" denied the request
resource Pod/kyverno-lab/bad-pod was blocked due to the following policies
require-workload-labels/require-ownership-labels: ...
```

## Offline validation with kyverno CLI

```bash
kyverno apply modules/03-kyverno/policies/ \
  --resource modules/03-kyverno/manifests/bad/kyverno-bad-labels.yaml
```

## Exercises

- [Exercise 01 — Fix a policy stuck in Audit mode](exercises/01-fix-audit-to-enforce/README.md)
- [Exercise 02 — Fix a namespace mismatch](exercises/02-fix-namespace-mismatch/README.md)
- [Exercise 03 — Write a require-labels policy](exercises/03-write-require-labels/README.md)
- [Exercise 04 — Write a mutation policy](exercises/04-write-mutation/README.md)
