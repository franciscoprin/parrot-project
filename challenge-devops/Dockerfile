# syntax=docker/dockerfile:1
# installing chamber in docker: https://github.com/segmentio/chamber/wiki/Installation#from-a-docker-image
FROM segment/chamber:2 AS chamber

FROM python:3

COPY --from=chamber /chamber /bin/chamber

ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY requirements.txt /code/

COPY scripts/entrypoint /entrypoint
RUN sed -i 's/\r//' /entrypoint
RUN chmod +x /entrypoint

RUN pip install -r requirements.txt
COPY . /code/

ENTRYPOINT ["/entrypoint"]

# TODO: uncomment below and make the application work with gunicorn
# # https://docs.djangoproject.com/en/5.0/howto/deployment/wsgi/gunicorn/
# # AWS ALB works well with gunicorn: https://github.com/benoitc/gunicorn/issues/2568#issuecomment-827935102
# CMD ["gunicorn", "--bind", "0.0.0.0:8000", "challenge.wsgi.application"]
