# Exercise 02 — Namespace PSA Rollout

## Scenario

A new team is onboarding a microservice into a namespace called `payments-api`. You are the platform engineer responsible for setting up the namespace with the right PSA configuration. The team has not tested their workloads against restricted yet, but you need to start gathering data now.

## Task

Write a namespace manifest for `payments-api` that:

1. **Does not enforce anything yet** — no blocking
2. **Warns** in client output when Pods would violate the `restricted` profile
3. **Audits** to Kubernetes audit logs when Pods would violate `restricted`
4. Pins both warn and audit to `latest`

Once you have the initial namespace, write a second version (or update) that:

5. Adds `enforce: restricted` at `latest`

## Acceptance criteria

**Phase 1 (warn/audit only):**
- Applying the namespace does not reject existing workloads
- Applying a privileged Pod emits a warning to the client but is not rejected
- Audit logs (or events) record the violation

**Phase 2 (enforce):**
- Applying a privileged Pod is denied with a message citing `PodSecurity "restricted"`
- A correctly-formed restricted Pod is admitted

## Test commands

```bash
# Apply your namespace
kubectl apply -f your-namespace.yaml

# Verify labels
kubectl get ns payments-api --show-labels

# Test with a bad pod (should warn, not block, in phase 1)
kubectl run bad-test -n payments-api \
  --image=nginxinc/nginx-unprivileged:1.27 \
  --overrides='{"spec":{"containers":[{"name":"app","image":"nginxinc/nginx-unprivileged:1.27","securityContext":{"privileged":true}}]}}'

# After adding enforce, the same command should be denied
```

## Solution

See `solution/` for a phase-1 and phase-2 namespace manifest.
