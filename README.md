# recipe-app-api

## 1. Create new django project

### 1.1. Create Dockerfile

1. Create `Dockerfile`

```Dockerfile
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

### 1.2. Configure Docker Compose

1. Create `docker-compose.yml` file

```yml
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

### 1.3. Initiate a Django project in container

1. Run the `app` service and execute command to start a Django project in `/app` folder (recall that `/app` is also `WORKDIR`)

```shell
docker-compose run app sh -c "django-admin.py startproject app ."
```
## 2. Setup Automation

1. Integrate GitHub account & repositories with Travis CI. Add DockerHub credentials to Travis-CI project (Settings > Environment Variables > add `DOCKER_PASSWORD` and `DOCKER_USERNAME`).

2. Add flake8 linting tool to `requirement.txt`

```
Django>=2.1.3,<=2.2.0
djangorestframework>=3.9.0,<=3.10.0

flake8>=3.9.2,<=3.10.0
```

and create flake8 configuration file in `app` folder `.flake8`:

```
[flake8]
exclude =
  migrations,
  __pycache__,
  manage.py,
  settings.py
```

3. Create `.travis.yml` file. Everytime we push a change to GitHub, Travis is going to spin up a python server (running python 3.6), going to start docker service, login to DockerHub, build our Dockerfile automatically, use pip to install docker-compose and finally run our script to run tests (not written any tests yet) and linting check.

```yml
language: python
python:
  - "3.6"

services:
  - docker

before_install:
  - echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin

before_script: pip install docker-compose

scripts:
  - docker-compose run app sh -c "python manage.py test && flake8"
```

After commiting and pushing the changes to GitHub a new [job](https://app.travis-ci.com/github/flyingfishipek/recipe-app-api/jobs/535625826#L2)  should be started in Travis CI.
