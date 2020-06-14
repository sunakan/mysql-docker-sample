include Makefile.ytt

.PHONY: up
up:
	cd db && make up

.PHONY: down
down:
	cd db && make down

.PHONY: clean
clean:
	cd db && make clean

.PHONY: client
client:
	cd client-1 && make client
