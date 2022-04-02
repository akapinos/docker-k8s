FROM python:3.10
WORKDIR /usr
RUN git clone https://github.com/akapinos/flask_oauth /usr/app
WORKDIR /usr/app
RUN pip install -r requirements.txt
COPY .env /usr/app/.env
RUN flask
EXPOSE 5000
ENTRYPOINT ["python3"]
CMD ["app.py"]