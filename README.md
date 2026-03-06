# Run Local AI on Android (Termux)

Run a fully offline AI on your Android phone — no internet, no cloud, no cost. 100% private.

> Built and tested on Android with 6GB RAM

---

## Table of Contents

- [What is this?](#what-is-this)
- [Requirements](#requirements)
- [Quick Start (Auto Setup)](#quick-start-auto-setup)
- [Manual Step by Step Guide](#manual-step-by-step-guide)
- [Choosing a Model](#choosing-a-model)
- [Running the AI](#running-the-ai)
- [Web UI](#web-ui)
- [REST API](#rest-api)
- [Fine-Tuning Guide](#fine-tuning-guide)
- [Features You Can Build](#features-you-can-build)
- [Troubleshooting](#troubleshooting)

---

## What is this?

This guide helps you run a **Large Language Model (LLM)** locally on your Android phone using:

| Tool | Purpose |
|------|---------|
| **Termux** | Linux terminal on Android |
| **llama.cpp** | Lightweight AI engine that runs models on CPU |
| **GGUF Models** | Compressed AI models that fit on phone |

Everything runs **100% offline** after setup. No data is sent anywhere.

---

## Requirements

| Item | Minimum | Recommended |
|------|---------|-------------|
| Android version | 7.0+ | 10+ |
| RAM | 4GB | 6GB+ |
| Storage | 4GB free | 8GB+ free |
| Termux | F-Droid version | F-Droid version |

> Install Termux from **F-Droid only** — the Play Store version is outdated.
> https://f-droid.org/packages/com.termux/

---

## Quick Start (Auto Setup)

Run this single command in Termux and it will do everything automatically:

```bash
curl -O https://raw.githubusercontent.com/YOUR_USERNAME/local-ai-android/main/scripts/setup.sh && chmod +x setup.sh && ./setup.sh
```

> The script will ask you which model to download and set everything up!

---

## Manual Step by Step Guide

### Step 1 — Update Termux & Install Dependencies

```bash
pkg update && pkg upgrade -y
pkg install git cmake clang ninja wget -y
```

**What each tool does:**
- `git` → Downloads code from the internet
- `cmake` → Plans how to compile the code for your device
- `clang` → The C++ compiler that builds the program
- `ninja` → Makes compilation faster
- `wget` → Downloads files (with resume support)

---

### Step 2 — Clone llama.cpp

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
```

> This downloads the AI engine source code (~200-500MB)

---

### Step 3 — Build llama.cpp

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release -j4
```

Takes **5–15 minutes**. Phone will get warm — that's normal!

> You will see many **warnings** during compilation — these are normal and can be ignored. Only worry if you see `error:` or `FAILED:`

**What these commands do:**
- First command → Plans the build for your CPU (like an architect drawing blueprints)
- Second command → Actually compiles the code using 4 CPU cores simultaneously
- `-j4` → Uses 4 cores for faster compilation

---

### Step 4 — Download a Model

Choose a model based on your RAM:

```bash
# TinyLlama 1.1B (~600MB) — For 4GB RAM devices
wget -c https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf

# Phi-3 Mini (~2.3GB) — For 6GB+ RAM devices (recommended)
wget -c https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf
```

> `-c` flag enables **resume** — if download stops, run same command again to continue!

---

### Step 5 — Run the AI

```bash
./build/bin/llama-cli \
  -m tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf \
  --conversation \
  -sys "You are a helpful assistant." \
  -n 256
```

Wait for the `>` prompt then start chatting!

---

## Choosing a Model

See the full model guide: [docs/03-model-selection.md](docs/03-model-selection.md)

| Model | Size | RAM Needed | Best For |
|-------|------|-----------|---------|
| TinyLlama 1.1B Q4 | ~600MB | 2GB | Testing, low RAM devices |
| Phi-3 Mini Q4 | ~2.3GB | 3GB | Best for 6GB phones |
| Mistral 7B Q4 | ~4.5GB | 6GB | High quality, needs more RAM |
| Llama 3 8B Q4 | ~5GB | 7GB | Best quality for servers |

---

## Running the AI

### Chat Mode (Terminal)
```bash
./build/bin/llama-cli -m YOUR_MODEL.gguf --conversation -sys "You are a helpful assistant."
```

### With a File
```bash
./build/bin/llama-cli -m YOUR_MODEL.gguf --conversation -f yourfile.txt
```

### Single Question
```bash
./build/bin/llama-cli -m YOUR_MODEL.gguf -p "What is photosynthesis?" -n 256
```

---

## Web UI

Start the built-in web server:

```bash
./build/bin/llama-server \
  -m YOUR_MODEL.gguf \
  --host 0.0.0.0 \
  --port 8080
```

Then open browser: `http://localhost:8080`

> To access from another device on same WiFi, find your phone IP with `ip addr show` and visit `http://YOUR_IP:8080`

---

## REST API

llama-server exposes an **OpenAI-compatible API**:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Hello!"}
    ]
  }'
```

> Any app built for the ChatGPT API works with your local AI!

---

## Fine-Tuning Guide

See the full fine-tuning guide: [docs/04-fine-tuning.md](docs/04-fine-tuning.md)

---

## Features You Can Build

See the full features guide: [docs/05-features.md](docs/05-features.md)

---

## Troubleshooting

See the full troubleshooting guide: [docs/06-troubleshooting.md](docs/06-troubleshooting.md)

---

## License

MIT License — free to use, modify, and share!

---

## Credits

- [llama.cpp](https://github.com/ggerganov/llama.cpp) by Georgi Gerganov
- [TinyLlama](https://huggingface.co/TinyLlama) by StatNLP Research
- [Phi-3](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf) by Microsoft
- [TheBloke](https://huggingface.co/TheBloke) for GGUF model conversions
