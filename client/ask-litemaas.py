#!/usr/bin/env python3

# This script let you connect via OpenAI API to Ollama model server through LiteLLM proxy

from openai import OpenAI

# -------------------------------
# CONFIG
# -------------------------------
API_BASE = "https://litemaas-litemaas.apps.psotka.sandbox5324.opentlc.com" # put here your litellm proxy URL
API_KEY = "sk-f2wLN-QRji9ldFNKddi_cA" # now api key is required, even if LiteLLM proxy does not validate it
MODEL = "llama2"  # name must match what the proxy serves
# -------------------------------


def stream_chat():
    print("Interactive LLM client (Ctrl+C to exit)\n")

    # Init OpenAI client (for LiteLLM proxy)
    client = OpenAI(
        api_key=API_KEY,
        base_url=API_BASE
    )

    history = [
        {
            "role": "system",
            "content": "You are a helpful assistant. "
                       "Do NOT prefix your replies with labels."
        }
    ]

    while True:
        try:
            user_input = input("You: ")
        except (EOFError, KeyboardInterrupt):
            print("\nExiting.")
            break

        history.append({"role": "user", "content": user_input})

        print("Assistant: ", end="", flush=True)

        # STREAMING request via proxy
        response = client.chat.completions.create(
            model=MODEL,
            messages=history,
            stream=True
        )

        assistant_reply = ""

        for chunk in response:
            delta = chunk.choices[0].delta.content
            if delta:
                print(delta, end="", flush=True)
                assistant_reply += delta

        print()
        history.append({"role": "assistant", "content": assistant_reply})


if __name__ == "__main__":
    stream_chat()
