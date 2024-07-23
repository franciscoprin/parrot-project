# syntax=docker/dockerfile:1
FROM python:3

ENV PYTHONUNBUFFERED=1

WORKDIR /code
COPY requirements.txt /code/

COPY scripts/entrypoint /entrypoint
RUN sed -i 's/\r//' /entrypoint
RUN chmod +x /entrypoint

RUN pip install -r requirements.txt
COPY . /code/

ENTRYPOINT ["/entrypoint"]