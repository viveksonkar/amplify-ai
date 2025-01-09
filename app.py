from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uuid
import os

from generate_video import create_video_from_prompt

app = FastAPI()

class PromptRequest(BaseModel):
    prompt: str

@app.post("/generate")
def generate_video_endpoint(request: PromptRequest):
    """Generate a video based on a user prompt."""
    try:
        # Generate a unique file name for the output video
        video_id = str(uuid.uuid4())
        output_path = f"/workspace/output_{video_id}.mp4"

        # Call your Stable Diffusion + MoviePy pipeline
        create_video_from_prompt(request.prompt, output_path)

        # Return the location of the generated video
        return {"status": "success", "video_path": output_path}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
