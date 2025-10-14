# Git Hooks Documentation

Complete guide to all Git hooks included in this setup.

## Overview

Git hooks are scripts that run automatically at specific points in the Git workflow. They help enforce standards, run tests, and prevent common mistakes.

## Installation

Hooks are automatically installed to `~/.git-env/templates/hooks/` during setup:

```bash
make install-hooks
```

For existing repositories, apply hooks by running:
```bash
git init
```

## Available Hooks

### Pre-Commit Hook

**When it runs**: Before each commit is created

**Purpose**: Validates code quality and prevents common mistakes

#### Checks Performed

1. **Protected Branch Check**
   - Prevents direct commits to `main`, `master`, `production`, or `release/*`
   - Forces use of feature branches
   ```bash
   ✗ Direct commits to 'master' are not allowed!
   Create a feature branch instead:
   git checkout -b feature/your-feature-name
   ```

2. **Conflict Markers**
   - Detects unresolved merge conflict markers
   - Looks for: `<<<<<<<`, `=======`, `>>>>>>>`
   ```bash
   ✗ Conflict markers found in:
   src/file.c
   ```

3. **TODO/FIXME Comments**
   - Warns when adding TODO or FIXME comments
   - Allows bypass with user confirmation
   ```bash
   ⚠ Warning: Adding 3 TODO/FIXME comment(s)
   Continue anyway? [y/N]
   ```

4. **Trailing Whitespace**
   - Detects trailing spaces at end of lines
   - Provides fix command
   ```bash
   ✗ Trailing whitespace found
   Fix with: git diff --cached | sed 's/[ \t]*$//' | git apply --cached
   ```

5. **Large Files**
   - Detects files larger than 5MB
   - Suggests Git LFS usage
   ```bash
   ✗ Large file detected: video.mp4 (8192KB)
   Consider using Git LFS for files >5MB
   ```

6. **Sensitive Data**
   - Scans for potential secrets, API keys, passwords
   - Patterns checked:
     - `password = "..."`
     - `api_key = "..."`
     - `secret = "..."`
     - `token = "..."`
     - AWS credentials
     - Private keys
   ```bash
   ✗ Potential sensitive data found:
   + const apiKey = "sk_live_123456789"
   Remove sensitive data before committing!
   ```

7. **Debug Statements**
   - Warns about `console.log`, `debugger`, `print()`, etc.
   - Allows bypass with confirmation
   ```bash
   ⚠ Warning: Debug statements found
   + console.log("Debug info");
   Continue anyway? [y/N]
   ```

#### Bypassing Pre-Commit

In emergencies, skip with:
```bash
git commit --no-verify
```

**⚠️ Use sparingly!** Hooks exist for good reasons.

---

### Commit-Msg Hook

**When it runs**: After commit message is written, before commit is created

**Purpose**: Enforces Conventional Commits format

#### Message Format

Required format:
```
type(scope): subject

body (optional)

footer (optional)
```

#### Valid Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, no logic change)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Revert previous commit

#### Checks Performed

1. **Format Validation**
   ```bash
   ✗ Invalid commit message format!
   
   Commit message should follow Conventional Commits:
   type(scope): subject
   
   Examples:
   feat(auth): add login functionality
   fix(api): resolve connection timeout
   ```

2. **Subject Length**
   - Maximum 72 characters
   ```bash
   ✗ Subject line too long (85 > 72 characters)
   ```

3. **Imperative Mood**
   - Warns if using past tense
   ```bash
   ⚠ Warning: Use imperative mood (add, fix) not past tense
   Instead of: 'added feature' use 'add feature'
   ```

4. **Capitalization**
   - Subject should start with lowercase
   ```bash
   ⚠ Warning: Subject should start with lowercase
   ```

5. **No Period**
   - Subject should not end with period
   ```bash
   ⚠ Warning: Subject should not end with period
   ```

6. **Body Formatting**
   - Blank line between subject and body required
   - Body lines wrapped at 100 characters

#### Examples

✅ **Good Messages**
```
feat(auth): add JWT token validation
fix(api): resolve timeout on slow connections
docs: update installation instructions
refactor(db): optimize query performance
```

❌ **Bad Messages**
```
Fixed bug                    # No type
feat: Added new feature.     # Past tense, period, capitalized
update files                 # No type
feat(toolongscope): this is a very long subject line that exceeds the maximum allowed length
```

#### Special Cases

**WIP Commits**: Automatically allowed
```bash
WIP
```

**Merge Commits**: Automatically allowed
```bash
Merge branch 'feature/new-feature'
```

---

### Pre-Push Hook

**When it runs**: Before pushing to remote

**Purpose**: Final validation before code reaches remote repository

#### Checks Performed

1. **Protected Branch Push**
   - Prevents direct push to protected branches
   ```bash
   ✗ Direct push to 'master' is not allowed!
   Use pull requests/merge requests instead
   ```

2. **Branch Naming Convention**
   - Validates branch names follow pattern: `type/description`
   - Valid types: `feature`, `bugfix`, `hotfix`, `release`, `docs`, `refactor`, `test`, `chore`
   ```bash
   ⚠ Warning: Branch name doesn't follow naming convention
   Expected: type/description (e.g., feature/new-login)
   ```

3. **Up-to-Date Check**
   - Ensures local branch is up-to-date with remote
   ```bash
   ✗ Your branch is behind the remote
   Pull latest changes: git pull --rebase
   ```

4. **Run Tests**
   - Automatically detects and runs tests
   - Supports: npm, pytest, make test
   ```bash
   Running tests...
   ✓ Tests passed
   ```

5. **Large Files in History**
   - Warns about large files in commit history
   ```bash
   ⚠ Warning: Large files detected:
   video.mp4 (8.5MB)
   Consider using Git LFS
   ```

6. **Force Push Detection**
   - Warns before force pushing
   ```bash
   ⚠ This appears to be a force push!
   Force pushing rewrites history
   Are you sure? [y/N]
   ```

7. **Debug Statements**
   - Final check for debug code
   ```bash
   ⚠ Warning: 2 debug statement(s) found
   Continue anyway? [y/N]
   ```

#### Test Detection

The hook automatically detects test commands:

- **Node.js**: Looks for `"test"` script in `package.json`
- **Python**: Detects `pytest.ini` or `setup.py`
- **Make**: Looks for `test:` target in `Makefile`

#### Bypassing Pre-Push

Skip in emergencies:
```bash
git push --no-verify
```

---

## Hook Management

### Disable a Hook

Temporarily disable:
```bash
chmod -x ~/.git-env/templates/hooks/pre-commit
```

Re-enable:
```bash
chmod +x ~/.git-env/templates/hooks/pre-commit
```

### Customize Hooks

Edit hooks in your repository:
```bash
vim .git/hooks/pre-commit
```

Or globally:
```bash
vim ~/.git-env/templates/hooks/pre-commit
```

### Skip Hooks Temporarily

For a single commit:
```bash
git commit --no-verify
git push --no-verify
```

### Check Hook Status

See which hooks are active:
```bash
ls -la .git/hooks/
```

## Best Practices

1. **Don't Skip Hooks**: They exist to protect code quality
2. **Fix Issues, Don't Bypass**: If a hook fails, fix the underlying issue
3. **Customize for Your Team**: Adjust protected branches and rules
4. **Keep Hooks Fast**: Slow hooks disrupt workflow
5. **Document Bypasses**: If you must bypass, document why

## Troubleshooting

### Hook Not Running

1. Check if hook is executable:
   ```bash
   ls -la .git/hooks/pre-commit
   ```

2. Make executable:
   ```bash
   chmod +x .git/hooks/pre-commit
   ```

3. Verify hook exists:
   ```bash
   cat .git/hooks/pre-commit
   ```

### Hook Failing Incorrectly

1. Run hook manually to debug:
   ```bash
   .git/hooks/pre-commit
   ```

2. Check hook output for specific error

3. Temporarily disable to isolate issue:
   ```bash
   git commit --no-verify
   ```

### Update Hooks

After modifying hooks in `~/.git-env/templates/`:
```bash
# In each repository
git init
```

## Advanced Configuration

### Per-Repository Hooks

Create repository-specific hooks in `.git/hooks/`:
```bash
cp ~/.git-env/templates/hooks/pre-commit .git/hooks/
vim .git/hooks/pre-commit
```

### Shared Hooks

Store hooks in repository for team sharing:
```bash
mkdir .githooks
cp ~/.git-env/templates/hooks/* .githooks/
git config core.hooksPath .githooks
```

### Hook Chaining

Run multiple hooks:
```bash
#!/bin/bash
# .git/hooks/pre-commit

.git/hooks/pre-commit.d/check-style.sh
.git/hooks/pre-commit.d/run-linter.sh
.git/hooks/pre-commit.d/run-tests.sh
```

## See Also

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [ALIASES.md](ALIASES.md) - Git alias documentation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contributing guidelines