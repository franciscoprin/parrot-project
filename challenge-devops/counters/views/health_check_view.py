import logging

from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response

logger = logging.getLogger(__name__)


class HealthCheckView(APIView):

    def get(self, request):
        logger.info('Health Check')
        response = {
            'status': 'ok',
            'api_version': settings.APP_VERSION
        }
        return Response(response)
