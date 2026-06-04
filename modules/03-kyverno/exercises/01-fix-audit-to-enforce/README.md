# Exercise 01 — Fix a Policy Stuck in Audit Mode

## Scenario

A colleague wrote a Kyverno ClusterPolicy to require ownership labels on all Pods in `kyverno-lab`. The policy was intentionally set to `Audit` mode during initial rollout. The rollout period is over — the team has fixed their workloads — but someone forgot to switch the policy to `Enforce`. Pods without labels are still being admitted.

## Task

1. Apply the challenge policy:

```bash
kubectl apply -f modules/03-kyverno/exercises/01-fix-audit-to-enforce/challenge.yaml
```

2. Verify that a Pod without labels is admitted (it should be, because the policy is in Audit mode):

```bash
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-labels.yaml
# Expect: Pod is created — no admission error
```

3. Check the PolicyReport to see the audit violation recorded:

```bash
kubectl get policyreport -n kyverno-lab
kubectl describe policyreport -n kyverno-lab
```

4. Fix the policy to block admission instead of just auditing.

5. Verify the fix:

```bash
kubectl delete pod kyverno-bad-labels -n kyverno-lab
kubectl apply -f modules/03-kyverno/manifests/bad/kyverno-bad-labels.yaml
# Expect: admission denied
```

## Acceptance criteria

- Pods without required labels are denied at admission
- Pods with required labels are admitted

## Solution

See `solution/` for the corrected policy.
