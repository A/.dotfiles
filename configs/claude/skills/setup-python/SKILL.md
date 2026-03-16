---
name: setup-python
description: Set up a new Python/Django project with uv, ruff, basedpyright, pre-commit hooks, Justfile, Docker Compose, and CI. Invoke when starting a new Python project or when asked to set up project tooling.
---

# Python Project Setup

## Step 1: Confirm with the user BEFORE writing any files

Present this summary and ask the user to confirm or adjust:

```
I'll set up the project with the default Python toolchain:

- **uv** — package manager (pyproject.toml + uv.lock)
- **ruff** — linter + formatter (120 char lines, modern Python rules)
- **basedpyright** — type checker (Django-tuned suppressions)
- **pre-commit hooks** — local git hooks running ruff + basedpyright via Justfile
- **Justfile** — task runner (dev, prod, test, migrate, lint, fmt, celery, etc.)
- **Docker Compose** — dev environment (api, db, redis, worker/beat)
- **CI** — GitHub Actions (lint + typecheck + tests)
- **README.md** — setup instructions and service ports
- **CLAUDE.md** — Claude Code operating instructions

Want me to proceed with these defaults, or would you like to change anything?
(e.g., different services, no Celery, different Python version, etc.)
```

Wait for user confirmation. Adapt the setup based on any changes they request.

## Step 2: Generate files

After confirmation, generate all files below. Adapt names, paths, ports, and dependencies
to the user's project.

### 1. pyproject.toml

Standard `[project]` table with uv-style dependency management:

```toml
[project]
name = "<project-name>"
version = "0.1.0"
requires-python = ">=3.12, <4.0"

dependencies = [
    # User's dependencies go here
]

[dependency-groups]
dev = [
    "basedpyright>=1.29.0",
    "ruff>=0.14.0",
    "pytest>=8.3",
    "pytest-django>=4.9",
    # Type stubs as needed:
    # "django-stubs>=5.0",
    # "djangorestframework-stubs>=3.15",
    # "celery-types>=0.22",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 120
extend-exclude = ["migrations"]

[tool.ruff.lint]
extend-select = ["PLC0415", "UP006", "UP007"]

[tool.pyright]
stubPath = "stubs"
venvPath = "."
venv = ".venv"
extraPaths = ["."]
exclude = ["**/migrations"]
reportExplicitAny = "none"
reportAny = "none"
reportImplicitOverride = "none"
reportIgnoreCommentWithoutRule = "none"
reportUnknownVariableType = "none"
reportUnannotatedClassAttribute = "none"
reportIncompatibleMethodOverride = "none"
reportIncompatibleVariableOverride = "none"
reportMissingTypeArgument = "none"
reportUnknownMemberType = "none"
reportUninitializedInstanceVariable = "none"
reportImplicitStringConcatenation = "none"
reportUnusedImport = "none"
reportUnusedCallResult = "none"
reportUnknownArgumentType = "none"
reportUnknownParameterType = "none"
```

### 2. Justfile

Must contain these command categories. Adapt Django app name, directories, etc. to the project:

```just
set dotenv-load

# --- Server ---

dev:
    uv run python manage.py collectstatic --noinput
    uv run python -Wd manage.py runserver 0.0.0.0:8000

start-prod:
    uv run python manage.py collectstatic --noinput
    uv run python manage.py migrate
    uv run gunicorn --bind 0.0.0.0:8000 --timeout=600 --workers=3 config.wsgi

# --- Database ---

migrate *args:
    uv run python manage.py migrate {{args}}

makemigrations *args:
    uv run python manage.py makemigrations {{args}}

# --- Testing ---

test *args:
    uv run pytest {{args}}

# --- Code Quality (used by pre-commit hook and CI) ---

pre-commit:
    uv run ruff check .
    uv run ruff format --check .
    uv run basedpyright <src-directories>/

fmt:
    uv run ruff format .
    uv run ruff check --fix .

# --- Dependencies ---

install:
    uv sync --all-groups

add *args:
    uv add {{args}}

add-dev *args:
    uv add --group dev {{args}}

# --- Celery (if applicable) ---

celery-worker:
    uv run celery -A config worker --loglevel=info

celery-beat:
    uv run celery -A config beat --loglevel=info

# --- Utilities ---

shell:
    uv run python manage.py shell

createsuperuser:
    uv run python manage.py createsuperuser
```

### 3. .pre-commit-config.yaml

Pre-commit hooks are local. They call `just pre-commit` so all tool invocations live in one place:

```yaml
repos:
  - repo: local
    hooks:
      - id: lint
        name: ruff lint + format + basedpyright
        entry: just pre-commit
        language: system
        types: [python]
        pass_filenames: false
```

### 4. Docker Setup

Three Dockerfiles in `docker/{dev,staging,production}/Dockerfile`.

All Dockerfiles share a common base:
- `python:3.12-slim` base image
- Pin uv version via `ARG UV_VERSION=0.9.8`, install with `pip install --no-cache-dir`
- Install `just` and set up bash completions for just:
  ```dockerfile
  RUN apt update && apt install bash-completion just
  RUN echo 'source /usr/share/bash-completion/bash_completion' >> ~/.bashrc && \
      just --completions bash > /etc/bash_completion.d/just-completion.bash
  ```
- Set `UV_CACHE_DIR=/.uv/cache` and `UV_PROJECT_ENVIRONMENT=/.uv/.env` to avoid permission issues with mounted volumes

How they differ:
- **dev** — ends with `WORKDIR /app`. Source code is volume-mounted, deps install at container start.
- **staging / production** — adds `COPY . /app` then `WORKDIR /app`. Source is baked into the image (immutable).

#### docker-compose.yml

Principles:
- Dev: source code volume-mounted, `uv sync --all-groups` at container start
- All services share a `uv_cache` volume at `/.uv`
- External network for cross-project communication
- Environment vars have defaults (`${VAR:-default}`)
- Worker/beat reuse same Dockerfile, only command differs

```yaml
services:
  api:
    build: { context: ., dockerfile: docker/dev/Dockerfile }
    command: bash -c "uv sync --all-groups && just dev"
    volumes: [.:/app, uv_cache:/.uv]
    ports: ["<port>:8000"]
    depends_on: [db, redis]

  db:
    image: postgres:16-alpine
    volumes: [postgres_data:/var/lib/postgresql/data/]

  redis:
    image: redis:7-alpine
    volumes: [redis_data:/data]

  # Add worker, beat, etc. as needed — same Dockerfile, different command

volumes:
  postgres_data:
  redis_data:
  uv_cache:
```

### 5. CI — .github/workflows/checks.yaml

```yaml
name: Checks
on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
        with:
          python-version: "3.12"
      - run: uv sync --all-groups
      - run: uv run ruff check .
      - run: uv run ruff format --check .
      - run: uv run basedpyright <src-directories>/

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v6
        with:
          python-version: "3.12"
      - run: uv sync --all-groups
      - run: uv run pytest
```

### 6. README.md

Brief project overview, setup instructions, and service table:

```markdown
# <Project Name>

<One-line description.>

Docker Compose is strictly recommended for development.

## Setup

Create the shared Docker network (required once):

\```bash
docker network create <project>-network
\```

## Services

| Service    | Host Port | Description          |
|------------|-----------|----------------------|
| API        | <port>    | Django REST API      |
| PostgreSQL | <port>    | Database             |
| Redis      | <port>    | Celery broker/cache  |

## Development

Start services:

\```bash
docker compose up -d
\```

All commands run inside the container:

\```bash
docker compose exec api just install       # Install dependencies
docker compose exec api just dev           # Run server (dev mode)
docker compose exec api just migrate       # Run migrations
docker compose exec api just test          # Run tests
docker compose exec api just fmt           # Format code
\```
```

### 7. CLAUDE.md

Operating instructions for Claude Code. Must cover: how to run commands, available just commands,
architecture overview (fill in once project structure exists), code conventions, env vars.

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Build & Development Commands

All commands run inside Docker. Never run Python, uv, or just directly on the host.

\```bash
docker compose exec api just install          # Install dependencies
docker compose exec api just dev              # Run dev server
docker compose exec api just test             # Run all tests
docker compose exec api just test path/to/test_file.py  # Run specific test
docker compose exec api just test -k "test_name"        # Run test by name
docker compose exec api just migrate          # Apply migrations
docker compose exec api just makemigrations   # Create migrations
docker compose exec api just start-prod       # Production server (gunicorn)
\```

Linting: `docker compose exec api just pre-commit`
Formatting: `docker compose exec api just fmt`

## Architecture Overview

<Describe the project's purpose and structure here>

## Code Conventions

- **Python 3.12+** — Use `str | None` (not `Optional`), modern syntax
- **Type hints** on all function signatures
- **Imports** — Absolute imports, grouped: stdlib > third-party > local
- **Ruff** line-length: 120
- **Logging** via `logging.getLogger(__name__)` — never `print()`

## Environment Variables

Required in `.env`:

\```
POSTGRES_DB=<project>
POSTGRES_USER=<user>
POSTGRES_PASSWORD=<password>
\```

## Pull Request Guidelines

- Keep PRs concise with only a summary section
```

## Step 3: Post-setup message

After all files are generated, tell the user what manual steps remain:

```
Setup complete. To get started:

1. Create the Docker network: `docker network create <project>-network`
2. Start services: `docker compose up -d`
3. Install pre-commit hooks: `pre-commit install`
```
