# kind Setup

## Install kind

```bash
# macOS
brew install kind

# Linux
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind && mv ./kind /usr/local/bin/kind
```

## Create the lab cluster

```bash
kind create cluster --name policy-lab --config setup/kind-config.yaml
```

This creates a single-node cluster configured for this lab.

## Verify

```bash
kubectl config current-context
# Expected: kind-policy-lab

kubectl get nodes
# Expected: single node, Ready
```

## Version check

```bash
kubectl version --short
```

This lab requires Kubernetes 1.30+ for full ValidatingAdmissionPolicy/CEL support (GA in 1.30). kind 0.23 ships with Kubernetes 1.30 by default.

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

## Tear down

```bash
kind delete cluster --name policy-lab
```
