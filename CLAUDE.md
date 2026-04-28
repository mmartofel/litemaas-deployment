# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Deployment automation for **LiteMaaS** — a proof-of-concept LLM subscription and API key management platform — on **OpenShift**. It orchestrates four components: PostgreSQL, LiteLLM (AI proxy), LiteMaaS backend, and LiteMaaS frontend. Container images are hosted at `quay.io/rh-aiservices-bu/litemaas-backend` and `quay.io/rh-aiservices-bu/litemaas-frontend`.

## Deployment Flow

1. **Configure** — copy `openshift/user-values.env.example` → `openshift/user-values.env` and fill in values
2. **Setup OAuth** — `./setup.sh` (or manually: `cd openshift/oauth && ./setup.sh`)
3. **Generate `.local` files** — `cd openshift && ./preparation.sh`
4. **Deploy core stack** — `oc apply -k ./openshift`
5. **Deploy Llama server** — `oc apply -k ./openshift/llama-server`
6. **Pull models** — `./openshift/llama-server/get-models/setup-get-model.sh`

The full end-to-end run is wrapped in `./setup.sh` (root).

## Template System

Files ending in `.template` are the source of truth. `openshift/preparation.sh` runs `envsubst` over them using variables from `user-values.env`, producing `.local` files (gitignored). The `kustomization.yaml.local` output is renamed to `kustomization.yaml`, which is what `oc apply -k` consumes.

Never edit `.local` files directly — they are regenerated each run.

`CLUSTER_DOMAIN_NAME` is not a user variable — it is auto-detected at runtime by both `preparation.sh` and `oauth/setup.sh` via `oc get ingresses.config/cluster`.

## Key Configuration Variables (`user-values.env`)

| Variable | Purpose |
|---|---|
| `LITEMAAS_VERSION` | Image tag for backend/frontend |
| `NAMESPACE` | Target OpenShift namespace |
| `LITELLM_API_KEY` | Must start with `sk-` |
| `ADMIN_API_KEY` | Protects LiteMaaS management endpoints only (not LLM access) |
| `NODE_TLS_REJECT_UNAUTHORIZED=0` | Set to bypass self-signed cert issues; remove for clusters with valid certs |

## OAuth Setup

`openshift/oauth/setup.sh` creates:
- An `OAuthClient` resource (`litemaas-oauth-client`)
- An htpasswd identity provider with three test users: `admin/admin`, `user1/user1`, `user2/user2`
- Three groups: `litemaas-admins`, `litemaas-readonly`, `litemaas-users`
- Grants `cluster-admin` to the `admin` user

For production, replace the htpasswd provider with your organization's IdP.

## Llama Server (Ollama)

Deployed separately via `openshift/llama-server/kustomization.yaml`. Two deployment variants exist:
- `deployment.yaml` — GPU-based (default)
- `deployment-cpu.yaml` — CPU-only (uncomment in kustomization to use)

Models are pulled via the Ollama HTTP API after the pod is running. Default models pulled: `granite4`, `llama2`, `mistral`.

## Validation

After deployment, use `openshift/VALIDATION.md` as a checklist. Quick health checks:

```bash
oc get pods -n <namespace>                             # all should be 1/1 Running
oc exec -n <namespace> -l app=backend -- curl -s http://localhost:8080/api/v1/health
oc exec -n <namespace> -l app=litellm -- curl -s http://localhost:4000/health/liveness
```

## Client Scripts (`client/`)

Test clients for talking to the deployed stack:

- `ask-litemaas.py` — interactive streaming chat via LiteMaaS (OpenAI-compatible API)
- `ask-litellm.py` — same but against LiteLLM directly
- `curl.sh` — minimal curl example against the LiteLLM `/v1/chat/completions` endpoint
- `venv.sh` — sets up Python 3.14 venv with `litellm` package (macOS/Homebrew)

Update `API_BASE` and `API_KEY` in the Python scripts before use.

## Access Points After Deployment

- LiteMaaS UI: `https://litemaas-<namespace>.<cluster-domain>`
- LiteLLM Admin UI: `https://litellm-<namespace>.<cluster-domain>`
- Ollama API: `https://llama-<namespace>.<cluster-domain>`
