#!/bin/bash

# 🚀 Starting deployment script

# 🔑 Setup OpenShift OAuth provider
echo
echo "🔑 Setting up OpenShift OAuth provider..."
cd ./openshift/oauth || exit
./setup.sh

echo
echo "⏳ Waiting for OAuth provider to be ready..."
while true; do
  OAUTH_POD_STATUS=$(oc get pods -n openshift-authentication -l app=oauth-openshift -o jsonpath='{.items[0].status.phase}')
  if [ "$OAUTH_POD_STATUS" == "Running" ]; then
    echo "✅ OAuth provider is running."
    break
  fi
  echo "⏳ OAuth provider is not ready yet. Waiting..."
  sleep 5
done

# 📝 Prepare deployment files for OpenShift using templates and variables
echo
echo "📝 Preparing deployment files..."
cd ..
./preparation.sh
cd ..

# ☸️ Deploy LiteLLM, LitemaaS and corresponding components to OpenShift
echo
echo "☸️ Deploying LiteLLM and LitemaaS components..."
oc apply -k ./openshift

# 🦙 Deploy Llama server to OpenShift
echo
echo "🦙 Deploying Llama server..."
oc apply -k ./openshift/llama-server

# 📦 Get and set up models at Llama server deployed in OpenShift
echo
echo "📦 Setting up models on Llama server..."
./openshift/llama-server/get-models/setup-get-model.sh

# ✅ Deployment complete
echo
echo "✅ Deployment finished successfully!"
echo