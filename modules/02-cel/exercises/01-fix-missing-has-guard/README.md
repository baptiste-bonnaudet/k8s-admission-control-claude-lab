# Exercise 01 — Fix a Missing has() Guard

## Scenario

A colleague wrote a ValidatingAdmissionPolicy to restrict container images to approved registries. The policy looks correct for the common case, but it crashes when applied to Pods that have no `initContainers` field.

A platform engineer reported that applying certain Pods returns an unexpected evaluation error instead of a clean deny.

## Task

1. Apply the broken policy:

```bash
kubectl apply -f modules/02-cel/exercises/01-fix-missing-has-guard/challenge.yaml
```

2. Apply a Pod with no initContainers to observe the evaluation error:

```bash
kubectl apply -f modules/02-cel/manifests/bad/cel-bad-registry.yaml
```

3. Identify the bug in the CEL expression.

4. Fix the policy so it correctly evaluates Pods with and without `initContainers`.

## Acceptance criteria

- Pods with no `initContainers` that use an unapproved registry are denied cleanly
- Pods with `initContainers` using an unapproved registry are also denied
- Pods from approved registries are admitted regardless of whether `initContainers` is present

## The core CEL mechanic

In CEL, accessing a field that does not exist on the object returns an error, not `false`. Use `has()` to guard optional fields before accessing them:

```text
!has(object.spec.initContainers)
|| object.spec.initContainers.all(c, ...)
```

## Solution

See `solution/` for the fixed policy.
