# k8s-admission-control-claude-lab

Hands-on Kubernetes admission control lab for experienced DevOps, Platform, and Security engineers.

This lab covers the four main layers of Kubernetes admission control: Pod Security Admission, ValidatingAdmissionPolicy/CEL, Kyverno, and OPA/Gatekeeper. Each module has reference policies, test manifests, and exercises. Claude is integrated as an adaptive tutor.

---

## Prerequisites

- A running Kubernetes cluster (1.30+)
- `kubectl` configured against your cluster
- Module-specific tools installed before starting each module (details in each module README)

**Choose your local cluster:**
- [Docker Desktop setup](setup/docker-desktop.md)
- [kind setup](setup/kind.md)

---

## Modules

| # | Module | Admission layer | Prerequisites |
|---|--------|----------------|---------------|
| [01](modules/01-psa/) | Pod Security Admission | Built-in namespace labels | kubectl only |
| [02](modules/02-cel/) | ValidatingAdmissionPolicy + CEL | API-server native | kubectl only (k8s 1.30+) |
| [03](modules/03-kyverno/) | Kyverno | Admission webhook | Kyverno installed |
| [04](modules/04-gatekeeper/) | OPA/Gatekeeper | Admission webhook | Gatekeeper installed |

## Learning paths

**Sequential (recommended)** — follow the module order. Each module builds on the mental model of the previous one: built-in controls first, then external webhook engines.

```
01-psa → 02-cel → 03-kyverno → 04-gatekeeper
```

**Jump in** — modules are self-contained. If you already know PSA and CEL, go straight to `03-kyverno` or `04-gatekeeper`. Each module README lists its own prerequisites and setup steps.

---

## Lab structure

```
modules/
  01-psa/
  02-cel/
  03-kyverno/
  04-gatekeeper/
    Each module:
      setup/           Namespace and cluster setup YAMLs
      policies/        Reference policy objects (VAP, ClusterPolicy, ConstraintTemplate)
      manifests/
        bad/           Workloads that violate the active policies
        good/          Workloads that pass the active policies
      exercises/       Challenges with instructions, challenge YAML, and solution

setup/               Cluster-level setup guides (Docker Desktop, kind)
scripts/             Validation helpers (dry-run, kyverno CLI)
REFERENCE.md         Comprehensive admission control reference
```

**`setup/` vs `policies/`**: namespace definitions and cluster infrastructure live in `setup/`. Admission policy objects (the rules themselves) live in `policies/`. This separation is intentional so it is always clear what is scaffolding and what is enforcement.

---

## Using Claude as a tutor

This lab is designed to be worked through with Claude Code. Open this repo in Claude Code and Claude will read `CLAUDE.md` and act as an adaptive tutor.

**How the tutor works:**

- Ask Claude anything about the concepts, policies, or errors you encounter
- During exercises, Claude is Socratic — it guides rather than just gives answers
- For reference questions (how does X work, compare A vs B), Claude answers directly

**Slash commands available in exercises:**

| Command | What it does |
|---------|-------------|
| `/hint` | One targeted nudge — moves you forward without revealing the answer |
| `/check` | Evaluates your current YAML against the exercise requirements |
| `/explain` | Identifies which admission layer blocked you and explains why |
| `/solution` | Shows the reference solution with explanation of each decision |

---

## Quick start

```bash
# Clone and open in Claude Code
git clone git@github.com:baptiste-bonnaudet/k8s-admission-control-claude-lab.git
cd k8s-admission-control-claude-lab
claude .

# Apply the first namespace (PSA module)
kubectl apply -f modules/01-psa/setup/

# Start Module 1
cat modules/01-psa/README.md
```

---

## Validation without a cluster

Use the scripts in `scripts/` to validate manifests and policies locally before applying them:

```bash
# Dry-run a manifest against a live cluster
./scripts/validate-dry-run.sh modules/01-psa/manifests/bad/privileged-pod.yaml

# Validate Kyverno policies with kyverno CLI (no cluster needed)
./scripts/validate-kyverno-cli.sh modules/03-kyverno/policies/ modules/03-kyverno/manifests/bad/
```

---

## Reference

`REFERENCE.md` covers every tool in depth: PSS/PSA, Kyverno, CEL/VAP, Gatekeeper, debugging patterns, production rollout sequence, and 20 interview questions with concise answers.
