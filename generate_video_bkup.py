import torch
import numpy as np
from tqdm import tqdm
from diffusers import StableDiffusionPipeline
from moviepy.editor import ImageSequenceClip

print("Loading model...")

model_id = "CompVis/stable-diffusion-v1-4"

# Load the model in half-precision mode for reduced memory usage
pipe = StableDiffusionPipeline.from_pretrained(
    model_id,
    torch_dtype=torch.float16,
    revision="fp16"
).to("cuda")

print("Model loaded successfully.")

prompts = [
    "A fantasy landscape with mountains and rivers, sunrise",
    "A fantasy landscape with mountains and rivers, sunset"
]

print("Generating images...")
images = []
for prompt in tqdm(prompts, desc="Generating images"):
    print(f"Processing prompt: {prompt}")
    # Generate image using pipeline
    image = pipe(prompt).images[0]
    print("Image generated.")
    images.append(image)

print("Creating video...")

# Convert PIL Images to NumPy arrays
frames = [np.array(img) for img in images]

clip = ImageSequenceClip(frames, fps=1)
clip.write_videofile("generated_video.mp4", codec="libx264")

print("Video saved as 'generated_video.mp4'")
print("Script completed.")
