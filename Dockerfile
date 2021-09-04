FROM python:3.7-alpine
MAINTAINER flyingfishipek@gmail.com

# allows for log messages to be immediately dumped to the stream instead of being buffered
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN adduser --disabled-password --gecos '' --home /app djangouser && chown -R djangouser /app

USER djangouser
