from django.urls import path
from .views import chatbot_response, gemini_response

urlpatterns = [
    path("response/", gemini_response, name="chatbot"),
]
