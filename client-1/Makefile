################################################################################
# 変数
################################################################################
define config-json
	cat ../config.yml | ../ytt -f- --output json
endef
DOCKER_MYSQL_TAG    := $(shell $(call config-json) | jq --raw-output '.docker.mysql_tag')
DOCKER_NETWORK_NAME := $(shell $(call config-json) | jq --raw-output '.docker.network_name')

DOCKER_MYSQL_HOST   := $(shell $(call config-json) | jq --raw-output '.docker.mysql_host')
MYSQL_DATABASE      := $(shell $(call config-json) | jq --raw-output '.db.mysql_database')
MYSQL_USER          := $(shell $(call config-json) | jq --raw-output '.db.mysql_user')
MYSQL_PASSWORD      := $(shell $(call config-json) | jq --raw-output '.db.mysql_password')

################################################################################
# DB Client起動
# $ make client
################################################################################
.PHONY: network
network:
	( docker network ls | grep $(DOCKER_NETWORK_NAME) ) \
	|| docker network create $(DOCKER_NETWORK_NAME)
.PHONY: client
client: network
	docker run \
		--rm \
		--interactive \
		--tty \
		--network $(DOCKER_NETWORK_NAME) \
		--user `id -u`:`id -g` \
		--env LANG=C.UTF-8 \
		--env TZ=Asia/Tokyo \
		mysql:$(DOCKER_MYSQL_TAG) \
			mysql --host $(DOCKER_MYSQL_HOST) --database $(MYSQL_DATABASE) --user $(MYSQL_USER) --password=$(MYSQL_PASSWORD)
