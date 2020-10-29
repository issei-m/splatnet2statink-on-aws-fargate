FROM python:3.6-alpine3.12 as build

ARG SPLATNET2STATINK_VERSION="1.5.6"

RUN apk --update --no-cache add build-base zlib-dev jpeg-dev

RUN echo $SPLATNET2STATINK_VERSION
RUN cd /tmp; wget https://github.com/frozenpandaman/splatnet2statink/archive/v$SPLATNET2STATINK_VERSION.tar.gz \
    && tar xzf v$SPLATNET2STATINK_VERSION.tar.gz \
    && mv /tmp/splatnet2statink-$SPLATNET2STATINK_VERSION /opt/app

WORKDIR /opt/app

RUN pip install -r requirements.txt

# Make sure *.pyc files have generated
COPY . .
RUN echo '{"api_key":"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx","cookie":"","session_token":"","user_lang":"ja-JP"}' > config.txt \
    && ./splatnet2statink.py -h \
    && rm config.txt .gitignore

FROM python:3.6-alpine3.12 as package

WORKDIR /opt/app

COPY --from=build /usr/local/lib/python3.6/site-packages /usr/local/lib/python3.6/site-packages
COPY entrypoint.sh /entrypoint.sh
COPY --from=build /opt/app /opt/app

ENV SPLATNET2STATINK_CONFIG=""

ENTRYPOINT ["/entrypoint.sh", "./splatnet2statink.py"]
