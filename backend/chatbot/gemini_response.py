from openai import OpenAI
from pydantic import BaseModel
import json
import os
from serpapi import GoogleSearch

# Create your views here.
# temporary saving api in env
client = OpenAI(
    api_key=os.getenv("GEMINI_API_KEY"),
    base_url="https://generativelanguage.googleapis.com/v1beta/openai/"
)

# Calling the OpenAI api to extract the main claim from the user's text
def extract_main_claim(words):
    instruction = f"""
    Extract the main factual claim made in the following content. Just the main claim, no other text or formatting.
    """

    response = client.chat.completions.create(
        model="gemini-2.5-flash",
        messages=[
            {
                "role": "system",
                "content": instruction
            },
            {
            "role": "user",
            "content": words
            }
        ]
    )

    return response.choices[0].message.content


# search the web with main claim as the query 
def search_web(claim, num_results=7):
    params = {
        "q": claim,
        # limit number of results used to 7
        "num": num_results,
        "api_key": os.getenv("SERPAPI_API_KEY"),
        "engine": "google"
    }

    # note. should add error prevention if no searches found
    search = GoogleSearch(params)
    results = search.get_dict()
    # parse the organic results
    organic_results = results.get("organic_results", [])

    # parse through organic result to extract each web links
    links = []
    for item in organic_results:
        links.append({
            "title": item.get("item"),
            "link": item.get("link"),
            "snippet": item.get("snippet")
        })

    return links

def get_response(claim, links):
    # Format the weblinks for the ai model to search
    formatted_sources = "\n".join(
        [f"- {item['title']} ({item['link']}): {item['snippet']}" for item in links]
    )

    # System prompt
    instruction = f"""
    External Sources  (Only use these as external sources): {formatted_sources}
    Analyze the content and return a structured JSON object with this structure:
    1. "main_claim" : Main claim.
    2. "verdict": "True", "Likely True", "Unclear", "Likely False, or "Misinformation".
    3. "reasoning": Explain how you got the verdict.
    4. "rating": 0-100 score (0 = true, 50 = unclear, 100 = misinformation).
    5. "web_links": All URLs supporting the verdict (External Sources).
    Return only valid JSON object. NO EXTRA TEXT OR FORMATTING.
    """

    # Main claim (obtained with the extract_main_claim() function)
    user_prompt = f"""
    Content:
    \"\"\"{claim}\"\"\"
    """

    response = client.chat.completions.create(
        model="gemini-2.5-flash",
        messages=[
            {
                "role":"system",
                "content": instruction
            },
            {
                "role": "user",
                "content": user_prompt
            }
        ],
    )

    return response.choices[0].message.content

def format_response(response):
    # Extract the claim and reasoning
    content = response
    return content

def generate_response_gemini(words):
    #call the OpenAI API
    claim = extract_main_claim(words)
    links = search_web(claim)

    response = get_response(claim, links)

    return format_response(response)