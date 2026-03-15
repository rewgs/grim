.PHONY: 
	all 
	clean

clean:
	go mod tidy
	go clean -cache

test: clean
	go test -v ./...

run: clean test 
	go run cmd/main.go

build: clean test
	go build -o ./out/grim ./cmd/grim.go
	
all: 
	clean
	test
	build
