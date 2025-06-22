from openai import OpenAI
import json
import os

# Create your views here.
# temporary saving api in env
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def get_response(words):
    # System prompt
    instruction = f"""
    Analyze the content and return a structured JSON object with:
    1. "main_claim" : Main factual claim made in the text.
    2. "verdict": "True", "Likely True", "Unclear", or "Misinformation".
    3. "reasoning": Explain how you got the verdict and name any sources used.
    4. "rating": 0-100 score (0 = real, 100 = hoax)
    5. "web_link": All URLs supporting the verdict
    Return only the JSON object. No extra text 
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

    response = client.responses.create(
        model="gpt-4o-mini",
        tools=tools,
        instructions=instruction,
        input=[
            {
                "role": "developer",
                "content": instruction
            },
            {
                "role": "user",
                "content": user_prompt
            }
        ],
        
    )

    return response

def format_response(response):
    # Extract the claim and reasoning
    content = response.output_text
    # Remove unnecessary text or formatting
    content = content.strip()
    
    try:
        # Parse json object into python dictionary
        parsed = json.loads(content)
        return parsed
    except json.JSONDecodeError:
        print("No valid JSON detected:")
        print(content)
        return{
            "main_claim": "",
            "verdict": "Unclear",
            "reasoning": content,  # fallback to raw text
            "rating": 50
        }

def generate_response(words):
    #call the OpenAI API
    response = get_response(words)

    return format_response(response)

print(generate_response("earth is flat"))