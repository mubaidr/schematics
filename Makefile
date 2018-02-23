.PHONY: test

prepare:
	docker build -t nestjs/schematics .

lint:
	docker run \
		nestjs/schematics \
		/bin/sh -c "npm run -s lint:test && npm run -s lint:src"

test:
	docker run \
		nestjs/schematics \
		/bin/sh -c "npm run -s test"

build:
	docker run \
		-v $$(pwd):/usr/local/app \
		nestjs/schematics \
		/bin/sh -c "\
			rm -rf schematics && mkdir schematics && \
			npm run -s build && \
			cp -R src/* schematics && \
			find schematics/ -name '*.ts' -delete && \
			cp -R LICENSE package.json package-lock.json README.md schematics"
	docker run \
		-v $$(pwd)/schematics:/usr/local/app \
		nestjs/schematics \
		/bin/sh -c "npm pack"
