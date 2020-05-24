FROM golang:1.13-alpine as build

WORKDIR /app

COPY go.mod ./
RUN go mod download
COPY . .
RUN go build -o ekscloudwatch github.com/sysdiglabs/ekscloudwatch/cmd

FROM alpine

COPY --from=build /app/ekscloudwatch /ekscloudwatch

# Needed to connect to the CW Logs endpoint
RUN apk --no-cache update && \
    apk add ca-certificates && \
    adduser -D 1000 && \
    chmod +x /ekscloudwatch

USER 1000
CMD ["/ekscloudwatch"]
