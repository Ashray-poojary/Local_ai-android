# What is an AI Model?

---

## Simple Explanation

A model is just a **very large file full of numbers** — but those numbers encode the ability to understand and generate language.

---

## How It's Created — Training

A model starts as random numbers. Then it's fed **massive amounts of text** (books, websites, code, articles) and slowly adjusts its numbers to get better at predicting language.

This process is called **training** and costs **millions of dollars** in computing power, running for weeks on thousands of GPUs.

---

## What Those Numbers Actually Are

Inside the model are billions of **parameters** — they represent connections like a giant web of associations:

```
"Paris" → likely followed by "is the capital"
"the sky is" → likely followed by "blue"
"2 + 2 =" → likely followed by "4"
```

The more parameters, the smarter (and bigger) the model.

---

## Model Sizes Explained

| Model | Parameters | Size on disk | Quality |
|-------|-----------|--------------|---------|
| TinyLlama | 1.1 Billion | ~600MB | Basic |
| Phi-3 Mini | 3.8 Billion | ~2GB | Good |
| Mistral | 7 Billion | ~4GB | Great |
| Llama 3 | 8 Billion | ~5GB | Excellent |
| Llama 3 70B | 70 Billion | ~40GB | Very powerful |

---

## What is GGUF?

When we download a model, it comes in **GGUF format** — a compressed version that:

- Takes up **less space**
- Runs on **less RAM**
- Works on **CPU** instead of needing a GPU

Think of it like a zip file specifically designed for AI models.

---

## What is Quantization?

Quantization is how much the model is compressed:

```
Original model  →  Full quality, huge size
Q8 quantized    →  90% quality, half size
Q4_K_M          →  80% quality, quarter size  ← Best for phones
Q2 quantized    →  60% quality, tiny size
```

Like image compression — smaller file, slightly less quality but barely noticeable for most tasks.

---

## How It Works When You Chat

```
You type message
      ↓
llama.cpp converts text → numbers
      ↓
Model processes through billions of parameters
      ↓
Predicts best next word, then next, then next...
      ↓
llama.cpp converts numbers → text
      ↓
You see the response
```

It's not thinking like a human — it's doing **incredibly fast math** that produces human-like results.
