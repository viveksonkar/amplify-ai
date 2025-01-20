from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import requests

app = FastAPI()

class GenerateImageRequest(BaseModel):
    prompt: str
    steps: int = 50
    cfg_scale: float = 7.5
    width: int = 512
    height: int = 512

class GenerateVideoRequest(BaseModel):
    prompt: str
    steps_per_frame: int = 30
    total_frames: int = 120
    cfg_scale: float = 7.5

AUTOMATIC_API_URL = "http://localhost:7860"

@app.post("/generate-image")
def generate_image(request: GenerateImageRequest):
    try:
        payload = {
            "prompt": request.prompt,
            "steps": request.steps,
            "cfg_scale": request.cfg_scale,
            "width": request.width,
            "height": request.height,
        }
        response = requests.post(f"{AUTOMATIC_API_URL}/sdapi/v1/txt2img", json=payload)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate-video")
def generate_video(request: GenerateVideoRequest):
    try:
        # Assume Deforum or animation features are enabled in Automatic1111 setup
        payload = {
            "prompt": request.prompt,
            "cfg_scale": request.cfg_scale,
            "steps_per_frame": request.steps_per_frame,
            "frames": request.total_frames,
        }
        response = requests.post(f"{AUTOMATIC_API_URL}/sdapi/v1/txt2vid", json=payload)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=str(e))
