# Git Environment Setup Makefile

SHELL := /bin/bash
.PHONY: help install uninstall backup restore clean install-config install-hooks install-scripts test list-backups

CONFIG_DIR := config
HOOKS_DIR := hooks
SCRIPTS_DIR := scripts
BACKUP_DIR := $(HOME)/.git-env-backup
TARGET_DIR := $(HOME)/.git-env
TARGET_BIN_DIR := $(TARGET_DIR)/bin
TARGET_CONFIG_DIR := $(TARGET_DIR)/config
TARGET_TEMPLATE_DIR := $(TARGET_DIR)/templates
ALIAS_FILE := $(HOME)/.bash_aliases
TIMESTAMP := $(shell date +%Y%m%d_%H%M%S)

help: ## Show this help message
	@echo -e "Git Environment Setup"
	@echo -e "====================="
	@echo ""
	@echo -e "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
	@echo ""

install: backup install-config install-hooks install-scripts ## Full installation of Git environment
	@echo -e "✓ Git environment setup complete!"
	@echo -e "Run 'git config --list' to verify your configuration"

backup: ## Backup current Git configuration
	@echo -e "Creating backup..."
	@mkdir -p $(BACKUP_DIR)
	@if [ -f $(HOME)/.gitconfig ]; then \
		cp $(HOME)/.gitconfig $(BACKUP_DIR)/gitconfig.$(TIMESTAMP); \
		echo -e "✓ Backed up .gitconfig to $(BACKUP_DIR)/gitconfig.$(TIMESTAMP)"; \
	fi

	@if [ -d $(TARGET_CONFIG_DIR) ]; then \
		mkdir -p $(BACKUP_DIR)/git-env.$(TIMESTAMP); \
		cp -R $(TARGET_CONFIG_DIR)/* $(BACKUP_DIR)/git-env.$(TIMESTAMP); \
		echo -e "✓ Backed up $(TARGET_CONFIG_DIR)"; \
	fi

install-config: ## Install Git configurations and aliases
	@echo -e "Installing Git configurations..."
	@if [ -f $(CONFIG_DIR)/gitconfig ]; then \
		cat $(CONFIG_DIR)/gitconfig > $(HOME)/.gitconfig; \
		echo -e "✓ Installed Git configurations"; \
	else \
		echo -e "✗ Config file not found"; \
		exit 1; \
	fi

	@mkdir -p $(TARGET_CONFIG_DIR)

	@if [ -f $(CONFIG_DIR)/gitignore_global ]; then \
		cp $(CONFIG_DIR)/gitignore_global $(TARGET_CONFIG_DIR)/gitignore_global; \
		git config --global core.excludesfile $(TARGET_CONFIG_DIR)/gitignore_global; \
		echo -e "✓ Installed global gitignore"; \
	fi
	@if [ -f $(CONFIG_DIR)/gitmessage ]; then \
		cp $(CONFIG_DIR)/gitmessage $(TARGET_CONFIG_DIR)/gitmessage; \
		git config --global commit.template $(TARGET_CONFIG_DIR)/gitmessage; \
		echo -e "✓ Installed commit message template"; \
	fi

	@if [ -f $(CONFIG_DIR)/git-aliases.conf ]; then \
		cp $(CONFIG_DIR)/git-aliases.conf $(TARGET_CONFIG_DIR)/git-aliases.conf; \
		echo -e "✓ Installed aliases"; \
	fi

install-hooks: ## Install Git hooks to ~/.git-env/templates
	@echo -e "Installing Git hooks..."
	@mkdir -p $(TARGET_TEMPLATE_DIR)/hooks
	@if [ -d $(HOOKS_DIR) ]; then \
		cp $(HOOKS_DIR)/* $(TARGET_TEMPLATE_DIR)/hooks/; \
		chmod +x $(TARGET_TEMPLATE_DIR)/hooks/*; \
		git config --global init.templatedir $(TARGET_TEMPLATE_DIR); \
		echo -e "✓ Installed Git hooks"; \
		echo -e "ℹ Run 'git init' in existing repos to apply hooks"; \
	else \
		echo -e "✗ Hooks directory not found"; \
		exit 1; \
	fi

install-scripts: ## Install helper scripts to ~/.git-env/bin
	@echo -e "Installing helper scripts..."
	@mkdir -p $(TARGET_BIN_DIR)
	@if [ -d $(SCRIPTS_DIR) ]; then \
		cp $(SCRIPTS_DIR)/* $(TARGET_BIN_DIR)/; \
		chmod +x $(TARGET_BIN_DIR)/git-*; \
		echo -e "✓ Installed helper scripts to $(TARGET_BIN_DIR)"; \
		echo -e "ℹ Generating bash aliases in $(ALIAS_FILE)..."; \
		mkdir -p $$(dirname $(ALIAS_FILE)); \
		for script in $(TARGET_BIN_DIR)/git-*; do \
			alias_name=$$(basename $$script); \
			alias_line="alias $$alias_name='$$script'"; \
			if ! grep -qxF "$$alias_line" $(ALIAS_FILE) 2>/dev/null; then \
				echo "$$alias_line" >> $(ALIAS_FILE); \
				echo "  → Added alias for $$alias_name"; \
			else \
				echo "  • Alias for $$alias_name already exists"; \
			fi; \
		done; \
		echo -e "✓ Bash aliases updated. Run 'source $(ALIAS_FILE)' to apply."; \
	else \
		echo -e "✗ Scripts directory not found"; \
		exit 1; \
	fi

uninstall: ## Remove all installed configurations
	@echo -e "Uninstalling Git environment..."
	@read -p "This will remove all installed configs and related aliases. Continue? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(TARGET_DIR)/; \
		if [ -f $(ALIAS_FILE) ]; then \
			echo -e "→ Cleaning up aliases in $(ALIAS_FILE)..."; \
			tmpfile=$$(mktemp); \
			grep -v "$(TARGET_BIN_DIR)/git-" $(ALIAS_FILE) > $$tmpfile; \
			mv $$tmpfile $(ALIAS_FILE); \
			echo -e "✓ Removed aliases linked to $(TARGET_BIN_DIR)"; \
		else \
			echo -e "ℹ No alias file found at $(ALIAS_FILE)"; \
		fi; \
		echo -e "✓ Uninstalled Git environment"; \
		echo -e "ℹ Your .gitconfig was preserved. Restore with 'make restore'"; \
	fi

restore: ## Restore backed up Git configuration
	@echo -e "Restoring from backup..."
	@if [ -d $(BACKUP_DIR) ]; then \
		LATEST=$$(ls -t $(BACKUP_DIR)/gitconfig.* 2>/dev/null | head -1); \
		if [ -n "$$LATEST" ]; then \
			cp $$LATEST $(HOME)/.gitconfig; \
			echo -e "✓ Restored .gitconfig from $$LATEST"; \
		else \
			echo -e "✗ No backup found"; \
		fi; \
	else \
		echo -e "✗ Backup directory not found"; \
	fi

clean: ## Clean temporary files
	@echo -e "Cleaning temporary files..."
	@find . -name "*.bak" -delete
	@find . -name ".DS_Store" -delete
	@echo -e "✓ Cleaned"

list-backups: ## List all available backups
	@echo -e "Available backups:"
	@if [ -d $(BACKUP_DIR) ]; then \
		ls -lh $(BACKUP_DIR)/; \
	else \
		echo -e "No backups found"; \
	fi


test: ## Run basic tests on configurations
	@echo -e "Running tests..."
	@echo -n "Checking Git version... "
	@if git --version | grep -q "git version"; then \
		echo -e "✓"; \
	else \
		echo -e "✗"; \
		exit 1; \
	fi
	@echo -n "Checking config files... "
	@if [ -f $(CONFIG_DIR)/gitconfig ] && [ -f $(CONFIG_DIR)/gitignore_global ]; then \
		echo -e "✓"; \
	else \
		echo -e "✗"; \
		exit 1; \
	fi
	@echo -n "Checking hooks... "
	@if [ -f $(HOOKS_DIR)/pre-commit ]; then \
		echo -e "✓"; \
	else \
		echo -e "✗"; \
		exit 1; \
	fi
	@echo -e "All tests passed!"

.DEFAULT_GOAL := help