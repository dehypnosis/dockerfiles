FROM alpine
RUN apk update && apk add bash curl python which
RUN curl -sSL https://sdk.cloud.google.com > /tmp/gcl && bash /tmp/gcl --install-dir=~/gcloud --disable-prompts
USER root
ENV PATH /root/gcloud/google-cloud-sdk/bin/:$PATH
RUN gcloud components install kubectl -q
CMD ["bash"]
