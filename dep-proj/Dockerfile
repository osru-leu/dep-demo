FROM golang:1.22.5 as builder

WORKDIR /app

COPY go.mod ./

Run go mod download

COPY . .

# Build binary
RUN CGO_ENABLED=0 GOOS=linux go build -a -o hello .

# Final Image
FROM scratch

COPY --from=builder /app/hello /hello

EXPOSE 8080

ENTRYPOINT ["/hello"]
