from django.contrib import admin

# Register your models here.
from counters.models import Order


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['uuid', 'customer_name', 'item_name', 'price', 'created_at', 'updated_at']
    ordering = ['created_at']

