#2 options for user
echo "You want to use prebuild or bulid llama-cpp ?"
echo "1.Prebuild is fast,small size and may slow in responce."
echo "2.Building takes lot of time and resoucere and may get fast response then prebuild"
echo -n "Enter your choice 1 or 2 : "
read ch
case $ch in
1)
# ==============================================================================
# STEP 1 — Install llama.cpp (prebuilt) + base dependencies
# ==============================================================================
#
# We deliberately use the Termux repo's prebuilt "llama-cpp" package instead
# of building from source. This is faster, avoids build-toolchain issues on
# low-RAM devices, and gets updates via a normal `pkg upgrade`. The tradeoff
# (noted below) is that the prebuilt package may lag behind the newest GGUF
# quant formats — we check for that explicitly so it's a known fact, not a
# surprise later when a model file fails to load.
# ==============================================================================

echo "STEP 1: Installing llama.cpp from Termux repo (prebuilt)"
if ! command -v llama-server >/dev/null 2>&1; then
    pkg install -y llama-cpp
else
    echo "llama-cpp already installed, skipping."
fi

echo "STEP 1: Verifying llama-server binary is present"
if command -v llama-server >/dev/null 2>&1; then
    echo "OK — llama-server found at: $(command -v llama-server)"
else
    echo "ERROR: llama-server was not found after installation."
    echo "The Termux package may only provide llama-cli on your Termux version."
    echo "Check: pkg show llama-cpp"
    exit 1
fi
      ;;
    2)
      echo "lets go for building"
      ;;
esac 

# -------------------------------------------------------
# STEP 4 - Choose & Download Model
# -------------------------------------------------------
echo "Step 4/5 — Choose a model to download"
echo ""
echo "  How much RAM does your device have?"
echo ""
echo "  1) TinyLlama 1.1B Q4  (~600MB)  — 4GB RAM devices  [Fast, basic quality]"
echo "  2) Phi-3 Mini Q4      (~2.3GB)  — 6GB RAM devices  [Recommended ]"
echo "  3) Skip download (I'll download manually)"
echo ""
read -p "  Enter choice (1/2/3): " model_choice

case $model_choice in
  1)
    MODEL_URL="https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/res>
    MODEL_FILE="tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
    echo "Downloading TinyLlama 1.1B (~600MB)..."
    ;;
  2)
    MODEL_URL="https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/reso>
    MODEL_FILE="Phi-3-mini-4k-instruct-q4.gguf"
    echo "Downloading Phi-3 Mini (~2.3GB)..."
    ;;
  3)
    echo "Skipping model download."
    MODEL_FILE="YOUR_MODEL.gguf"
    ;;
  *)
    echo "Invalid choice. Skipping download."
    MODEL_FILE="YOUR_MODEL.gguf"
    ;;
esac

if [ "$model_choice" = "1" ] || [ "$model_choice" = "2" ]; then
  echo ""
  echo "Download is resumable! If it stops, run this script again."
  wget -c "$MODEL_URL"
  if [ $? -ne 0 ]; then
    echo "Download failed or interrupted. Run the script again to resume."
    exit 1
  fi
  echo "Model downloaded: $MODEL_FILE"
fi

echo "lets start a server for agent access....."
llama-server -m $MODEL_FILE
