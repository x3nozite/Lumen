from openai import OpenAI
from pydantic import BaseModel
import json
import os
from serpapi import GoogleSearch

# Create your views here.
# temporary saving api in env
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Calling the OpenAI api to extract the main claim from the user's text
def extract_main_claim(words):
    instruction = "Extract the main factual claim made in the following content. Just the main claim, no other text or formatting"

    response = client.responses.create(
        model="gpt-4o-mini",
        input=[
            {
                "role":"developer",
                "content": instruction
            },
            {
                "role": "user",
                "content": words
            }
        ],
    )

    return response.output_text


# search the web with main claim as the query 
def search_web(claim, num_results=3):
    params = {
        "q": claim,
        # limit number of results used to 3
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

# Format of the response
class LumenResponse(BaseModel):
    main_claim: str
    verdict: str
    reasoning: str
    rating: int
    web_links: list[str]

def get_response(claim, links):
    # Format the weblinks for the ai model to search
    formatted_sources = "\n".join(
        [f"- {item['title']} ({item['link']}): {item['snippet']}" for item in links]
    )

    # System prompt
    instruction = f"""
    External Sources: {formatted_sources}
    Analyze the content and return a structured JSON object with this structure:
    1. "main_claim" : Main claim.
    2. "verdict": "True", "Likely True", "Unclear", "Likely False, or "Misinformation".
    3. "reasoning": Explain how you got the verdict.
    4. "rating": 0-100 score (0 = true, 50 = unclear, 100 = misinformation).
    5. "web_links": All URLs supporting the verdict (External Sources).
    Return only valid JSON object. No extra text or formatting.
    """

    # Main claim (obtained with the extract_main_claim() function)
    user_prompt = f"""
    Content:
    \"\"\"{claim}\"\"\"
    """

    response = client.responses.parse(
        model="gpt-4o-mini",
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
    claim = extract_main_claim(words)
    links = search_web(claim)

    response = get_response(claim, links)

    return format_response(response)