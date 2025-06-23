from openai import OpenAI
from pydantic import BaseModel
import json
import os

# Create your views here.
# temporary saving api in env
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

class LumenResponse(BaseModel):
    main_claim: str
    verdict: str
    reasoning: str
    rating: int
    web_links: list[str]

def get_response(words):
    # System prompt
    instruction = f"""
    Analyze the content and return a structured JSON object with this structure:
    1. "main_claim" : Main factual claim made in the text.
    2. "verdict": "True", "Likely True", "Unclear", or "Misinformation".
    3. "reasoning": Explain how you got the verdict and name any sources used. Please always use external source whenever possible.
    4. "rating": 0-100 score (0 = real, 100 = hoax).
    5. "web_links": All URLs supporting the verdict.
    Return only valid JSON object. No extra text or formatting.
    """

    user_prompt = f"""
    Content:
    \"\"\"{words}\"\"\"
    """

    tools = [
        {
            "type": "web_search_preview"
        }
    ]

    response = client.responses.parse(
        model="gpt-4o-mini",
        tools=tools,
        input=[
            {
                "role":"developer",
                "content": instruction
            },
            {
                "role": "user",
                "content": user_prompt
            }
        ],
        text_format=LumenResponse
    )

    return response

def format_response(response):
    # Extract the claim and reasoning
    content = response.output_parsed
    return content

def generate_response(words):
    #call the OpenAI API
    response = get_response(words)

    return format_response(response)

print(generate_response("Tiannanmen Square Massacre death toll is only in the hundreds"))