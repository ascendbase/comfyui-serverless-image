# Minimal ComfyUI Dockerfile for Serverless GPU with Custom Nodes
FROM python:3.11-slim

# System dependencies - Fixed for Debian compatibility
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# 1. Clone ComfyUI
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git

# 2. Install ComfyUI requirements
WORKDIR /workspace/ComfyUI
RUN pip install -r requirements.txt

# 3. Install PyTorch with CUDA support first
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# 4. Install computer vision and ML dependencies from regular PyPI
RUN pip install --no-cache-dir \
    numpy \
    opencv-python-headless \
    segment-anything \
    scikit-image \
    ultralytics \
    insightface \
    onnxruntime \
    mediapipe \
    albumentations \
    kornia \
    timm \
    addict \
    yapf \
    scipy \
    matplotlib \
    pillow

# 5. Install ComfyUI Manager (required infrastructure)
WORKDIR /workspace/ComfyUI/custom_nodes
RUN git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Manager.git

# 6. Install ComfyUI Impact Pack (main custom node)
RUN git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Impact-Pack.git

# 7. Install ComfyUI Impact Subpack (required dependency)
RUN git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git

# 8. Create model directories
RUN mkdir -p /workspace/ComfyUI/models/checkpoints \
    /workspace/ComfyUI/models/loras \
    /workspace/ComfyUI/models/ultralytics/bbox \
    /workspace/ComfyUI/models/sams \
    /workspace/ComfyUI/input \
    /workspace/ComfyUI/output

# 9. Download required models
WORKDIR /workspace/ComfyUI/models

RUN wget --timeout=60 --tries=3 -O checkpoints/real-dream-15.safetensors "https://huggingface.co/sinatra-rd/sd-1.5-real-dream/resolve/main/real-dream-15.safetensors"
RUN wget --timeout=60 --tries=3 -O loras/chad_sd1.5.safetensors "https://civitai.com/api/download/models/2416869?type=Model&format=SafeTensor"
RUN wget --timeout=30 --tries=3 -O ultralytics/bbox/face_yolov8m.pt "https://github.com/ultralytics/assets/releases/download/v0.0.0/yolov8m.pt"
RUN wget --timeout=30 --tries=3 -O sams/sam_vit_b_01ec64.pth "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"

# 10. Go back to ComfyUI root
WORKDIR /workspace/ComfyUI

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8188/ || exit 1

EXPOSE 8188

# Start ComfyUI
CMD ["python", "main.py", "--listen", "0.0.0.0", "--port", "8188", "--dont-print-server"]
