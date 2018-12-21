NAME = aospan/mangrove

.PHONY: all build

all: build

build:
	docker build --no-cache -t $(NAME) .
