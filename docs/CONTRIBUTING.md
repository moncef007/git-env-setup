# Contributing to Git Environment Setup

Thank you for considering contributing to this project! 🎉

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Commit Guidelines](#commit-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Review Process](#review-process)

## Code of Conduct

### Our Pledge

We are committed to making participation in this project a harassment-free experience for everyone, regardless of level of experience, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, religion, or nationality.

### Our Standards

**Examples of behavior that contributes to a positive environment:**

- Using welcoming and inclusive language
- Being respectful of differing viewpoints and experiences
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Examples of unacceptable behavior:**

- The use of sexualized language or imagery
- Trolling, insulting/derogatory comments, and personal or political attacks
- Public or private harassment
- Publishing others' private information without explicit permission
- Other conduct which could reasonably be considered inappropriate

## Getting Started

### Prerequisites

- Git 2.23 or higher
- Bash/Zsh shell
- Make
- Basic understanding of Git hooks and shell scripting

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/git-env-setup.git
   cd git-env-setup
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/moncef007/git-env-setup.git
   ```

## Development Setup

### Initial Setup

```bash
# Install development dependencies (if any)
make install

# Run tests to ensure everything works
make test
```

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title**: Descriptive and specific
- **Description**: Detailed explanation of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What you expected to happen
- **Actual behavior**: What actually happened
- **Environment**: OS, Git version, shell
- **Screenshots**: If applicable


### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When suggesting an enhancement:

- **Use a clear title**
- **Provide detailed description** of the suggested enhancement
- **Explain why** this enhancement would be useful
- **Provide examples** of how it would be used
- **List alternatives** you've considered

### Pull Requests

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/amazing-feature
   ```

2. **Make your changes:**
   - Follow the coding standards
   - Add tests if applicable
   - Update documentation

3. **Commit your changes:**
   ```bash
   git commit -m "feat: add amazing feature"
   ```
   See [Commit Guidelines](#commit-guidelines) below.

4. **Push to your fork:**
   ```bash
   git push origin feature/amazing-feature
   ```

5. **Open a Pull Request:**
   - Provide a clear title and description
   - Reference any related issues
   - Ensure all checks pass

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Revert previous commit

### Scope

The scope should be the area affected:
- `config`: Git configuration files
- `hooks`: Git hooks
- `scripts`: Helper scripts
- `docs`: Documentation
- `build`: Build system (Makefile)

### Examples

```bash
feat(hooks): add syntax validation to pre-commit
fix(scripts): resolve git-cleanup error on Windows
docs(aliases): add examples for rebase workflow
refactor(config): consolidate color configurations
test(hooks): add unit tests for commit-msg validation
```

### Rules

1. **Subject line:**
   - Use imperative mood: "add" not "added"
   - Don't capitalize first letter
   - No period at the end
   - Maximum 72 characters

2. **Body:**
   - Wrap at 100 characters
   - Explain what and why, not how
   - Use bullet points for multiple changes

3. **Footer:**
   - Reference issues: `Fixes #123`
   - Note breaking changes: `BREAKING CHANGE: ...`

### Complete Example

```
feat(hooks): add branch name validation to pre-push

- Validate branch naming convention (type/description)
- Support multiple branch types (feature, bugfix, hotfix)
- Add bypass option with user confirmation
- Include helpful error messages with examples

This prevents poorly named branches from being pushed
and maintains consistency across the team.

Closes #45
Refs #38
```

## Testing

### Running Tests

```bash
# Run all tests
make test

# Test individual components
bash -n hooks/pre-commit        # Syntax check
shellcheck hooks/pre-commit     # Linting
```

### Adding Tests

When adding new features:

1. **Add syntax validation** to `make test`
2. **Test edge cases** manually
3. **Document test scenarios** in PR description

### Manual Testing Checklist

For hooks:
- [ ] Test with valid scenarios
- [ ] Test with invalid scenarios
- [ ] Test bypass functionality
- [ ] Test on multiple OS (macOS, Linux, Windows)
- [ ] Test error messages are clear

For scripts:
- [ ] Test with various inputs
- [ ] Test error handling
- [ ] Test help output
- [ ] Verify no side effects

For config:
- [ ] Test aliases work as expected
- [ ] Verify no conflicts with common aliases
- [ ] Test on fresh Git installation

## Documentation

### Documentation Standards

- **Clear and concise**: Easy to understand
- **Examples**: Show, don't just tell
- **Up-to-date**: Update docs with code changes
- **Well-organized**: Logical structure

### What to Document

When adding features, update:

1. **README.md**: If it affects installation or usage
2. **Specific docs**: HOOKS.md, etc.
3. **Inline comments**: Complex code sections
4. **Commit messages**: Comprehensive explanations


### Best Practices

1. **Error handling**: Always check return codes
2. **User feedback**: Provide clear messages
3. **Colors**: Use consistently (red=error, yellow=warning, green=success)
4. **Compatibility**: Test on Bash 4+ and Zsh
5. **Documentation**: Comment non-obvious code

## Getting Help

- **Documentation**: Check docs/ directory
- **Issues**: Search existing issues
- **Discussions**: GitHub Discussions
- **Questions**: Open an issue with "question" label

## Recognition

Contributors are recognized in:
- Repository contributors list
- Release notes
- Special mentions for significant contributions

## License

By contributing, you agree that your contributions will be licensed under the GPLv3 License.

---

**Thank you for contributing!** Every contribution, no matter how small, makes this project better. 🙏