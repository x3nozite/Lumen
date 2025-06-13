from django.shortcuts import render
from openai import OpenAI
import os

# Create your views here.
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))