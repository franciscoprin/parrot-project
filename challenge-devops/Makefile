#!/bin/bash

COMPOSE := docker-compose -f docker-compose.yml
ARG=

build:
	$(COMPOSE) build
	@echo "Building..."

up:
	@echo "Server up..."
	$(COMPOSE) up $(ARG)

superuser:
	@echo "Creating superuser..."
	$(COMPOSE) run django python manage.py createsuperuser

migrate:
	@echo "Applying migrations ..."
	$(COMPOSE) run django python manage.py migrate $(ARG)

migrations:
	@echo "Creating migrations ..."
	$(COMPOSE) run django python manage.py makemigrations $(ARG)

startapp:
	@echo "Creating app"
	$(COMPOSE) run django python manage.py startapp $(ARG)

test:
	@echo "Running tests with pytest cleaning cache..."
	$(COMPOSE) run --rm django bash -c "time DJANGO_ENV=testing python manage.py test $(ARG)"