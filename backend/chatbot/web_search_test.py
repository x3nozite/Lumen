from openai import OpenAI
from pydantic import BaseModel
import json
import os
from serpapi import GoogleSearch

# Create your views here.
# temporary saving api in env
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# tools=[{
#     "type": "function",
#     "name": "search_web_serpapi",
#     "description": "Search the web to verify a claim with SerpAPI",
#     "parameters": {
#         "type": "object",
#         "properties": {
#             "claim": {
#                 "type": "string",
#                 "description": "The claim to verify"
#             },
#             "num_results": {
#                 "type": "integer",
#                 "description": "Number of results to return"
#             }
#         },
#         "required": ["claim", "num_results"]
#     }
# }]

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

def search_web(claim, num_results=3):
    params = {
        "q": claim,
        "num": num_results,
        "api_key": os.getenv("SERPAPI_API_KEY"),
        "engine": "google"
    }

    # note. should add error prevention if no searches found
    search = GoogleSearch(params)
    results = search.get_dict()
    organic_results = results.get("organic_results", [])

    links = []
    for item in organic_results:
        links.append({
            "title": item.get("item"),
            "link": item.get("link"),
            "snippet": item.get("snippet")
        })

    return links

class LumenResponse(BaseModel):
    main_claim: str
    verdict: str
    reasoning: str
    rating: int
    web_links: list[str]

def get_response(claim, links):
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
    4. "rating": 0-100 score (0 = real, 100 = hoax).
    5. "web_links": All URLs supporting the verdict (External Sources).
    Return only valid JSON object. No extra text or formatting.
    """

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