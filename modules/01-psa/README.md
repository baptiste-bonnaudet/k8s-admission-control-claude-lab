# Module 01 — Pod Security Admission

## What this module covers

Pod Security Admission (PSA) is the built-in Kubernetes admission controller that enforces Pod Security Standards (PSS) through namespace labels. No external tooling required — PSA is part of every Kubernetes cluster since 1.25.

PSS defines three profiles:
- `privileged` — unrestricted
- `baseline` — prevents known privilege escalation patterns, broadly compatible
- `restricted` — hardened, least-privilege

PSA enforces these profiles through three modes on a namespace:
- `enforce` — rejects violating Pods
- `warn` — allows but emits a client warning
- `audit` — allows but records the violation in audit logs

## Prerequisites

- `kubectl` connected to a cluster (no additional installs)
- See `setup/docker-desktop.md` or `setup/kind.md` at the repo root

## Scenario

Your platform team is hardening a new application namespace. The team wants to enforce the `restricted` PSS profile but does not want to break existing workloads in a surprise rollout. You will apply the standard "warn first, then enforce" sequence, understand what the restricted profile requires, and debug the common admission patterns.

## Setup

Apply the module namespace:

```bash
kubectl apply -f modules/01-psa/setup/
```

This creates the `policy-lab` namespace with PSA in warn and audit mode only. You will move it to enforce as part of the exercises.

Check the current labels:

```bash
kubectl get ns policy-lab --show-labels
kubectl describe ns policy-lab
```

## Test the bad manifests

```bash
# Each of these should warn (mode is warn/audit, not enforce yet)
kubectl apply -f modules/01-psa/manifests/bad/privileged-pod.yaml
kubectl apply -f modules/01-psa/manifests/bad/missing-runasnonroot.yaml
kubectl apply -f modules/01-psa/manifests/bad/missing-seccomp.yaml
kubectl apply -f modules/01-psa/manifests/bad/missing-no-priv-escalation.yaml
kubectl apply -f modules/01-psa/manifests/bad/missing-drop-all-capabilities.yaml
kubectl apply -f modules/01-psa/manifests/bad/hostpath.yaml
kubectl apply -f modules/01-psa/manifests/bad/privileged-focused.yaml
```

Note the warnings. Now test a good manifest:

```bash
kubectl apply -f modules/01-psa/manifests/good/restricted-pod.yaml
```

## Enable enforce mode

```bash
kubectl label ns policy-lab \
  pod-security.kubernetes.io/enforce=restricted \
  pod-security.kubernetes.io/enforce-version=latest \
  --overwrite
```

Now try the bad manifests again — they should be denied.

## Key debugging pattern

When a Deployment is accepted but no Pods appear:

```bash
kubectl describe deploy -n policy-lab <name>
kubectl get rs -n policy-lab
kubectl describe rs -n policy-lab <replicaset-name>
kubectl get events -n policy-lab --sort-by=.lastTimestamp
```

Look for `FailedCreate` events on the ReplicaSet. PSA applies at Pod creation, not at Deployment creation.

## Exercises

- [Exercise 01 — Fix a restricted pod](exercises/01-fix-restricted-pod/README.md)
- [Exercise 02 — Namespace PSA rollout](exercises/02-namespace-rollout/README.md)
