from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class UserProfile(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField(max_length=50, unique=True)
    created = models.DateField(auto_now_add=True)