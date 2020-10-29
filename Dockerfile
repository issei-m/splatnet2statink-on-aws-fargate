FROM python:3.6-alpine3.12 as build

RUN apk --update --no-cache add build-base zlib-dev jpeg-dev

WORKDIR /opt/app

COPY requirements.txt .
RUN pip install -r requirements.txt

# Make sure *.pyc files have generated
COPY . .
RUN echo '{"api_key":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx","cookie":"","session_token":"","user_lang":"ja-JP"}' > config.txt \
    && ./splatnet2statink.py -h \
    && rm config.txt

FROM python:3.6-alpine3.12 as package

WORKDIR /opt/app

COPY --from=build /opt/app /opt/app
COPY --from=build /usr/local/lib/python3.6/site-packages /usr/local/lib/python3.6/site-packages

ENV SPLATNET2STATINK_CONFIG=""

ENTRYPOINT ["/opt/app/entrypoint.sh", "./splatnet2statink.py"]
