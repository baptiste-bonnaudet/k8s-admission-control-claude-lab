# Exercise 03 — Write a disallow-hostpath Policy

## Scenario

Your security team requires that no workload in the `cel-lab` namespace mounts host filesystem paths. hostPath volumes give containers direct access to the node filesystem and are a common lateral movement vector.

Write a ValidatingAdmissionPolicy that enforces this.

## Task

Write a `ValidatingAdmissionPolicy` and `ValidatingAdmissionPolicyBinding` that:

1. Targets Pods in namespaces with label `admission.lab.example.com/cel-lab: "true"`
2. Denies any Pod that declares a `hostPath` volume
3. Allows Pods with no volumes or volumes of other types (emptyDir, configMap, secret, etc.)

## Acceptance criteria

```bash
# Should be denied
kubectl apply -f modules/02-cel/manifests/bad/cel-bad-hostpath.yaml

# Should be admitted
kubectl apply -f modules/02-cel/manifests/good/cel-good-restricted.yaml
```

## CEL hint

The volumes field is optional on a Pod spec. Think about what happens when `spec.volumes` does not exist before iterating over it.

## Useful reference

See `modules/02-cel/policies/03-disallow-hostpath.yaml` for the reference implementation.

## Solution

See `solution/` for the complete policy.
