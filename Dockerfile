FROM python:3.7-alpine as base

FROM base as builder

RUN apk add --no-cache --virtual .build-deps gcc musl-dev
RUN pip install cython
RUN apk del .build-deps gcc musl-dev

RUN mkdir /install
WORKDIR /install

COPY requirements.txt /requirements.txt

RUN pip install -U setuptools pip

RUN apk add build-base

#RUN pip install -r /requirements.txt
RUN pip install --install-option="--prefix=/install" -r /requirements.txt

FROM base

COPY --from=builder /install /usr/local
COPY . /app

WORKDIR /app

CMD ["python", "app.py"]