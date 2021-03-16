FROM node:14-buster-slim

RUN apt-get update && apt-get install -y  --no-install-recommends \
        ca-certificates curl xz-utils \
        build-essential libssl-dev zlib1g-dev \
        libffi-dev

# (workaround) Install cookiecutter and mkdocs to avoid the need to run docker in docker
RUN cd /tmp && curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz && \
    tar -xvf Python-3.8.2.tar.xz && \
    cd Python-3.8.2 && \
    ./configure --enable-optimizations && \
    make -j 4 && \
    make altinstall

RUN apt update
RUN apt install -y mkdocs

RUN pip3.8 install mkdocs-techdocs-core

RUN pip3.8 install cookiecutter && \
    apt remove -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev libbz2-dev g++ python-pip python-dev && \
    rm -rf /var/cache/apt/* /tmp/Python-3.8.2 && \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

ADD yarn.lock package.json packages/backend/dist/skeleton.tar.gz ./

RUN yarn install --frozen-lockfile --production --network-timeout 300000 && rm -rf "$(yarn cache dir)"

ADD packages/backend/dist/bundle.tar.gz app-config.yaml ./

CMD ["node", "packages/backend", "--config", "app-config.yaml"]