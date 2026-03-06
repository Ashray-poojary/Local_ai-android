# What is LLaMA & llama.cpp?

---

## LLaMA

**LLaMA** stands for **Large Language Model Meta AI** — a family of AI models created by **Meta (Facebook)**.

Before LLaMA, powerful AI models like ChatGPT were only accessible through the cloud. Meta changed the game by **releasing their model weights publicly**, meaning anyone could download and run the AI themselves.

---

## What is llama.cpp?

LLaMA's original code required expensive GPU servers to run. A developer named **Georgi Gerganov** rewrote it in **C++** (hence the `.cpp`) to make it:

- Run on **normal CPUs** — no expensive GPU needed
- Work on **low-end hardware** — including phones!
- Be **lightweight and fast**

So `llama.cpp` is not the AI model itself — it's the **engine that runs AI models**.

---

## The Analogy

| Thing | Analogy |
|-------|---------|
| LLaMA model | A movie file (.mp4) |
| llama.cpp | The video player (VLC) |
| Your phone | The TV screen |

---

## What models can llama.cpp run?

It's not limited to LLaMA! It can run many models as long as they are in **GGUF format**:

- **Phi-3** (Microsoft)
- **Gemma** (Google)
- **Mistral** (Mistral AI)
- **LLaMA 2 & 3** (Meta)
- **TinyLlama** (StatNLP)
- **DeepSeek** (DeepSeek AI)
- And many more!
