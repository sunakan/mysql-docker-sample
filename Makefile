.PHONY: up, down, clean

up:
	cd db && make up

down:
	cd db && make down

clean:
	cd db && make clean

bash:
	cd client-1 && make bash
