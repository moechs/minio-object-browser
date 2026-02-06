FROM golang:1.23-bookworm AS console

WORKDIR /app

COPY . .

RUN make console


FROM alpine:3.23

WORKDIR /app

RUN addgroup -S -g 1000 app \
    && adduser -S -u 1000 -G app -h /app app \
    && mkdir -p /app \
    && chown -R app:app /app

COPY --from=console /app/console /app/minio-console

EXPOSE 9090

USER app

ENTRYPOINT ["/app/minio-console"]

CMD ["server", "--host", "0.0.0.0", "--port", "9090"]
