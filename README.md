# ComfyUI Serverless Image

A minimal Docker image for running ComfyUI with pre-installed custom nodes on cloud serverless GPU platforms.

## 🚀 Problem Solved

This image solves the common issue where ComfyUI custom nodes (like ComfyUI-Impact-Pack) require interactive installation that doesn't work in serverless environments.

## ✅ What's Included

### Pre-installed Custom Nodes
- **ComfyUI Manager** - Infrastructure for custom nodes
- **ComfyUI-Impact-Pack** - Advanced face detection and masking
- **ComfyUI-Impact-Subpack** - Required dependency

### Pre-installed Dependencies
- All required Python packages
- Face detection models (YOLO)
- Segmentation models (SAM)
- GPU acceleration (CUDA)

### Pre-downloaded Models
- RealVisXL base model
- Chad SD1.5 LoRA
- Face detection model
- Segmentation models

## 🏗️ Build & Deploy

### Local Testing
```bash
# Build locally
docker build -t comfyui-serverless .

# Run locally
docker run -p 8188:8188 comfyui-serverless
```

### GitHub Actions (Recommended)
1. Push this repo to GitHub
2. Enable GitHub Actions
3. Auto-builds happen on `main` branch pushes
4. Pull the built image from GitHub Container Registry

### Serverless Deployments

#### RunPod
```bash
docker pull ghcr.io/yourusername/comfyui-serverless:latest
# Use in RunPod template
```

#### Railway
Use the Dockerfile in this repo directly.

## 🎯 Usage

The container exposes port 8188 and starts ComfyUI automatically. Point your workflow API calls to the container's IP/port.

All custom nodes are pre-installed and ready - no ComfyUI Manager interaction needed!

## 🔧 Customization

Edit `Dockerfile` to:
- Add/remove custom nodes
- Change base models
- Add additional dependencies
- Modify model downloads

## 📝 Requirements

- Works on any cloud GPU platform
- Pre-built images avoid build timeouts
- Optimized for serverless cold starts
