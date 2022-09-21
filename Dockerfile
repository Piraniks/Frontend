FROM python:3.8-slim-buster

RUN mkdir /app
WORKDIR /app

COPY requirements.txt .

EXPOSE 5000

CMD python app.py

RUN pip install -r requirements.txt

COPY . .
