FROM alpine:latest

RUN apk --update --no-cache add git gcc protoc

RUN git clone -b v1.45.x https://github.com/grpc/grpc /usr/src/grpc

RUN apk --update --no-cache add --virtual deps linux-headers g++ make cmake

RUN cd /usr/src/grpc \
 && git submodule update --init \
 && mkdir -p cmake/build \
 && cd cmake/build \
 && cmake ../.. \
 && make grpc_php_plugin \
 && mv /usr/src/grpc/cmake/build/grpc_php_plugin /usr/bin/grpc_php_plugin \
 && rm -rf /usr/src/grpc

RUN apk del --purge deps

RUN echo '#!/bin/sh' > /usr/bin/protoc-php \
 && echo 'protoc --proto_path=/protos/protos $(find /protos/protos -name "*.proto") --php_out=/protos/$1 --grpc_out=/protos/$1 --plugin=protoc-gen-grpc=/usr/bin/grpc_php_plugin' >> /usr/bin/protoc-php \
 && chmod +x /usr/bin/protoc-php

RUN echo '#!/bin/sh' > /usr/bin/protoc-kotlin \
 && echo 'protoc --proto_path=/protos/protos $(find /protos/protos/ -name "*.proto") --java_out=/protos/$1 --kotlin_out=/protos/$1' >> /usr/bin/protoc-kotlin \
 && chmod +x /usr/bin/protoc-kotlin

RUN echo '#!/bin/sh' > /usr/bin/protoc-js \
 && echo 'protoc --proto_path=/protos/protos $(find /protos/protos/ -name "*.proto") --js_out=/protos/$1' >> /usr/bin/protoc-js \
 && chmod +x /usr/bin/protoc-js
