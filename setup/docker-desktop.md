# Docker Desktop Setup

## Enable Kubernetes

1. Open Docker Desktop → Settings → Kubernetes
2. Check "Enable Kubernetes"
3. Click "Apply & Restart"
4. Wait for the green Kubernetes indicator

## Verify

```bash
kubectl config current-context
# Expected: docker-desktop

kubectl get nodes
# Expected: single node, Ready status
```

## Version check

```bash
kubectl version --short
```

This lab requires Kubernetes 1.30+ for full ValidatingAdmissionPolicy/CEL support.

If you are on an older version, Module 02 (CEL) requires 1.28+ (GA in 1.30). Modules 01, 03, and 04 work on any recent version.

## Kyverno install (Module 03)

```bash
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm install kyverno kyverno/kyverno \
  --namespace kyverno \
  --create-namespace \
  --wait
```

Verify:

```bash
kubectl -n kyverno get pods
kubectl get validatingwebhookconfigurations,mutatingwebhookconfigurations | grep kyverno
```

## Gatekeeper install (Module 04)

```bash
helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
helm repo update

helm install gatekeeper gatekeeper/gatekeeper \
  --namespace gatekeeper-system \
  --create-namespace \
  --wait
```

Verify:

```bash
kubectl -n gatekeeper-system get pods
kubectl get validatingwebhookconfigurations | grep gatekeeper
```
