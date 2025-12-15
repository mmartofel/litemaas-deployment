#!/usr/bin/env python3

# This script let you connect straigth to Ollama model server by Ollama API

from litellm import completion

# -------------------------------
# CONFIG
# -------------------------------
API_BASE = "https://llama-litemaas.apps.psotka.sandbox5324.opentlc.com"  # put here your Ollama server URL
MODEL = "ollama/granite4" # name must match what the Ollama server serves
# -------------------------------

def stream_chat():
    print("Interactive LLM client (Ctrl+C to exit)\n")

    history = [
        {"role": "system",
         "content": "You are a helpful assistant. "
                    "Do NOT prefix your replies with labels."}
    ]

    while True:
        try:
            user_input = input("You: ")
        except (EOFError, KeyboardInterrupt):
            print("\nExiting.")
            break

        history.append({"role": "user", "content": user_input})

        print("Assistant: ", end="", flush=True)

        response = completion(
            model=MODEL,
            messages=history,
            api_base=API_BASE,
            stream=True,
        )

        assistant_reply = ""

        for chunk in response:
            delta = chunk["choices"][0]["delta"].get("content", "")
            if delta:
                print(delta, end="", flush=True)
                assistant_reply += delta

        print()
        history.append({"role": "assistant", "content": assistant_reply})

if __name__ == "__main__":
    stream_chat()
