from django.db import models

# Create your models here.
class LumenResponse(models.Model):
    main_claim = models.CharField(max_length=255)
    verdict = models.CharField(max_length=31)
    reasoning = models.TextField()
    rating = models.IntegerField()
    web_links = models.JSONField()
    date = models.DateTimeField(auto_now_add=True)
