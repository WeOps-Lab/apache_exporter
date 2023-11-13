#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /

COPY apache_exporter_linux_amd64 /apache_exporter_linux_amd64

RUN chmod +x /apache_exporter_linux_amd64

EXPOSE     9117
ENTRYPOINT [ "/apache_exporter_linux_amd64" ]
