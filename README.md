# 🌟 LiteMaaS Deployment

[![GitHub Repo](https://img.shields.io/badge/GitHub-mmartofel-blue)](https://github.com/mmartofel/litemaas-deplyment)
[![OpenShift Ready](https://img.shields.io/badge/OpenShift-Ready-brightgreen)](https://www.openshift.com)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

---

## 📖 Overview

This repository contains **deployment scripts and templates** to run **LiteLLM**, **LiteMaaS**, and the **Ollama server** on **OpenShift**.  

**LiteMaaS** is a proof-of-concept application for managing LLM subscriptions, API keys, and usage tracking. It seamlessly integrates with LiteLLM to provide a unified interface for accessing multiple LLMs with comprehensive budget management.

Please visit **LiteMaaS** repository at https://github.com/rh-aiservices-bu/litemaas

Built with ❤️ by the [CAI Team](http://red.ht/cai-team)

It automates:

- OAuth setup  
- OpenShift deployment files preparation  
- LiteLLM & LitemaaS deployment  
- Llama server setup with AI models  

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔑 OAuth Setup | Automatic OpenShift OAuth provider configuration |
| 📝 Deployment Prep | Prepare deployment templates with variables |
| ☸️ LiteLLM & LitemaaS | Deploy core AI services on OpenShift |
| 🦙 Llama Server | Deploy and manage the Llama server |
| 📦 Model Management | Pull, list, and persist AI models |
| 🌈 Fancy Output | Terminal output enhanced with emojis and colors |

---

## 🛠 Prerequisites

> Make sure you have the following installed and configured:

- `oc` CLI with access to an OpenShift cluster  
- Admin privileges or permissions to create routes, deployments, PVCs  
- Bash shell (`#!/bin/bash`)  
- Internet access for pulling model images  

---

## ⚡ Quick Deployment

Before you begin please setup your Red Hat OpenShift cluster with correct SSL certifficates.
I experienced several issues with self signed ones therefore I created a repo explaining how to set OpenShift with Let's Encrypt issued certifficates. Please hear to this repo to check how it can be done:

- [https://github.com/mmartofel/ocp-lets-encrypt-certifficates](https://github.com/mmartofel/ocp-lets-encrypt-certifficates)

or do it your own, known way.

### 1️⃣ Clone the repository

```bash
git clone https://github.com/mmartofel/litemaas-deplyment.git
cd litemaas-deplyment
./setup.sh
```

This will:

🔑 Setup OpenShift OAuth provider

📝 Prepare deployment templates

☸️ Deploy LiteLLM and LitemaaS

🦙 Deploy example Llama server

📦 Pull and set up some simple AI models

---

### 🧠 Managing AI Models

#### List available models

```bash
LLAMA_HOST=$(oc get route llama -n litemaas -o jsonpath='{.spec.host}')

curl -s "https://$LLAMA_HOST/api/tags" \
  | jq -r '.models[].name' \
  | sed 's/^/🧩 /'
```

#### Pull a specific model

```bash
curl -s "https://$LLAMA_HOST/api/pull" -d '{"model":"granite4"}'
```

#### Pull multiple models sequentially

```bash
for model in granite4 llama2 mistral; do
  curl -s "https://$LLAMA_HOST/api/pull" -d "{\"model\":\"$model\"}"
done
```

--- 

### 📂 Directory Structure

```bash
openshift/
├── oauth/                    # OAuth setup scripts
├── llama-server/             # Llama server deployment & model setup scripts
├── kustomization.yaml        # OpenShift kustomization templates
setup.sh                     # Main deployment script
```

---

### 🔗 Useful Links

- [LiteLLM GitHub](https://github.com/BerriAI/litellm)
- [Ollama Server](https://ollama.com/)
- [OpenShift Documentation](https://docs.openshift.com)