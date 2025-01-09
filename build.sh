#docker build -t ai-video-generator --build-arg HUGGINGFACE_TOKEN=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 .


#DOCKER_BUILDKIT=1 docker build --secret id=huggingface_token,src=huggingface_token.txt -t ai-video-generator .

docker build -t ai-video-generator .

