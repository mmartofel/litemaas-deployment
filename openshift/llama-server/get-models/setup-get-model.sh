#!/bin/bash

# This is an example script demonstrating how to get and set up models at ollama server deployed in OpenShift.
# Make sure you have 'oc' CLI tool installed and configured to access your OpenShift cluster.
# Also, ensure 'jq' is installed for JSON processing.
# Prerequisite: The Llama server should be deployed and accessible.
# Login to OpenShift cluster with admin credentials before running this script.

# Check if llama server is running, if not, wait until it is running

echo
echo "⏳ Checking Llama server to be ready..."
while true; do
  LLAMA_POD_STATUS=$(oc get pods -n litemaas -l app=llama-server -o jsonpath='{.items[0].status.phase}')
  if [ "$LLAMA_POD_STATUS" == "Running" ]; then
    echo "✅ Llama server is running."
    break
  fi
  echo "⏳ Llama server is not ready yet. Waiting..."
  sleep 5
done

# 🔍 Get external route
LLAMA_HOST=$(oc get route llama -n litemaas -o jsonpath='{.spec.host}')

echo
echo "🌐 LLAMA HOST: $LLAMA_HOST"
echo

# 📥 Pull models
echo "⬇️  Pulling models..."
curl -s "https://$LLAMA_HOST/api/pull" -d '{"model":"granite4"}'
curl -s "https://$LLAMA_HOST/api/pull" -d '{"model":"llama2"}'
curl -s "https://$LLAMA_HOST/api/pull" -d '{"model":"mistral"}'

echo
echo "📦 Available models:"
echo

# 🧠 List models with icons
curl -s "https://$LLAMA_HOST/api/tags" \
  | jq -r '.models[].name' \
  | sed 's/^/🧩 /'

echo
echo "✅ Model setup complete."
echo