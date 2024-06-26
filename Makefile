test: prep-code
	go test ./...

run: prep-code
	go run . --insecure --debug

render:
	crossplane beta render example/xr.yaml example/composition.yaml example/functions.yaml -r

build-and-push-dev: prep-code
ifndef FUNCTION_REGISTRY
	$(error FUNCTION_REGISTRY env var is undefined)
endif
	docker build . --tag=runtime
	rm package/*.xpkg; crossplane xpkg build -f package --embed-runtime-image=runtime
	crossplane xpkg push -f package/*.xpkg $(FUNCTION_REGISTRY)/function-aws-importer:dev

prep-code:
	go generate ./...
	go fmt ./...
	go vet ./...
