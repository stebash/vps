# Function: Docker Rebuild
# [execute: down, remove, pull, build, up]
# $(call docker_rebuild,"stack_name","path/of/docker-compose-yml"
define docker_rebuild
	docker compose -p $(1) -f $(2)/docker-compose.yml down && \
	docker compose -p $(1) -f $(2)/docker-compose.yml rm -f && \
	docker compose -p $(1) -f $(2)/docker-compose.yml pull && \
	docker compose -p $(1) -f $(2)/docker-compose.yml build --no-cache && \
	docker compose -p $(1) -f $(2)/docker-compose.yml up -d
endef
# Initialization
init:
	# docker network create --driver bridge reverse-proxy
	@docker network inspect reverse-proxy >/dev/null 2>&1 && echo "Network reverse-proxy already exists" || (echo "Creating network reverse-proxy" && docker network create --driver bridge reverse-proxy)
# Portainer
portainer:
	docker volume create portainer_data
	$(call docker_rebuild,"portainer","docker/portainer")
# NGINX Proxy Manager
nginxpm:
	docker volume create nginxpm_data
	docker volume create nginxpm_letsencrypt
	$(call docker_rebuild,"nginxpm","docker/nginxpm")
# Gotify
gotify:
	docker volume create gotify_data
	$(call docker_rebuild,"gotify","docker/gotify")
# WatchTower
watchtower:
	$(call docker_rebuild,"watchtower","docker/watchtower")
# Glances
glances:
	$(call docker_rebuild,"glances","docker/glances")
# IT Tools
it-tools:
	$(call docker_rebuild,"it-tools","docker/it-tools")
# Wikidocs
wikidocs:
	docker volume create wikidocs-datasets
	$(call docker_rebuild,"wikidocs","docker/wikidocs")
