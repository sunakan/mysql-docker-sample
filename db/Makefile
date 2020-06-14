################################################################################
# 変数
################################################################################
define config-json
	cat ../config.yml | ../ytt -f- --output json
endef
DOCKER_MYSQL_TAG    := $(shell $(call config-json) | jq --raw-output '.docker.mysql_tag')
DOCKER_NETWORK_NAME := $(shell $(call config-json) | jq --raw-output '.docker.network_name')
DOCKER_MYSQL_HOST   := $(shell $(call config-json) | jq --raw-output '.docker.mysql_host')
TMP_MYSQL_VOLUME    := $(PWD)/tmp/mysql-vol
MYSQL_DATABASE      := $(shell $(call config-json) | jq --raw-output '.db.mysql_database')
MYSQL_USER          := $(shell $(call config-json) | jq --raw-output '.db.mysql_user')
MYSQL_PASSWORD      := $(shell $(call config-json) | jq --raw-output '.db.mysql_password')

################################################################################
# DB起動 && MySQL自体の起動wait
# $ make create-tmp-volume
################################################################################
.PHONY: create-tmp-volume
create-tmp-volume:
	mkdir -p $(TMP_MYSQL_VOLUME)
.PHONY: network
network:
	docker network ls | grep $(DOCKER_NETWORK_NAME) \
		|| docker network create $(DOCKER_NETWORK_NAME)
.PHONY: up
up: create-tmp-volume network
	docker run \
		--detach \
		--rm \
		--interactive \
		--tty \
		--network $(DOCKER_NETWORK_NAME) \
		--hostname $(DOCKER_MYSQL_HOST) \
		--name $(DOCKER_MYSQL_HOST) \
		--user `id -u`:`id -g` \
		--publish 3306:3306 \
		--mount type=bind,source=$(TMP_MYSQL_VOLUME),target=/var/lib/mysql/ \
		--env MYSQL_ROOT_PASSWORD=root \
		--env MYSQL_DATABASE=$(MYSQL_DATABASE) \
		--env MYSQL_USER=$(MYSQL_USER) \
		--env MYSQL_PASSWORD=$(MYSQL_PASSWORD) \
		--env LANG=C.UTF-8 \
		--env TZ=Asia/Tokyo \
		mysql:$(DOCKER_MYSQL_TAG) \
			--character-set-server=utf8mb4 \
			--collation-server=utf8mb4_unicode_ci
	make health-check-db

################################################################################
# MySQLが立ち上がるまでwaitする
# $ make health-check-db
################################################################################
.PHONY: health-check-db
health-check-db: network
	docker run \
	--rm \
	--interactive \
	--tty \
	--network $(DOCKER_NETWORK_NAME) \
	mysql:$(DOCKER_MYSQL_TAG) \
		bash -c 'while ! mysqladmin ping --host $(DOCKER_MYSQL_HOST) --silent; do sleep 1; done; echo DB ready.'

################################################################################
# MySQLを落とす
# $ make down
################################################################################
.PHONY: down
down:
	docker container ls --quiet --filter 'name=$(DOCKER_MYSQL_HOST)' | xargs -I {container-id} docker stop {container-id}
	docker network ls --quiet --filter 'name=$(DOCKER_NETWORK_NAME)' | xargs -I {network-id} docker network rm {network-id}

################################################################################
# 片付け
# $ make clean
################################################################################
.PHONY: clean
clean: down
	rm -rf tmp/*
