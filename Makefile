DC = docker compose
DC_DIR = ./srcs
VOLUMES_ROOT := $(PROJECT_ROOT)/data

.PHONY: setup-data mandatory-up bonus-up full-up stop restart logs build rebuild purge purge-all 

# CREATE DATA FOLDERS WITH CORRECT PERMISSIONS
setup-data:
	@echo "Creating data directories with correct permissions"
	@mkdir -p data/db data/wp
	@chown -R $$(id -u):$$(id -g) data/db data/wp
	@chmod -R 755 data/db data/wp
	@echo "Data directories ready"

# SERVICES
mandatory-up:
	@cd $(DC_DIR) && $(DC) up --build -d mariadb wordpress nginx

bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

full-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

stop:
	@cd $(DC_DIR) && $(DC) stop

restart: stop mandatory-up

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# BUILD
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) mandatory-up

# CLEANUP
purge:
	@echo "🧹 Basic cleanup - stopping containers and pruning"
	@cd $(DC_DIR) && $(DC) --profile bonus down --remove-orphans
	@docker system prune -f
	@docker volume prune -f

purge-all:
	@echo "☢️ NUCLEAR CLEANUP - Removing everything..."
	@cd $(DC_DIR) && $(DC) --profile bonus down --remove-orphans
	@docker system prune -a -f
	@docker builder prune -af
	@docker volume prune -f
	@rm -rf data/db/* data/wp/*
	@echo "All containers, images, volumes and data removed"