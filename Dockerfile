FROM minio/minio:latest

ENV BUCKET_NAMES=""

COPY auto-setup.sh /auto-setup.sh
RUN chmod +x /auto-setup.sh

ENTRYPOINT ["/bin/sh", "-c", "/auto-setup.sh & minio server /data --console-address \":9001\""]

