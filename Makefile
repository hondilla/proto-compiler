build:
	docker build -t protoc .
php:
	docker run --rm -it -v $(shell pwd)/:/protos protoc protoc-php $(path)
kotlin:
	docker run --rm -it -v $(shell pwd)/:/protos protoc protoc-kotlin $(path)
js:
	docker run --rm -it -v $(shell pwd)/:/protos protoc protoc-js $(path)