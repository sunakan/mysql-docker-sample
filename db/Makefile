export DOCKER_MYSQL_TAG=5.6
export TMP_MYSQL_VOLUME=${PWD}/tmp/mysql-vol/
export DOCKER_NETWORK_NAME=standalone-mysql-network
export MYSQL_DATABASE=hoge
export MYSQL_USER=hoge
export MYSQL_PASSWORD=hoge

.PHONY: create-tmp-volume, network, up, clean

create-tmp-volume:
	mkdir --parents ${TMP_MYSQL_VOLUME}

network:
	docker network ls | grep ${DOCKER_NETWORK_NAME} \
		|| docker network create ${DOCKER_NETWORK_NAME}

up: create-tmp-volume network
	docker run \
		--rm \
		--interactive \
		--tty \
		--network ${DOCKER_NETWORK_NAME} \
		--hostname mysql \
		--name mysql \
		--user `id --user`:`id --group` \
		--publish 3306:3306 \
		--mount type=bind,source=${TMP_MYSQL_VOLUME},target=/var/lib/mysql/ \
		--env MYSQL_ROOT_PASSWORD=root \
		--env MYSQL_DATABASE=${MYSQL_DATABASE} \
		--env MYSQL_USER=${MYSQL_USER} \
		--env MYSQL_PASSWORD=${MYSQL_PASSWORD} \
		--env LANG=C.UTF-8 \
		--env TZ=Asia/Tokyo \
		mysql:${DOCKER_MYSQL_TAG} \
			--character-set-server=utf8mb4 \
			--collation-server=utf8mb4_unicode_ci

down:
	docker container ls --quiet --filter "name=mysql" | xargs -I {} docker stop {}
	docker network   ls --quiet --filter "name=${DOCKER_NETWORK_NAME}" | xargs -I {} docker network rm {}

clean: down
	rm -rf tmp/*
