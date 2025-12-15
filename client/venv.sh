#!/bin/bash

# Than script sets up the lietllm client virtual environment.
# It installs Python 3.14 via Homebrew if not already installed, creates a virtual environment.
# It's designed to be run on macOS, for other systems, you may need to adjust the Python installation command.

set -e  # Exit on error
echo "🔧 Installing Python 3.14 via Homebrew (if not already installed)..."
brew install python@3.14 || true

echo "🧹 Cleaning up existing virtual environment..."
rm -rf ./venv

echo "🌀 Creating a new Python 3.14 virtual environment..."
python3.14 -m venv ./venv
source ./venv/bin/activate
echo "📦 Upgrading pip..."
pip install --upgrade pip

pip install litellm

echo "✅ Done!"
echo "🐍 Python version: $(python -V)"
