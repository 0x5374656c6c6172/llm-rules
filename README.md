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

## Using the Rules in Another Project

The rule files are plain Markdown and can be consumed by any agent that reads project-level rules. The methods below use a git submodule so updates flow in from this repository; both target Cline, which loads every `.md` file in a `.clinerules/` directory at the workspace root as a rule.

### Symlinks

Vendor the repository in a neutral location, then link only the rule files you want into `.clinerules/`. This keeps the repo's non-rule files (`AGENTS.md`, `README.md`) out of Cline's view, and leaves `.clinerules/` owned by your project so your own rules can live alongside the vendored ones.

1. Add the submodule:

   ```sh
   git submodule add https://github.com/0x5374656c6c6172/llm-rules.git .llm-rules
   git commit -m "chore: add llm-rules submodule"
   ```

2. Link the rules you want into `.clinerules/`:

   ```sh
   mkdir -p .clinerules
   ln -s ../.llm-rules/conventional-commits.md .clinerules/conventional-commits.md
   ln -s ../.llm-rules/open-remote-after-push.md .clinerules/open-remote-after-push.md
   git add .clinerules
   git commit -m "chore: enable llm-rules in .clinerules"
   ```

3. Update later by advancing the submodule (links pick up new content; link any newly added rules you want to adopt):

   ```sh
   git submodule update --remote .llm-rules
   git add .llm-rules
   git commit -m "chore: update llm-rules submodule"
   ```

Symlinks need a POSIX shell, or Windows with Developer Mode/admin and `git config core.symlinks true`. Where symlinks are unavailable, copy the files instead (`cp .llm-rules/<rule>.md .clinerules/`) and re-copy after each submodule update.

### Sparse-checkout

Place the submodule directly at `.clinerules/` and restrict its working tree to only the rule files with a non-cone sparse-checkout. This avoids symlinks (useful on Windows without symlink support), but because a submodule path is owned by the submodule, you cannot keep your own project rules in `.clinerules/` alongside it — use this when you want the vendored rules alone.

1. Add the submodule at `.clinerules/`:

   ```sh
   git submodule add https://github.com/0x5374656c6c6172/llm-rules.git .clinerules
   git commit -m "chore: add llm-rules submodule at .clinerules"
   ```

2. Restrict the working tree to the rule files (non-cone mode takes an explicit, slash-anchored file list):

   ```sh
   git -C .clinerules sparse-checkout set --no-cone /conventional-commits.md /open-remote-after-push.md
   ```

   This step configures the submodule's working tree only and records nothing in your repository — there is nothing to commit here.

3. Update later by advancing the submodule; the sparse set persists in this working tree:

   ```sh
   git submodule update --remote .clinerules
   git add .clinerules
   git commit -m "chore: update llm-rules submodule"
   ```

The sparse-checkout config lives in the submodule's `$GIT_DIR/info/sparse-checkout` and is not versioned, so after a fresh `git clone --recurse-submodules` a teammate must re-run step 2. To make it reproducible, commit the file list (for example in a setup script) and document the re-apply command. To adopt a new upstream rule, run `git -C .clinerules sparse-checkout add /<rule>.md`.

## License

This project is licensed under the [MIT License](./LICENSE).
