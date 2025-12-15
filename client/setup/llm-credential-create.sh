# This is a trial of creating LLM credential for Ollama model in LiteLLM proxy
# not much success yet

curl -X POST "https://litellm-litemaas.apps.psotka.sandbox5324.opentlc.com/credentials" \
-H "Authorization: Bearer sk-n0fpy0a2zXS2PIsIIO7kpzPN6vexD4xbWnjMUT/kcVk=" \
-H "Content-Type: application/json" \
-d '{
  "credential_name": "dupa",
  "credential_info": {
    "provider": "Ollama"
  },
  "credential_values": {
    "provider": "Ollama"
  },
  "model_id": "99eafdbb-0cc8-4472-8a0b-6cb07f84998b"
}'