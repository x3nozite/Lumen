from openai import OpenAI
import os

# Create your views here.
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def get_response(words):
    # System prompt
    system_prompt = f"""
    Read the following content and:
    1. Extract the main factual claim.
    2. Determine whether it is likely a hoax or true.
    3. Explain your reasoning.

    Content:
    \"\"\"{words}\"\"\"
    """

    # Make the api call
    response = client.chat.completions.create(
        model="gpt-4o-mini-2024-07-18",
        messages=[{
            "role": "user",
            "content": system_prompt
        }],
        temperature=0.8,
        max_tokens=800
    )

    return response

def generate_response(words):
    #call the OpenAI API
    response = get_response(words)

    return response

print(get_response("earth is flat"))