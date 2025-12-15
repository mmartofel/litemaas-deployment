curl -X POST https://litellm-litemaas.apps.psotka.sandbox5324.opentlc.com/v1/chat/completions \
-H "Authorization: Bearer sk-n0fpy0a2zXS2PIsIIO7kpzPN6vexD4xbWnjMUT/kcVk=" \
-H "Content-Type: application/json" \
-d \
 '{
    "model": "llama2",
    "messages": [
      {"role": "user", "content": "Hey, how are you?"}
    ]
  }'