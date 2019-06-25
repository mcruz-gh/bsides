FROM alpine:latest

RUN apk --no-cache add socat

COPY socat-shell.sh /tmp

WORKDIR /tmp

RUN chmod +x socat-shell.sh

ENTRYPOINT [ "./socat-shell.sh" ]