FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        autoconf automake build-essential \
        curl git libtool libgmp-dev \
        libjpeg62-turbo-dev libsdl2-dev \
        libxpm-dev xserver-xorg-dev \
        zlib1g-dev unzip wget zip

WORKDIR /app

RUN useradd -ms /bin/bash xonotic

RUN chown xonotic /app

USER xonotic

RUN git clone https://gitlab.com/xonotic/xonotic.git

WORKDIR /app/xonotic

ARG XONOTIC_TAG=xonotic-v0.8.6

RUN git checkout -b "${XONOTIC_TAG}-build" ${XONOTIC_TAG}

RUN /app/xonotic/all update -l best

RUN /app/xonotic/all compile -r dedicated

RUN mkdir -p /app/xonotic/data/ && \
        cp /app/xonotic/server/server.cfg /app/xonotic/data/

EXPOSE 26000

CMD [ "/app/xonotic/all", "run", "dedicated" ]
