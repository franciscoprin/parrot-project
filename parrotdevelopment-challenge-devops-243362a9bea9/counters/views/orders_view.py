from rest_framework import viewsets
from rest_framework.response import Response
from rest_framework.views import APIView

from counters.models import Order
from counters.serializers.order_serializer import OrderSerializer


class OrderViewSet(viewsets.ModelViewSet):

    queryset = Order.objects.all().order_by('-created_at')
    serializer_class = OrderSerializer


class OrderCount(APIView):
    def get(self, request):
        response = {
            'total_orders': Order.objects.count()
        }
        return Response(response)


class OrderDeleteAll(APIView):
    def post(self, request):
        Order.objects.all().delete()
        response = {}
        return Response(response)
