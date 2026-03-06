# Fine-Tuning Guide — Build Your Own Chatbot

Fine-tuning means taking an existing model and training it on **your own data** to make it an expert in your specific domain.

---

## Use Cases

- Customer service chatbot for your business
- FAQ bot that answers questions about your product
- Assistant trained on your company documents
- Specialized bot for any service

---

## The 3 Levels of Customization

### Level 1 — System Prompt (Easiest, No Training)
Just give the AI a personality and rules:
```bash
./build/bin/llama-cli -m model.gguf \
  --conversation \
  -sys "You are a helpful customer service agent for AcmeCorp. 
  Only answer questions about our products. Be friendly and professional."
```
> Good for: simple personality changes, basic rules

### Level 2 — Fine-Tuning with LoRA ✅ Recommended
Train the model on your Q&A data. Uses **LoRA** (Low Rank Adaptation) — adds small trainable layers on top without changing the whole model.
> Good for: custom knowledge, specific language style, domain expertise

### Level 3 — Training from Scratch ❌ Not Realistic
Costs millions of dollars and requires thousands of GPUs.
> Only for: Large tech companies

---

## Recommended Model for Fine-Tuning

For a **production service chatbot** on a custom server:

**Llama 3 8B Instruct** — Best choice because:
- Excellent English understanding
- Great at following instructions
- Large community with lots of fine-tuning guides
- Free commercial license
- Handles different question phrasings perfectly

---

## Step 1 — Prepare Your Dataset

Create a JSON file with your Q&A pairs:

```json
[
  {
    "question": "What are your working hours?",
    "answer": "We are open Monday to Friday, 9AM to 6PM."
  },
  {
    "question": "When are you open?",
    "answer": "We are open Monday to Friday, 9AM to 6PM."
  },
  {
    "question": "How do I reset my password?",
    "answer": "Click 'Forgot Password' on the login page and follow the email instructions."
  },
  {
    "question": "What is your refund policy?",
    "answer": "We offer a full refund within 30 days of purchase."
  }
]
```

> See [datasets/example-dataset.json](../datasets/example-dataset.json) for a full template!

### How many Q&A pairs do you need?

| Amount | Result |
|--------|--------|
| 50-100 pairs | Basic chatbot |
| 100-500 pairs | Good chatbot |
| 500-1000 pairs | Great chatbot |
| 1000+ pairs | Professional chatbot |

### Tips for writing good training data:
- Include **multiple versions** of the same question
- Cover all the questions users might ask
- Keep answers clear and consistent
- Add edge cases and polite/rude variations

---

## Step 2 — Fine-Tune on Google Colab (Free!)

Fine-tuning requires a GPU. Use **Google Colab** for free:

1. Go to https://colab.research.google.com
2. Create new notebook
3. Set runtime to **GPU** (Runtime → Change runtime type → T4 GPU)
4. Run these cells:

```python
# Install dependencies
!pip install transformers peft trl datasets bitsandbytes

# Load model
from transformers import AutoModelForCausalLM, AutoTokenizer
model_name = "meta-llama/Meta-Llama-3-8B-Instruct"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name, load_in_4bit=True)
```

```python
# Load your dataset
import json
from datasets import Dataset

with open('your-dataset.json', 'r') as f:
    data = json.load(f)

# Format for training
def format_data(item):
    return {
        "text": f"<|user|>{item['question']}<|assistant|>{item['answer']}"
    }

dataset = Dataset.from_list([format_data(item) for item in data])
```

```python
# Configure LoRA
from peft import LoraConfig, get_peft_model

lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)

model = get_peft_model(model, lora_config)
```

```python
# Train!
from trl import SFTTrainer
from transformers import TrainingArguments

trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    dataset_text_field="text",
    args=TrainingArguments(
        output_dir="./results",
        num_train_epochs=3,
        per_device_train_batch_size=4,
        learning_rate=2e-4,
        save_steps=100,
    )
)

trainer.train()
trainer.save_model("./my-chatbot")
```

---

## Step 3 — Convert to GGUF

After training, convert to GGUF so llama.cpp can run it:

```bash
# Back in Termux / your server
cd llama.cpp

# Install conversion dependencies
pip install -r requirements.txt

# Convert
python convert_hf_to_gguf.py ./my-chatbot \
  --outfile my-chatbot.gguf \
  --outtype q4_k_m
```

---

## Step 4 — Run Your Custom Chatbot

```bash
./build/bin/llama-server \
  -m my-chatbot.gguf \
  --host 0.0.0.0 \
  --port 8080 \
  -sys "You are a helpful customer service agent."
```

---

## How It Handles Different Question Forms

After fine-tuning on:
```
Q: "What are your working hours?"
A: "We are open Monday to Friday 9AM to 6PM"
```

It will correctly answer ALL of these:
```
✅ "When do you open?"
✅ "Are you open on weekends?"
✅ "What time do you close?"
✅ "Can I visit on Saturday?"
✅ "Is the office open now?"
✅ "Working hours please"
✅ "Hours of operation?"
```

This works because the model understands **intent**, not just keywords!

---

## Adding Multilingual Support

Just add translations to your dataset:

```json
[
  {
    "question": "What are your hours?",
    "answer": "We open Monday to Friday 9AM-6PM"
  },
  {
    "question": "ما هي ساعات العمل؟",
    "answer": "نفتح من الاثنين إلى الجمعة 9 صباحاً - 6 مساءً"
  }
]
```

Same model — answers in multiple languages!
