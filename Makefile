# =============================================
# Makefile for WordPress + MySQL + phpMyAdmin
# =============================================

# ---------- Make Commands ----------
# make create-docker-compose PROJECT_NAME=project_name WORDPRESS_PORT=8080 PHPMYADMIN_PORT=8081 (With PHPMyAdmin)
# make create-docker-compose PROJECT_NAME=project_name WORDPRESS_PORT=8080 (Without PHPMyAdmin)
# make create-gitignore
# make setup
# make up
# make down
# make ps
# make build
# make dbbackup-sql
# make dbbackup
# make dbrestore FILE=path/to/backup.sql or backup.sql.gz
# make clean

# ---------- Dynamic Project Configuration ----------
PROJECT_NAME     ?= betheme
WORDPRESS_PORT   ?= 9010
PHPMYADMIN_PORT  ?= 9011

NETWORK_NAME     := $(PROJECT_NAME)_network
WORDPRESS_VOLUME := ./$(PROJECT_NAME)-wordpress
BACKUP_ROOT      := ./mysql-backups

# ---------- Containers & Database ----------
WORDPRESS_CONTAINER  := $(PROJECT_NAME)_wordpress
MYSQL_CONTAINER      := $(PROJECT_NAME)_mysql
PHPMYADMIN_CONTAINER := $(PROJECT_NAME)_phpmyadmin

DB_NAME       := $(PROJECT_NAME)_db
DB_USER       := $(PROJECT_NAME)_user
DB_PASSWORD   := $(PROJECT_NAME)_password
DB_ROOT_PASS  := root_password

# ---------- Backup Configuration ----------
TIMESTAMP    := $(shell date +%F_%H-%M-%S)
BACKUP_DIR   := $(BACKUP_ROOT)/$(TIMESTAMP)
BACKUP_FILE  := $(BACKUP_DIR)/db_backup.sql
FILE_NAME    := docker-compose.yml
GIT_IGNORE   := .gitignore

# ---------- Backup Commands ----------

dbbackup-sql:
	@echo "Creating backup directory: $(BACKUP_DIR)"
	@mkdir -p $(BACKUP_DIR)
	@echo "Running mysqldump from container: $(MYSQL_CONTAINER)"
	@docker exec $(MYSQL_CONTAINER) /usr/bin/mysqldump -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME) > $(BACKUP_FILE)
	@echo "Backup saved to $(BACKUP_FILE)"

dbbackup:
	@echo "Creating backup directory: $(BACKUP_DIR)"
	@mkdir -p $(BACKUP_DIR)
	@echo "Running mysqldump from container: $(MYSQL_CONTAINER) and compressing"
	@docker exec $(MYSQL_CONTAINER) /usr/bin/mysqldump -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME) | gzip > $(BACKUP_FILE).gz
	@echo "Compressed backup saved to $(BACKUP_FILE).gz"

dbrestore:
ifndef FILE
	$(error Please provide a backup file using: make dbrestore FILE=path/to/file.sql or .sql.gz)
endif
	@echo "Restoring database '$(DB_NAME)' from $(FILE)"
	@if echo $(FILE) | grep -qE '\.gz$$'; then \
		gunzip -c $(FILE) | docker exec -i $(MYSQL_CONTAINER) /usr/bin/mysql -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME); \
	else \
		cat $(FILE) | docker exec -i $(MYSQL_CONTAINER) /usr/bin/mysql -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME); \
	fi
	@echo "Database restored from $(FILE)"

clean:
	@echo "Cleaning old backups (keeping latest 3)"
	@ls -dt $(BACKUP_ROOT)/* 2>/dev/null | tail -n +2 | xargs rm -rf || true
	@echo "Cleanup complete."

# ---------- Docker Management ----------

up:
	@echo "Starting Docker containers..."
	@docker compose up -d

down:
	@echo "Stopping Docker containers..."
	@docker compose down

ps:
	@docker ps

build:
	@echo "Building Docker containers..."
	@docker compose build

setup:
	@echo "Setting up environment..."
	@$(MAKE) build
	@$(MAKE) up

# ---------- Docker Compose Generator ----------

docker-compose:
	@echo "Creating file: $(FILE_NAME)"
	@echo 'services:' > $(FILE_NAME)
	@echo "  wordpress:" >> $(FILE_NAME)
	@echo "    image: wordpress:latest" >> $(FILE_NAME)
	@echo "    container_name: $(WORDPRESS_CONTAINER)" >> $(FILE_NAME)
	@echo '    restart: always' >> $(FILE_NAME)
	@echo '    ports:' >> $(FILE_NAME)
	@echo "      - \"$(WORDPRESS_PORT):80\"" >> $(FILE_NAME)
	@echo '    environment:' >> $(FILE_NAME)
	@echo "      WORDPRESS_DB_HOST: $(MYSQL_CONTAINER):3306" >> $(FILE_NAME)
	@echo "      WORDPRESS_DB_USER: $(DB_USER)" >> $(FILE_NAME)
	@echo "      WORDPRESS_DB_PASSWORD: $(DB_PASSWORD)" >> $(FILE_NAME)
	@echo "      WORDPRESS_DB_NAME: $(DB_NAME)" >> $(FILE_NAME)
	@echo '    volumes:' >> $(FILE_NAME)
	@echo "      - $(WORDPRESS_VOLUME):/var/www/html" >> $(FILE_NAME)
	@echo '    networks:' >> $(FILE_NAME)
	@echo "      - $(NETWORK_NAME)" >> $(FILE_NAME)
	@echo '    depends_on:' >> $(FILE_NAME)
	@echo "      - mysql" >> $(FILE_NAME)
	@echo '' >> $(FILE_NAME)
	@echo "  mysql:" >> $(FILE_NAME)
	@echo '    image: mysql:8.0' >> $(FILE_NAME)
	@echo "    container_name: $(MYSQL_CONTAINER)" >> $(FILE_NAME)
	@echo '    restart: always' >> $(FILE_NAME)
	@echo '    environment:' >> $(FILE_NAME)
	@echo "      MYSQL_DATABASE: $(DB_NAME)" >> $(FILE_NAME)
	@echo "      MYSQL_USER: $(DB_USER)" >> $(FILE_NAME)
	@echo "      MYSQL_PASSWORD: $(DB_PASSWORD)" >> $(FILE_NAME)
	@echo "      MYSQL_ROOT_PASSWORD: $(DB_ROOT_PASS)" >> $(FILE_NAME)
	@echo '    volumes:' >> $(FILE_NAME)
	@echo '      - db_data:/var/lib/mysql' >> $(FILE_NAME)
	@echo '    networks:' >> $(FILE_NAME)
	@echo "      - $(NETWORK_NAME)" >> $(FILE_NAME)

# Conditional PHPMyAdmin block
	@if [ -n "$(PHPMYADMIN_PORT)" ]; then \
		echo '' >> $(FILE_NAME); \
		echo "  phpmyadmin:" >> $(FILE_NAME); \
		echo '    image: phpmyadmin/phpmyadmin' >> $(FILE_NAME); \
		echo "    container_name: $(PHPMYADMIN_CONTAINER)" >> $(FILE_NAME); \
		echo '    restart: always' >> $(FILE_NAME); \
		echo '    ports:' >> $(FILE_NAME); \
		echo "      - \"$(PHPMYADMIN_PORT):80\"" >> $(FILE_NAME); \
		echo '    environment:' >> $(FILE_NAME); \
		echo "      PMA_HOST: $(MYSQL_CONTAINER)" >> $(FILE_NAME); \
		echo "      MYSQL_ROOT_PASSWORD: $(DB_ROOT_PASS)" >> $(FILE_NAME); \
		echo '    networks:' >> $(FILE_NAME); \
		echo "      - $(NETWORK_NAME)" >> $(FILE_NAME); \
		echo '    depends_on:' >> $(FILE_NAME); \
		echo "      - mysql" >> $(FILE_NAME); \
	fi

	@echo '' >> $(FILE_NAME)
	@echo 'volumes:' >> $(FILE_NAME)
	@echo '  db_data:' >> $(FILE_NAME)
	@echo '' >> $(FILE_NAME)
	@echo 'networks:' >> $(FILE_NAME)
	@echo "  $(NETWORK_NAME):" >> $(FILE_NAME)
	@echo '    driver: bridge' >> $(FILE_NAME)
	@echo "✅ docker-compose.yml created successfully!"

gitignore:
	@echo "Creating file: $(GIT_IGNORE)"
	@echo 'tmp.md' > $(GIT_IGNORE)
	@echo '*.wpress' >> $(GIT_IGNORE)
	@echo '.idea/' >> $(GIT_IGNORE)
	@echo "✅ .gitignore created successfully!"

rush:
	@make dbbackup
	@make clean
	@git add .
	@git commit -m "rush commit with database backup"
	@git push
