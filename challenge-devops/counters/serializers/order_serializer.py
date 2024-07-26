from rest_framework import serializers

from counters.models import Order


class OrderSerializer(serializers.ModelSerializer):
    class Meta:
        model = Order
        fields = ['uuid', 'customer_name', 'item_name', 'price', 'created_at', 'updated_at']