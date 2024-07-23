import uuid
from django.db import models


class Order(models.Model):
    uuid = models.UUIDField(
        verbose_name='UUID',
        primary_key=True,
        default=uuid.uuid4,
        editable=False,
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    customer_name = models.CharField(max_length=256)
    item_name = models.CharField(max_length=256)
    price = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f'{self.uuid}: {self.customer_name}, {self.item_name}'



