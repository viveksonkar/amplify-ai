from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid

from generate_video import create_video_from_prompt
from generate_image import create_image_from_prompt

app = FastAPI()

class PromptRequest(BaseModel):
    prompt: str

@app.post("/generate-video")
def generate_video_endpoint(request: PromptRequest):
    """Generate a video based on a user prompt."""
    try:
        # Generate a unique file name for the output video
        video_id = str(uuid.uuid4())
        output_path = f"/workspace/output/output_{video_id}.mp4"

        # Call the Stable Diffusion + MoviePy pipeline
        create_video_from_prompt(request.prompt, output_path)

        # Return the location of the generated video
        return {"status": "success", "video_path": output_path}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate-image")
def generate_image_endpoint(request: PromptRequest):
    """Generate a single image based on a user prompt."""
    try:
        # Generate a unique file name for the output image
        image_id = str(uuid.uuid4())
        output_path = f"/workspace/output/output_{image_id}.png"

        # Call the Stable Diffusion pipeline for image generation
        create_image_from_prompt(request.prompt, output_path)

        # Return the location of the generated image
        return {"status": "success", "image_path": output_path}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
