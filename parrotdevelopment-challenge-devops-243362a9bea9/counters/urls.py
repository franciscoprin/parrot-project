from django.urls import path, include
from rest_framework import routers

from counters.views.health_check_view import HealthCheckView
from counters.views.orders_view import OrderViewSet, OrderCount, OrderDeleteAll

app_name = 'counters'

router = routers.DefaultRouter()
router.register(r'orders', OrderViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('delete_all', OrderDeleteAll.as_view(), name='order-delete-all'),
    path('count', OrderCount.as_view(), name='order-count'),
    path('health', HealthCheckView.as_view(), name='health-check')
]
