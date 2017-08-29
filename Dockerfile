FROM gliderlabs/logspout:v3.2.2

RUN apk --no-cache add \
    bash

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
