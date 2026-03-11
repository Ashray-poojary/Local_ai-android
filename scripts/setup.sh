#!/bin/bash

# ============================================================
# Local AI on Android (Termux) - Auto Setup Script
# GitHub: https://github.com/Ashray-poojary/local-ai-android
# ============================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
  echo -e "\n${BLUE}==>${NC} ${1}"
}

print_success() {
  echo -e "${GREEN} ${1}${NC}"
}

print_warning() {
  echo -e "${YELLOW}  ${1}${NC}"
}

print_error() {
  echo -e "${RED} ${1}${NC}"
}

# Welcome message
echo -e "${BLUE}"
echo "  ██╗      ██████╗  ██████╗ █████╗ ██╗      █████╗ ██╗"
echo "  ██║     ██╔═══██╗██╔════╝██╔══██╗██║     ██╔══██╗██║"
echo "  ██║     ██║   ██║██║     ███████║██║     ███████║██║"
echo "  ██║     ██║   ██║██║     ██╔══██║██║     ██╔══██║██║"
echo "  ███████╗╚██████╔╝╚██████╗██║  ██║███████╗██║  ██║██║"
echo "  ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝"
echo -e "${NC}"
echo "   Local AI on Android - Auto Setup"
echo "  ======================================"
echo ""

# -------------------------------------------------------
# STEP 1 - Update Termux & Install Dependencies
# -------------------------------------------------------
print_step "Step 1/5 — Updating Termux & installing dependencies..."

pkg update -y && pkg upgrade -y
if [ $? -ne 0 ]; then
  print_error "Failed to update packages. Check your internet connection."
  exit 1
fi

pkg install git cmake clang ninja wget -y
if [ $? -ne 0 ]; then
  print_error "Failed to install dependencies."
  exit 1
fi

print_success "Dependencies installed: git, cmake, clang, ninja, wget"

# -------------------------------------------------------
# STEP 2 - Clone llama.cpp
# -------------------------------------------------------
print_step "Step 2/5 — Downloading llama.cpp..."

if [ -d "llama.cpp" ]; then
  print_warning "llama.cpp folder already exists. Skipping clone."
else
  git clone https://github.com/ggerganov/llama.cpp
  if [ $? -ne 0 ]; then
    print_error "Failed to clone llama.cpp. Check your internet connection."
    exit 1
  fi
fi

cd llama.cpp
print_success "llama.cpp downloaded!"

# -------------------------------------------------------
# STEP 3 - Build llama.cpp
# -------------------------------------------------------
print_step "Step 3/5 — Building llama.cpp (this takes 5-15 minutes)..."
print_warning "Your phone will get warm — that's normal!"
print_warning "Do not close Termux or lock your screen for too long."

cmake -B build -DCMAKE_BUILD_TYPE=Release
if [ $? -ne 0 ]; then
  print_error "CMake configuration failed."
  exit 1
fi

cmake --build build --config Release -j4
if [ $? -ne 0 ]; then
  print_error "Build failed. Try running with -j2:"
  echo "  cmake --build build --config Release -j2"
  exit 1
fi

print_success "llama.cpp built successfully!"

# -------------------------------------------------------
# STEP 4 - Choose & Download Model
# -------------------------------------------------------
print_step "Step 4/5 — Choose a model to download"
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
    MODEL_URL="https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
    MODEL_FILE="tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
    print_step "Downloading TinyLlama 1.1B (~600MB)..."
    ;;
  2)
    MODEL_URL="https://huggingface.co/microsoft/Phi-3-mini-4k-instruct-gguf/resolve/main/Phi-3-mini-4k-instruct-q4.gguf"
    MODEL_FILE="Phi-3-mini-4k-instruct-q4.gguf"
    print_step "Downloading Phi-3 Mini (~2.3GB)..."
    ;;
  3)
    print_warning "Skipping model download."
    MODEL_FILE="YOUR_MODEL.gguf"
    ;;
  *)
    print_warning "Invalid choice. Skipping download."
    MODEL_FILE="YOUR_MODEL.gguf"
    ;;
esac

if [ "$model_choice" = "1" ] || [ "$model_choice" = "2" ]; then
  echo ""
  print_warning "Download is resumable! If it stops, run this script again."
  wget -c "$MODEL_URL"
  if [ $? -ne 0 ]; then
    print_error "Download failed or interrupted. Run the script again to resume."
    exit 1
  fi
  print_success "Model downloaded: $MODEL_FILE"
fi

# -------------------------------------------------------
# STEP 5 - Done! Show usage instructions
# -------------------------------------------------------
print_step "Step 5/5 — Setup complete! "

echo ""
echo -e "${GREEN}======================================"
echo "   Your Local AI is Ready!"
echo "======================================${NC}"
echo ""
echo "   Chat in terminal:"
echo ""
echo "  ./build/bin/llama-cli \\"
echo "    -m $MODEL_FILE \\"
echo "    --conversation \\"
echo "    -sys \"You are a helpful assistant.\""
echo ""
echo "   Start Web UI:"
echo ""
echo "  ./build/bin/llama-server \\"
echo "    -m $MODEL_FILE \\"
echo "    --host 0.0.0.0 \\"
echo "    --port 8080"
echo ""
echo "  Then open: http://localhost:8080"
echo ""
echo "   Full guide: https://github.com/YOUR_USERNAME/local-ai-android"
echo ""
print_success "Enjoy your private, offline AI! 🤖"

# run script 
read -n 1 -p "Creating shortcut file for cli or web (y/n) " ch
echo # Adds a newline after the input

if [[ "$ch" == "y" || "$ch" == "Y" ]]; then
    echo "Creating an executable file...."
    cat << 'EOF' > run.sh
#!/bin/bash
echo "script executing....."
echo -e "1.cli run\n2.web run\n3.cli with file reading.\n4.web with file reading/n5.exit"
read -n 1 -p "Enter your choice: " cho
echo
if [ "$cho" == "1" ]; then
./build/bin/llama-cli -m tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf --conversation -sys "You are helpful assistance." -n 256
elif [ "$cho" == "2" ]; then
./build/bin/llama-server \
  -m tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf \
  --host 0.0.0.0 \
  --port 8080
elif [ "$cho" == "3" ]; then
./build/bin/llama-cli -m tinyllama*.gguf \
  --conversation \
  -f notes.txt \
  -sys "analyse this file"
else
exit 0
EOF
    chmod +x run.sh # Moves this outside to execute on the file
    echo "script created"
else
    echo "Skipping file creation."
    echo "Bye......"
fi




