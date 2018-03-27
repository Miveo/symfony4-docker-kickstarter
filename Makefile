#!make
include .env

.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' Makefile| sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: ## Run sync, start containers and run doctrine migration as assets install
	@docker-sync start
	@docker-compose up -d
	@docker-compose exec php composer install
	docker-compose exec php bin/console doctrine:migration:migrate --allow-no-migration --no-interaction
	@docker-compose exec php bin/console assets:install --symlink --relative
	@docker-compose exec php rm -Rf var/cache/
	@docker-compose exec php bin/console cache:warmup

.PHONY: purge
purge: ## Purge all containers and associated volumes
	@docker-sync stop
	@docker-sync-stack clean
	@docker-compose down

.PHONY: server_start
server_start: ## Run docker stack and sync
	@docker-sync start
	@docker-compose up -d

.PHONY: server_stop
server_stop: ## Stop sync and docker stack
	@docker-compose stop
	@docker-sync stop

.PHONY: new_migration
new_migration: ## Shortcut to doctrine:migration:diff
	docker-compose exec php bin/console doctrine:migration:diff --no-interaction

.PHONY: php_cli
php_cli: ## Enter bash in the php container (in project folder)
	docker-compose exec php bash
