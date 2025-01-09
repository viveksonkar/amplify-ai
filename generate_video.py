import torch
import numpy as np
from tqdm import tqdm
from diffusers import StableDiffusionPipeline
from moviepy.editor import ImageSequenceClip

# Global: load model once, reuse
model_id = "CompVis/stable-diffusion-v1-4"
print("Loading model. This may take a moment...")
pipe = StableDiffusionPipeline.from_pretrained(
    model_id,
    torch_dtype=torch.float16,  # or float32 if you don't have enough VRAM
    revision="fp16",            # ensure half-precision is used
).to("cuda")
print("Model loaded successfully.")

def create_video_from_prompt(prompt: str, output_path: str):
    """Generate a short video for a single prompt."""

    # Generate multiple frames (3 frames, for example)
    frames = []
    for i in tqdm(range(3), desc="Generating frames"):
        # We might vary the seed or the prompt slightly if you want multiple frames
        image = pipe(prompt).images[0]
        frames.append(np.array(image))

    print("Creating video...")

    # Create and save video
    clip = ImageSequenceClip(frames, fps=1)
    clip.write_videofile(output_path, codec="libx264")

    print(f"Video saved at {output_path}")
