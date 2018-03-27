#!make
include .env

.PHONY: list
list:
	@echo ""
	@echo "Targets:"
	@echo ""
	@echo "  install           > run sync, start containers and run doctrine migration as assets install"
	@echo "  purge             > purge all containers and associated volumes"
	@echo "  server_start      > run docker stack and sync"
	@echo "  server_stop       > stop sync and docker stack"
	@echo ""
	@echo "  new_migration     > shortcut to doctrine:migration:diff"
	@echo "  php_cli           > enter bash in the php container (in project folder)"

.PHONY: install
install:
	docker-sync start
	docker-compose up -d
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 composer install
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 bin/console doctrine:migration:migrate --allow-no-migration --no-interaction
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 bin/console assets:install --symlink --relative
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 rm -Rf var/cache/
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 bin/console cache:warmup

.PHONY: purge
purge:
	docker-sync stop
	docker-sync-stack clean
	docker-compose rm -vf

.PHONY: server_start
server_start:
	docker-sync start
	docker-compose up -d

.PHONY: server_stop
server_stop:
	docker-compose stop
	docker-sync stop

## Somes shortcuts here.
.PHONY: new_migration
new_migration:
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 bin/console doctrine:migration:diff --no-interaction

.PHONY: php_cli
php_cli:
	docker exec -it $(COMPOSE_PROJECT_NAME)_php_1 bash
