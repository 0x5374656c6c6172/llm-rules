# No Hardcoded Secrets

## Scope

Applies to all source code, configuration files, and documentation committed to a version-controlled repository.

## Statement

Never embed secrets, credentials, API keys, tokens, passwords, or private connection strings directly in source code or committed files. Use environment variables, secret managers, or encrypted configuration files that are excluded from version control.

If a secret is accidentally committed, rotate the compromised credential immediately and remove it from the repository history (e.g., using `git filter-repo` or a similar tool) before pushing.

## Rationale

Hardcoded secrets are one of the most common causes of security breaches. Once committed, a secret is exposed to anyone with repository access — including forks, clones, and CI logs. Even removing the secret in a later commit does not fully protect against exposure, because the value remains in the git history. Keeping secrets out of version control eliminates this attack surface entirely.

## Examples

### Do

```typescript
const apiKey = process.env.API_KEY;
const dbUrl = process.env.DATABASE_URL;
```

```python
import os

api_key = os.environ["API_KEY"]
db_url = os.environ["DATABASE_URL"]
```

### Don't

```typescript
const apiKey = "sk-abc123def456ghi789";
const dbUrl = "postgres://admin:password123@db.example.com/myapp";
```

```python
API_KEY = "sk-abc123def456ghi789"
DATABASE_URL = "postgres://admin:password123@db.example.com/myapp"
```

## Exceptions

- A project uses a deliberate pattern of checked-in placeholder values that are clearly marked as non-functional (e.g., `YOUR_API_KEY_HERE` in a `.env.example` file) and contain no real credentials.
- The repository is a public example or tutorial where all values are fictional and do not correspond to real services.
