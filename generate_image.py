import torch
from diffusers import StableDiffusionPipeline

# Global: load model once, reuse
model_id = "CompVis/stable-diffusion-v1-4"
print("Loading model. This may take a moment...")
pipe = StableDiffusionPipeline.from_pretrained(
    model_id,
    torch_dtype=torch.float16,  # or float32 if you don't have enough VRAM
    revision="fp16",            # ensure half-precision is used
).to("cuda")
print("Model loaded successfully.")

def create_image_from_prompt(prompt: str, output_path: str):
    """Generate a single image for a given prompt."""
    print(f"Generating image for prompt: {prompt}")
    
    # Generate the image
    image = pipe(prompt).images[0]
    
    # Save the image
    image.save(output_path)
    print(f"Image saved at {output_path}")
