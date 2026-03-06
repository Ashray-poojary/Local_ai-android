# Troubleshooting Guide

---

## Common Issues & Fixes

---

### ❌ `error: invalid argument: --interactive`

**Problem:** Newer versions of llama.cpp removed `--interactive`

**Fix:** Use `--conversation` instead:
```bash
# Wrong (old)
./build/bin/llama-cli -m model.gguf --interactive

# Correct (new)
./build/bin/llama-cli -m model.gguf --conversation
```

---

### ❌ Build fails with `error:` during compilation

**Problem:** Real compilation error (not a warning)

**Fix 1:** Make sure all dependencies are installed:
```bash
pkg install git cmake clang ninja -y
```

**Fix 2:** Clean and rebuild:
```bash
rm -rf build
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release -j4
```

**Fix 3:** Try fewer cores:
```bash
cmake --build build --config Release -j2
```

---

### ⚠️ Lots of warnings during compilation

**This is NORMAL!** Warnings are not errors. Keep watching the percentage:
```
[ 45%] Building CXX...   ← still going, good!
[ 80%] Building CXX...   ← almost done!
[100%] Built target      ← done!
```

Only stop if you see `error:` or `FAILED:`

---

### ❌ Model download stops/interrupted

**Fix:** The `-c` flag resumes downloads — just run the same command again:
```bash
wget -c https://huggingface.co/...model.gguf
```

---

### ❌ `Killed` when running the model

**Problem:** Android killed the process due to low RAM

**Fix 1:** Close all other apps and try again

**Fix 2:** Use a smaller model:
```bash
# Switch to TinyLlama (only 600MB RAM)
wget -c https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf
```

**Fix 3:** Reduce context size:
```bash
./build/bin/llama-cli -m model.gguf --conversation -c 512
```

---

### ❌ Very slow responses

**Problem:** Phone CPU is slow or overloaded

**Fix 1:** Make sure no heavy apps are running in background

**Fix 2:** Reduce threads:
```bash
./build/bin/llama-cli -m model.gguf --conversation -t 2
```

**Fix 3:** Use a smaller model — TinyLlama is much faster than Phi-3

---

### ❌ `pkg: command not found`

**Problem:** Termux from Play Store is too outdated

**Fix:** Uninstall and reinstall Termux from F-Droid:
👉 https://f-droid.org/packages/com.termux/

---

### ❌ `No space left on device`

**Problem:** Phone storage is full

**Fix:** Free up space and try again:
```bash
# Check available space
df -h

# Remove downloaded model and try smaller one
rm *.gguf
```

---

### ❌ Web server not accessible from other devices

**Problem:** Firewall or wrong IP

**Fix 1:** Find correct IP:
```bash
ip addr show | grep "inet "
```

**Fix 2:** Make sure you used `--host 0.0.0.0`:
```bash
./build/bin/llama-server -m model.gguf --host 0.0.0.0 --port 8080
```

**Fix 3:** Both devices must be on the **same WiFi network**

---

### ❌ AI gives wrong or confused answers

**Problem:** Model is too small for the question

**Solution:** This is a model quality limitation. Options:
- Use a larger model (Phi-3 Mini instead of TinyLlama)
- Ask simpler, more direct questions
- Fine-tune on your specific domain data

---

## Still stuck?

Open an issue on GitHub with:
1. Your phone model and RAM
2. The exact error message
3. Which step failed
