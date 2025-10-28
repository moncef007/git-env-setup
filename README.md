# Git Environment Setup

A professional Git environment configuration with aliases, hooks, and developer tooling.

## Features

- **Git Aliases**: Comprehensive set of productivity-boosting aliases
- **Git Hooks**: Pre-commit, commit-msg, and pre-push hooks
- **Pretty Logging**: Enhanced git log formats
- **Best Practices**: Industry-standard Git configurations
- **Easy Installation**: One-command setup via Makefile

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> git-env-setup
cd git-env-setup

# Install everything
make install

# Or install components individually
make install-config    # Git configs and aliases
make install-hooks     # Git hooks
make install-scripts   # Helper scripts
```

## Available Make Targets

```bash
make install          # Full installation
make install-config   # Install Git configs only
make install-hooks    # Install Git hooks only
make install-scripts  # Install helper scripts only
make uninstall        # Remove all configurations
make backup           # Backup current Git config
make restore          # Restore from backup
make help             # Show all available commands
```

## Configuration Highlights

### Auto-corrections
```bash
git config --global help.autocorrect 20
```

### Better Diffs
```bash
git config --global diff.algorithm histogram
git config --global diff.colorMoved zebra
```

### Pull Strategy
```bash
git config --global pull.rebase true
```

### Modern Default Branch
```bash
git config --global init.defaultBranch main
```

## Git Hooks

### Pre-commit
- Prevents commits to protected branches
- Checks for TODO/FIXME comments
- Validates no conflict markers
- Trailing whitespace check

### Commit-msg
- Enforces conventional commits format
- Validates commit message length
- Checks for issue references

### Pre-push
- Runs tests before push
- Validates branch naming
- Checks for sensitive data

See [docs/HOOKS.md](docs/HOOKS.md) for detailed documentation.

## Requirements

- Git 2.23+ (for modern commands)
- Bash/Zsh shell
- Make (for installation)

## Customization

Edit `config/gitconfig` to customize:
- Your name and email
- Editor preferences
- Diff/merge tools
- Custom aliases

## Backup & Restore

Before installation, your existing Git config is automatically backed up:
```bash
~/.git-env-backup/gitconfig.backup.TIMESTAMP
```

To restore:
```bash
make restore
```

## Uninstallation

```bash
make uninstall
```

This removes all installed configurations and restores your original settings.

## Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for contribution guidelines.

## License

GPLv3 License.

## Support

- Full documentation in `docs/` directory
- Report issues on GitHub
- Suggestions welcome!

---

**Note**: Always review configurations before installing. These are opinionated settings that work for most developers but can be customized to your needs.