build:
	swift build -c release

install:
	cp .build/out/Products/Release/mu-cli /usr/local/bin/mu-cli

all: build install