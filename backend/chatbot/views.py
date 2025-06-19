from django.shortcuts import render
import json
from django.http import JsonResponse
from .response_generator import generate_response

# Not too sure
def chatbot_response(request):
    if request.method == "POST":
        body = json.loads(request.body)
        user_claim = body.get("message", "")

        if not user_claim:
            return JsonResponse({"error": "No message provided"}, status=400)
        
        reply = generate_response(user_claim)

        return JsonResponse({"response": reply})