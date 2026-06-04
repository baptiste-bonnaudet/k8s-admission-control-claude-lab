# k8s-policy-lab

Local Kubernetes admission-control lab using Docker Desktop Kubernetes.

## Tools

- Pod Security Standards: Kubernetes-defined pod security profiles.
- Pod Security Admission: built-in admission controller enforcing PSS with namespace labels.
- Kyverno: Kubernetes-native policy engine using YAML policies.
- ValidatingAdmissionPolicy: native Kubernetes admission validation using CEL.
- CEL: expression language used for native Kubernetes validation.
- OPA/Gatekeeper: Rego-based admission policy engine.

## Mental model

PSA gives a baseline.
Kyverno, CEL, and Gatekeeper provide custom policy.
