from environ import environ

env = environ.Env()

APP_VERSION = env('APP_VERSION', default='N/A')

# Database
# https://docs.djangoproject.com/en/3.2/ref/settings/#databases
# Determine the environment
DJANGO_ENV = env('DJANGO_ENV', default='development')

# Default database settings
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': env('POSTGRES_DB', default=None),
        'USER': env('POSTGRES_USER', default=None),
        'PASSWORD': env('POSTGRES_PASSWORD', default=None),
        'HOST': env('POSTGRES_HOST', default=None),
        'PORT': env('POSTGRES_PORT', default=None),
    }
}