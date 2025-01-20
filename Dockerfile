# Use NVIDIA CUDA base image
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/miniconda3/bin:$PATH"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git wget ffmpeg libgl1-mesa-glx python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /root/miniconda3 && \
    rm /tmp/miniconda.sh

# Clone Automatic1111's WebUI repository
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /workspace/stable-diffusion-webui

# Install Python dependencies for Automatic1111
RUN /root/miniconda3/bin/conda create -n auto1111-env python=3.10 -y && \
    /root/miniconda3/bin/conda run -n auto1111-env pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 && \
    /root/miniconda3/bin/conda run -n auto1111-env pip install -r /workspace/stable-diffusion-webui/requirements.txt

# Expose ports for API access
EXPOSE 7860

# Set work directory
WORKDIR /workspace/stable-diffusion-webui

# Command to run the web UI
CMD ["/root/miniconda3/bin/conda", "run", "-n", "auto1111-env", "python", "launch.py", "--api", "--listen", "--port", "7860"]
