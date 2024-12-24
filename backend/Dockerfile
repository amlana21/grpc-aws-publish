FROM --platform=linux/amd64 golang
ADD . /go/src/github.com/amlana21/grpc-aws
WORKDIR /app
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags '-extldflags "-static"' -o main ./src/server

EXPOSE 5300
EXPOSE 50051
CMD ["/app/main"] 