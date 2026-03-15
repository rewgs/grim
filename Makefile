.PHONY: 
	all 
	clean

clean:
	go mod tidy
	go clean -cache

test: clean
	go test -v ./...

run: clean
	go run cmd/cli/main.go

all: 
	clean
	test
	run
