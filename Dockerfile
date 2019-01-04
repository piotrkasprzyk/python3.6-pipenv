FROM python:3.6-alpine

RUN set -ex \
    && apk add --no-cache \
            gcc \
            make \
            libc-dev \
            linux-headers \
            python-dev \
            zlib-dev \
            jpeg-dev \
    && pip install --no-cache-dir pipenv \
    && runDeps="$( \
            scanelf --needed --nobanner --recursive /venv \
                    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                    | sort -u \
                    | xargs -r apk info --installed \
                    | sort -u \
    )" \
    && apk add --virtual .python-rundeps $runDeps \
    && echo

# pipenv will crash in /
WORKDIR /opt/app

CMD ["python"]

