from django.shortcuts import render
import json
from django.http import JsonResponse
from .web_search_test import generate_response
from .gemini_response import generate_response_gemini
from .models import LumenResponse

#temporary
from django.views.decorators.csrf import csrf_exempt

# csrf_exempt to bypass system authorization checks. (Only for testting)
@csrf_exempt
def chatbot_response(request):
    if request.method == "POST":
        body = json.loads(request.body)
        user_claim = body.get("message", "")

        if not user_claim:
            return JsonResponse({"error": "No message provided"}, status=400)
        
        reply = generate_response(user_claim)

        return JsonResponse({"response": reply.model_dump()})
    

@csrf_exempt
def gemini_response(request):
    if request.method == "POST":
        body = json.loads(request.body)
        user_claim = body.get("message", "")

        if not user_claim:
            return JsonResponse({"error": "No message provided"}, status=400)
    
        raw_response = generate_response_gemini(user_claim)

        cleaned_response = raw_response.removeprefix("```json").removesuffix("```").strip()
        
        try:
            # Parse into dictionary
            response_dict = json.loads(cleaned_response)

            # Save response to DB
            claim = LumenResponse.objects.create(
                main_claim = response_dict["main_claim"],
                verdict = response_dict["verdict"],
                reasoning = response_dict["reasoning"],
                rating = response_dict["rating"],
                web_links = response_dict["web_links"]
            )

            return JsonResponse({
                "response": {
                    "main_claim": claim.main_claim,
                    "verdict": claim.verdict,
                    "reasoning": claim.reasoning,
                    "rating": claim.rating,
                    "web_links": claim.web_links,
                }
            })
        except Exception as e:
            return JsonResponse({"error": "Falied parsing AI Response", "details" : str(e)}, status=500)
        
    return JsonResponse({"error": "Invalid Request Method"}, status=405)
