from openai import OpenAI
import json
import os

# Create your views here.
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def get_response(words):
    # System prompt
    system_prompt = f"""
    Read the following content and return a structured JSON object with the following fields:
    1. "main_claim" : Extract the main factual claim made in the text.
    2. "verdict": Ranging from "True", "Likely True", "Unclear", or "Misinformation".
    3. "reasoning": Explain your reasoning of how you arrived at the verdict.
    4. "rating": an integer between 0 and 100 indicating how likely the claim is fake (0 = real, 100 = hoax)

    Return only the JSON object. Do not include any explanation or formatting outside the JSON. 
    """

    user_prompt = f"""
        Content:
        \"\"\"{words}\"\"\"
    """

    # Make the api call
    response = client.chat.completions.create(
        model="gpt-4o-mini-2024-07-18",
        messages=[{
            "role": "system",
            "content": system_prompt
        },
        {
            "role": "user",
            "content": user_prompt
        }],
        temperature=0.8,
        max_tokens=1000
    )

    return response

def format_response(response):
    # Extract the claim and reasoning
    content = response.choices[0].message.content
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