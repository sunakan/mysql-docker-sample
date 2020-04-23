export DOCKER_MYSQL_TAG=5.6
export DOCKER_NETWORK_NAME=standalone-mysql-network

.PHONY: network, bash

network:
	docker network ls | grep ${DOCKER_NETWORK_NAME} \
		|| docker network create ${DOCKER_NETWORK_NAME}

bash: network
	docker run \
		--rm \
		--interactive \
		--tty \
		--network ${DOCKER_NETWORK_NAME} \
		--hostname mysql-client-1 \
		--name mysql-client-1 \
		--user `id --user`:`id --group` \
		--env LANG=C.UTF-8 \
		--env TZ=Asia/Tokyo \
		mysql:${DOCKER_MYSQL_TAG} \
		bash
