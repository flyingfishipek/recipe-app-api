# recipe-app-api

## Create Dockerfile

1. Create `Dockerfile`

```
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
```

2. Create `requirement.yml` file and app `folder`

```
Django>=2.1.3,<=2.2.0
djangorestframework>=3.9.0,<=3.10.0
```

3. Login to DockerHub and build image

```shell
docker login
docker build .
```

## Configure Docker Compose

1. Create `docker-compose.yml` file

```
version: "3"

services:
  app:
    build:
      context: .
    ports:
      - "8000:8000"
    volumes:
      - ./app:/app
    command: >
      sh -c "python manage.py runserver 0.0.0.0:8000"
```

2. Build the image `app`

```shell
docker-compose build
```

## Initiate a Django project in container

1. Run the `app` service and execute command to start a Django project in /app folder (recall that /app is also `WORKDIR`)

```shell
docker-compose run app sh -c "django-admin.py startproject app ."
```
