# LLM-Agnostic Agent Rules

A lightweight, LLM-agnostic rule system for guiding AI coding agents. All rules are stored as kebab-case Markdown files at the project root.

## Why This Exists

Different agents use different rule file names (`.clinerules`, `.cursorrules`, etc.). This repository provides a single, portable rule set that any agent can consume by reading the Markdown files in the root directory.

## Structure

```text
.
├── AGENTS.md          # Rule naming and format guide
├── README.md          # This file
├── LICENSE            # MIT License
└── *.md               # Individual kebab-case rule files
```

## Adding or Updating Rules

See [`AGENTS.md`](./AGENTS.md) for the full convention, rule format, and workflow.

## License

This project is licensed under the [MIT License](./LICENSE).
