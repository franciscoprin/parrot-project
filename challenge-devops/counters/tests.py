from decimal import Decimal

import factory
from django.test import TestCase, Client

from factory.django import DjangoModelFactory
from faker import Factory

from counters.models import Order

current_faker = Factory.create()


class OrderFactory(DjangoModelFactory):
    customer_name = factory.LazyFunction(current_faker.name)
    item_name = factory.LazyFunction(current_faker.word)
    price = Decimal(10.00)

    class Meta:
        model = Order


class OrderViewSetTest(TestCase):

    def test_empty_list(self):
        client = Client()
        response = client.get('/api/v1/counters/orders/', content_type='application/json')
        self.assertEqual(200, response.status_code)
        self.assertEqual({'count': 0, 'next': None, 'previous': None, 'results': []}, response.data)

    def test_list(self):
        OrderFactory()
        OrderFactory()
        client = Client()
        response = client.get('/api/v1/counters/orders/', content_type='application/json')
        self.assertEqual(200, response.status_code)
        self.assertEqual(2, response.data['count'])
        self.assertEqual(2, len(response.data['results']))

    def test_create(self):
        client = Client()
        data = {'customerName': 'Cosme', 'itemName': 'Soda', 'price': '10.00'}
        response = client.post('/api/v1/counters/orders/', content_type='application/json', data=data)
        self.assertEqual(201, response.status_code)
        self.assertIn('uuid', response.data)
        self.assertIn('created_at', response.data)
        self.assertIn('updated_at', response.data)
        self.assertEqual('Cosme', response.data['customer_name'])
        self.assertEqual('Soda', response.data['item_name'])
        self.assertEqual('10.00', response.data['price'])
