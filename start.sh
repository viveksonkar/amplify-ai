#docker run --gpus all -it --rm -v $(pwd):/workspace ai-video-generator bash

#docker run --gpus all -it --rm -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace ai-video-generator bash


# docker run --gpus all -it --rm \
#     -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace \
#     ai-video-generator \
#     /workspace/generate_video.py


# docker run --gpus all -it --rm  -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace  ai-video-generator  /workspace/generate_video.py

# To enter container and then run
# docker run --gpus all -it --rm \
#     -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace \
#     --entrypoint /bin/bash \
#     ai-video-generator

# after login
# conda run -n video-env python /workspace/generate_video.py

# This should work directly
docker run --gpus all -it --rm \
    -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace \
    ai-video-generator \
    /workspace/generate_video.py


docker run --gpus all -it --rm \
    --shm-size=2g \
    -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace \
    ai-video-generator \
    /workspace/generate_video.py

docker volume create hf-cache
docker run --gpus all -it --rm \
    -v hf-cache:/root/.cache/huggingface \
    -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai:/workspace \
    ai-video-generator \
    /workspace/generate_video.py


docker run --gpus all -it --rm  -p 8000:8000 -v ~/.cache/huggingface:/root/.cache/huggingface  ai-video-generator

docker run --gpus all -it --rm -p 8000:8000 -v ~/.cache/huggingface:/root/.cache/huggingface -v /mnt/c/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai/output:/workspace/output ai-video-generator

# Latest working command
docker run --gpus all -it --rm `
   -p 8000:8000 `
   -v "~/.cache/huggingface:/root/.cache/huggingface" `
   -v "C:/Stuff/Work/Development/FreeLancing/Amplify/amplify-ai/output:/workspace/output" `
   ai-video-generator