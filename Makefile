.PHONY: test_native test

test_native:
	bats --formatter tap test/

test:
	docker build -t honeyconf-testing .
	docker run -v "${PWD}:/code" honeyconf-testing test