FROM docker:17.12.1-ce as static-docker-source

FROM alpine:3.11.3
LABEL maintainer="Diogo Oliveira <diogo0liveira@hotmail.com>"

ARG CLOUD_SDK_VERSION=278.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH
COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
RUN apk add --update --no-cache \
        bash \
        python \
        py-crcmod \
        libc6-compat \
        openssh-client \
        coreutils \  
        gnupg \
        && rm -rf /tmp/* \
        && rm -rf /var/cache/apk/*  

RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
 && tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
 && rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
 && gcloud config set core/disable_usage_reporting true \
 && gcloud config set component_manager/disable_update_check true \
 && gcloud config set metrics/environment github_docker_image \
 && gcloud components remove bq gsutil \
 && gcloud --version 
 
VOLUME ["/root/.config"]