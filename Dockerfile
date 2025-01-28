# Use the official NVIDIA CUDA image with CUDA 11.8
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=/root/miniconda3/bin:$PATH

# Install system dependencies
RUN apt-get update && \
    apt-get install -y git wget ffmpeg libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /root/miniconda3 && \
    rm /tmp/miniconda.sh

# Install huggingface_hub globally to ensure huggingface-cli is available
RUN /root/miniconda3/bin/conda install -c huggingface huggingface_hub -y

# Create a conda environment and install dependencies
RUN /root/miniconda3/bin/conda create -n video-env python=3.8 -y && \
    /root/miniconda3/bin/conda install -n video-env pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
    /root/miniconda3/bin/conda run -n video-env pip install \
        accelerate \
        diffusers \
        transformers \
        fastapi \
        uvicorn[standard] \
        moviepy \
        opencv-python-headless \
        tqdm \
        imageio \
        imageio[ffmpeg] && \
    /root/miniconda3/bin/conda clean -a -y


# Clone required repositories
RUN git clone https://github.com/CompVis/stable-diffusion.git && \
    git clone https://github.com/deforum-art/deforum-stable-diffusion.git && \
    git clone https://github.com/hzwer/arXiv2020-RIFE.git

# Install RIFE dependencies
RUN cd arXiv2020-RIFE && /root/miniconda3/bin/conda run -n video-env pip install -r requirements.txt

# Log in to Hugging Face with token
# Replace `your_huggingface_token` with your actual token or use build arguments
ARG HUGGINGFACE_TOKEN
RUN huggingface-cli login --token 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

# Create and set workdir
WORKDIR /workspace

# Copy local files to container
COPY . /workspace

# Expose port 8000 for FastAPI
EXPOSE 8000

# Run the server
CMD ["/root/miniconda3/bin/conda", "run", "-n", "video-env", "uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

