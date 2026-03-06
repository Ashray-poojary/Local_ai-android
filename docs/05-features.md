# Features You Can Build With Your Local AI

---

## 1. Web UI ✅ Built-in

```bash
./build/bin/llama-server -m model.gguf --host 0.0.0.0 --port 8080
```
Open browser: `http://localhost:8080`

---

## 2. REST API

llama-server exposes an OpenAI-compatible API:

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

Any app built for ChatGPT API works with your local AI!

---

## 3. Telegram Bot

```python
import telebot
import requests

bot = telebot.TeleBot("YOUR_TELEGRAM_TOKEN")

@bot.message_handler(func=lambda m: True)
def handle(message):
    response = requests.post("http://localhost:8080/v1/chat/completions",
        json={"messages": [{"role": "user", "content": message.text}]}
    )
    reply = response.json()["choices"][0]["message"]["content"]
    bot.reply_to(message, reply)

bot.polling()
```

---

## 4. WhatsApp Bot

Use Twilio WhatsApp API + your local AI server.

```python
from flask import Flask, request
import requests

app = Flask(__name__)

@app.route("/whatsapp", methods=["POST"])
def whatsapp():
    user_message = request.form.get("Body")
    response = requests.post("http://localhost:8080/v1/chat/completions",
        json={"messages": [{"role": "user", "content": user_message}]}
    )
    reply = response.json()["choices"][0]["message"]["content"]
    return f"<Response><Message>{reply}</Message></Response>"

app.run(port=5000)
```

---

## 5. Voice Assistant

```bash
# Install dependencies
pkg install python -y
pip install SpeechRecognition pyttsx3 requests

# voice_assistant.py
import speech_recognition as sr
import pyttsx3
import requests

recognizer = sr.Recognizer()
engine = pyttsx3.init()

while True:
    with sr.Microphone() as source:
        print("Listening...")
        audio = recognizer.listen(source)
    
    text = recognizer.recognize_google(audio)
    print(f"You said: {text}")
    
    response = requests.post("http://localhost:8080/v1/chat/completions",
        json={"messages": [{"role": "user", "content": text}]}
    )
    reply = response.json()["choices"][0]["message"]["content"]
    
    engine.say(reply)
    engine.runAndWait()
```

---

## 6. Document Analyzer

```bash
# Analyze any text file
./build/bin/llama-cli -m model.gguf \
  --conversation \
  -f document.txt \
  -sys "You are a document analyzer. Summarize and answer questions about the document."
```

```python
# Python version for PDF
import PyPDF2
import requests

def analyze_pdf(pdf_path, question):
    with open(pdf_path, 'rb') as f:
        reader = PyPDF2.PdfReader(f)
        text = " ".join(page.extract_text() for page in reader.pages)
    
    response = requests.post("http://localhost:8080/v1/chat/completions",
        json={"messages": [
            {"role": "system", "content": f"Document content: {text[:3000]}"},
            {"role": "user", "content": question}
        ]}
    )
    return response.json()["choices"][0]["message"]["content"]

print(analyze_pdf("contract.pdf", "What are the key terms?"))
```

---

## 7. Website Chatbot Widget

Add this to any website:

```html
<!-- Chat Widget -->
<div id="chat-widget" style="position:fixed; bottom:20px; right:20px; width:350px;">
  <div id="chat-box" style="height:400px; overflow-y:scroll; border:1px solid #ccc; padding:10px; background:white;"></div>
  <input id="chat-input" type="text" placeholder="Ask me anything..." style="width:80%">
  <button onclick="sendMessage()">Send</button>
</div>

<script>
async function sendMessage() {
  const input = document.getElementById('chat-input');
  const message = input.value;
  input.value = '';
  
  addMessage('You', message);
  
  const response = await fetch('http://YOUR_SERVER:8080/v1/chat/completions', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({
      messages: [{role: 'user', content: message}]
    })
  });
  
  const data = await response.json();
  const reply = data.choices[0].message.content;
  addMessage('AI', reply);
}

function addMessage(sender, text) {
  const box = document.getElementById('chat-box');
  box.innerHTML += `<p><b>${sender}:</b> ${text}</p>`;
  box.scrollTop = box.scrollHeight;
}
</script>
```

---

## 8. Code Assistant (VS Code)

Install the **Continue** VS Code extension and point it to your local server:

```json
// Continue config (~/.continue/config.json)
{
  "models": [{
    "title": "My Local AI",
    "provider": "openai",
    "model": "local-model",
    "apiBase": "http://localhost:8080/v1",
    "apiKey": "none"
  }]
}
```

Free GitHub Copilot alternative — 100% private!

---

## 9. Email Autoresponder

```python
import imaplib
import smtplib
import requests
import email

def check_and_reply():
    # Connect to email
    mail = imaplib.IMAP4_SSL("imap.gmail.com")
    mail.login("you@gmail.com", "password")
    mail.select("inbox")
    
    # Get unread emails
    _, messages = mail.search(None, "UNSEEN")
    
    for msg_id in messages[0].split():
        _, data = mail.fetch(msg_id, "(RFC822)")
        msg = email.message_from_bytes(data[0][1])
        subject = msg["subject"]
        body = msg.get_payload(decode=True).decode()
        
        # Generate AI reply
        response = requests.post("http://localhost:8080/v1/chat/completions",
            json={"messages": [
                {"role": "system", "content": "You are a professional email assistant."},
                {"role": "user", "content": f"Reply to this email: {body}"}
            ]}
        )
        reply = response.json()["choices"][0]["message"]["content"]
        print(f"Draft reply for '{subject}':\n{reply}\n")
```

---

## 10. RAG System (Permanent Memory)

RAG (Retrieval Augmented Generation) gives your AI permanent knowledge from your documents:

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# Load your documents
documents = SimpleDirectoryReader("./my-documents").load_data()

# Build index
index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()

# Query with context from your docs
response = query_engine.query("What is our refund policy?")
print(response)
```

---

## Features Comparison

| Feature | Difficulty | Use Case |
|---------|-----------|---------|
| Web UI | ⭐ Easy | Personal use |
| REST API | ⭐ Easy | Connect any app |
| Telegram Bot | ⭐⭐ Medium | Public chatbot |
| Document Analyzer | ⭐⭐ Medium | Business docs |
| Website Widget | ⭐⭐ Medium | Customer service |
| Voice Assistant | ⭐⭐⭐ Hard | Hands-free use |
| Code Assistant | ⭐ Easy | Development |
| RAG System | ⭐⭐⭐ Hard | Smart knowledge base |
| Email Autoresponder | ⭐⭐⭐ Hard | Business automation |
