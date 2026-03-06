# Choosing the Right Model

---

## By Device RAM

| Your RAM | Recommended Model | Size | Why |
|---------|------------------|------|-----|
| 4GB or less | TinyLlama 1.1B Q4 | ~600MB | Only safe option |
| 6GB | Phi-3 Mini Q4 | ~2.3GB | Best quality/size ratio |
| 8GB | Mistral 7B Q4 | ~4.5GB | Near ChatGPT quality |
| 12GB+ | Llama 3 8B Q4 | ~5GB | Best quality |

> ⚠️ Android OS uses 2-3GB RAM by itself, so always subtract that from your total!

---

## By Use Case

| You want to... | Best Model | Download Link |
|---------------|-----------|---------------|
| Just test & learn | TinyLlama 1.1B | [Download](https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf) |
| General assistant | Phi-3 Mini Q4 | [Download](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf) |
| Write & debug code | DeepSeek Coder 1.3B | [Browse](https://huggingface.co/models?search=deepseek-coder-gguf) |
| Math & reasoning | DeepSeek R1 1.5B | [Browse](https://huggingface.co/models?search=deepseek-r1-gguf) |
| Service chatbot | Llama 3 8B Instruct | [Browse](https://huggingface.co/models?search=llama-3-8b-instruct-gguf) |
| Best quality | Mistral 7B Instruct | [Browse](https://huggingface.co/models?search=mistral-7b-instruct-gguf) |

---

## Specialized Models

### Code Models
| Model | Size | Best for |
|-------|------|---------|
| CodeGemma 2B | ~1.5GB | Writing code |
| DeepSeek Coder 1.3B | ~800MB | Code completion |
| StarCoder2 3B | ~1.8GB | Multiple languages |

### Math & Reasoning
| Model | Size | Best for |
|-------|------|---------|
| DeepSeek R1 1.5B | ~1GB | Math & logic |
| Qwen2 Math 1.5B | ~900MB | Math problems |

### General Chat
| Model | Size | Best for |
|-------|------|---------|
| TinyLlama 1.1B Q4 | ~600MB | Basic conversation |
| Phi-3 Mini Q4 | ~2.3GB | Smart general chat |
| Gemma 2B Q4 | ~1.5GB | Balanced |
| Mistral 7B Q4 | ~4.5GB | Best quality |
| Llama 3 8B Q4 | ~5GB | Production chatbots |

---

## Understanding Model Name Parts

```
tinyllama - 1.1b - chat - v1.0 . Q4_K_M . gguf
    │         │      │      │       │        │
    │         │      │      │       │        └── File format
    │         │      │      │       └────────── Quantization level
    │         │      │      └────────────────── Version
    │         │      └───────────────────────── Fine-tuned for chat
    │         └──────────────────────────────── 1.1 Billion parameters
    └────────────────────────────────────────── Model family name
```

---

## Where to Find More Models

Browse all GGUF models on Hugging Face:
👉 https://huggingface.co/models?library=gguf&sort=trending
