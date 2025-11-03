# Alias Categories Makefile

ALIAS_DIR := config/aliases
HELP_DESC_aliases := Show aliases help
CATEGORIES := $(patsubst $(ALIAS_DIR)/%.gitconfig,%,$(wildcard $(ALIAS_DIR)/*.gitconfig))

.PHONY: install-aliases install-aliases-all install-alias-category list-aliases uninstall-alias-category help-aliases show-alias-categories

show-alias-categories:
	@echo ""
	@echo "Available Alias Categories:"
	@printf '%s\n' $(CATEGORIES) | sort | awk '{printf "%2d) %s\n", NR, $$0}'
	@echo ""

install-aliases:
	@$(MAKE) --no-print-directory show-alias-categories
	@echo "Install one or more categories by name."
	@echo "Example: navigation logging branching"
	@echo "Type 'all' to install everything, or Ctrl+C to cancel."
	@echo ""
	@read -p "Categories: " selection; \
	if [ "$$selection" = "all" ]; then \
		$(MAKE) --no-print-directory install-aliases-all; \
	else \
		for cat in $$selection; do \
			if printf '%s\n' $(CATEGORIES) | grep -Fxq "$$cat"; then \
				$(MAKE) --no-print-directory install-alias-category CATEGORY="$$cat"; \
			else \
				echo "[!] Skipping unknown category: $$cat"; \
			fi; \
		done; \
		echo ""; \
		echo "[✓] Installation complete!"; \
	fi

install-aliases-all:
	@echo "[INFO] Installing all alias categories..."
	@for category in $(CATEGORIES); do \
		$(MAKE) --no-print-directory install-alias-category CATEGORY=$$category; \
	done
	@echo ""
	@echo "[✓] All alias categories installed!"

install-alias-category:
	@if [ -z "$(CATEGORY)" ]; then \
		echo "[!] Error: Specify CATEGORY=<name>"; \
		echo "Example: make install-alias-category CATEGORY=navigation"; \
		echo ""; \
		$(MAKE) --no-print-directory show-alias-categories; \
		exit 1; \
	fi
	@config_file="$(ALIAS_DIR)/$(CATEGORY).gitconfig"; \
	if [ ! -f "$$config_file" ]; then \
		echo "[!] Config file not found: $$config_file"; \
		exit 1; \
	fi; \
	abs_path=$$(cd $(ALIAS_DIR) && pwd)/$(CATEGORY).gitconfig; \
	if git config --global --get-all include.path | grep -q "$$abs_path" 2>/dev/null; then \
		echo "[!] $(CATEGORY) already installed"; \
	else \
		git config --global --add include.path "$$abs_path"; \
		echo "[✓] $(CATEGORY) aliases installed"; \
	fi

list-aliases:
	@echo ""
	@echo "Installed Alias Categories:"
	@echo "====================================================="
	@for category in $(CATEGORIES); do \
		config_file="$(ALIAS_DIR)/$$category.gitconfig"; \
		abs_path=$$(cd $(ALIAS_DIR) 2>/dev/null && pwd)/$$category.gitconfig; \
		if git config --global --get-all include.path 2>/dev/null | grep -q "$$abs_path"; then \
			printf "✓ %-12s - installed\n" "$$category"; \
		else \
			printf "  %-12s - not installed\n" "$$category"; \
		fi; \
	done
	@echo "====================================================="
	@echo ""

uninstall-alias-category:
	@if [ -z "$(CATEGORY)" ]; then \
		echo "[!] Error: Specify CATEGORY=<name>"; \
		echo "Example: make uninstall-alias-category CATEGORY=navigation"; \
		echo ""; \
		$(MAKE) --no-print-directory show-alias-categories; \
		exit 1; \
	fi
	@abs_path=$$(cd $(ALIAS_DIR) 2>/dev/null && pwd)/$(CATEGORY).gitconfig; \
	if [ -z "$$abs_path" ]; then \
		echo "[!] Alias directory not found"; \
		exit 1; \
	fi; \
	git config --global --unset-all include.path "$$abs_path" 2>/dev/null || true; \
	echo "[✓] $(CATEGORY) aliases uninstalled"

uninstall-aliases-all:
	@echo "[INFO] Uninstalling all alias categories..."
	@for category in $(CATEGORIES); do \
		$(MAKE) --no-print-directory uninstall-alias-category CATEGORY=$$category; \
	done
	@echo ""
	@echo "[✓] All alias categories uninstalled!"

show-category-aliases:
	@if [ -z "$(CATEGORY)" ]; then \
		echo "[!] Error: Specify CATEGORY=<name>"; \
		echo "Example: make show-category-aliases CATEGORY=navigation"; \
		exit 1; \
	fi
	@config_file="$(ALIAS_DIR)/$(CATEGORY).gitconfig"; \
	if [ ! -f "$$config_file" ]; then \
		echo "[!] Config file not found: $$config_file"; \
		exit 1; \
	fi; \
	echo ""; \
	echo "Aliases in $(CATEGORY):"; \
	echo "====================================================="; \
	grep "^\s*[a-z]" "$$config_file" | grep -v "^\s*#" | sed 's/^[[:space:]]*/  /' || echo "  No aliases found"; \
	echo "====================================================="; \
	echo ""

help-aliases:
	@echo "==========================================================================="
	@echo "  Git Alias Categories"
	@echo "==========================================================================="
	@echo ""
	@echo "Installation:"
	@echo "  make install-aliases                     - Interactive selection"
	@echo "  make install-aliases-all                 - Install all categories"
	@echo "  make install-alias-category CATEGORY=<n> - Install specific"
	@echo ""
	@echo "Management:"
	@echo "  make list-aliases                        - Show installed categories"
	@echo "  make show-category-aliases CATEGORY=<n>  - Show aliases in category"
	@echo "  make uninstall-alias-category CATEGORY=<n> - Remove category"
	@echo "  make uninstall-aliases-all               - Remove all categories"
	@echo ""
	@$(MAKE) --no-print-directory show-alias-categories
	@echo "Examples:"
	@echo "  make install-alias-category CATEGORY=navigation"
	@echo "  make install-alias-category CATEGORY=logging"
	@echo "  make show-category-aliases CATEGORY=branching"
	@echo "  make uninstall-alias-category CATEGORY=advanced"
	@echo ""
