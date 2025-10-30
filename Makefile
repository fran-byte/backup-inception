
DC = docker compose
DC_DIR = ./srcs
VOLUMES_ROOT := $(PROJECT_ROOT)/data

.PHONY: help setup-data mandatory-up bonus-up redis-config stop restart logs build rebuild purge purge-all


# CREATE DATA FOLDERS WITH CORRECT PERMISSIONS
# =======================================================================
setup-data:
	@echo "Creating data directories with correct permissions"
	@mkdir -p data/db data/wp
	@chown -R $$(id -u):$$(id -g) data/db data/wp
	@chmod -R 755 data/db data/wp
	@echo "Data directories ready"

# HELP
# =======================================================================
help:
	@echo "Available commands:"
	@echo "  make mandatory-up        # Start MANDATORY services only"
	@echo "  make bonus-up            # Start BONUS only (if mandatory is running)"	
	@echo "  make redis-config        # Add Redis configuration to WordPress"
	@echo "  make stop                # Stop all services"
	@echo "  make restart             # Restart all services"
	@echo "  make logs                # View all service logs"
	@echo "  make build               # Build images"
	@echo "  make rebuild             # Rebuild images without cache"
	@echo "  make purge               # Clean all containers, images (mandatory + bonus)"
	@echo "  make purge-all           # Full cleanup: containers, images, volumes, and extra files"

# SERVICES
# =======================================================================
mandatory-up:
	@cd $(DC_DIR) && $(DC) up --build -d

bonus-up:
	@cd $(DC_DIR) && $(DC) --profile bonus up --build -d

stop:
	@cd $(DC_DIR) && $(DC) stop

restart: stop mandatory-up

logs:
	@cd $(DC_DIR) && $(DC) logs --follow

# BUILD
# =======================================================================
build:
	@cd $(DC_DIR) && $(DC) build

rebuild:
	@cd $(DC_DIR) && $(DC) build --no-cache
	@$(MAKE) mandatory-up

# CLEANUP
# =======================================================================
purge:
	@cd $(DC_DIR) && $(DC) --profile bonus down --remove-orphans
	@docker system prune -a -f
	@docker builder prune -af
	@docker volume prune -f

purge-all: purge
	@echo "☢️ NUCLEAR CLEANUP - Removing extra files..."
	@docker volume prune -f
	@docker builder prune -af
	@rm -rf data/db/* data/wp/*

# REDIS CONFIGURATION
# =======================================================================
redis-config:
	@echo "⚙️  CONFIGURING REDIS WITH WP-CLI..."
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_HOST redis --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_PORT 6379 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_TIMEOUT 1 --add=true --type=constant
	@cd $(DC_DIR) && docker compose exec wordpress wp config set WP_REDIS_READ_TIMEOUT 1 --add=true --type=constant
	@echo "✅ Redis configuration added with WP-CLI"
	@echo "🎯 Install the plugin from WordPress Admin"

