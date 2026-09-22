build:
	swift build -c release

install:
	sudo cp .build/out/Products/Release/mu-cli /usr/local/bin/mu-cli

all: build install