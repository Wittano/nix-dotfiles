OUTPUT_DIR=./build

build:
	go build -o $(OUTPUT_DIR)/app cmd/app/main.go

run:
	go run cmd/app/main.go

clean:
	if [ -d ./build ]; then rm -r $(OUTPUT_DIR); fi
