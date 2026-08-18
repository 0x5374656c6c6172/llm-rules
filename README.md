# LLM-Agnostic Agent Rules

A lightweight, LLM-agnostic rule system for guiding AI coding agents. All rules are stored as kebab-case Markdown files in the `rules/` directory.

## Why This Exists

Different agents use different rule file names (`.clinerules`, `.cursorrules`, etc.). This repository provides a single, portable rule set that any agent can consume by reading the Markdown files in the `rules/` directory.

## Structure

```text
.
├── AGENTS.md          # Rule naming and format guide
├── README.md          # This file
├── LICENSE            # MIT License
└── rules/             # Individual kebab-case rule files
    ├── branch-naming.md
    ├── conventional-commits.md
    └── ...
```

## Available Rules

A reference of all rules available in the `rules/` directory. Each rule's base name (the `.md` filename without the extension) can be used when symlinking, sparse-checkout, or referencing a specific rule.

| Rule | Base Name | Statement |
|------|-----------|-----------|
| [Branch Naming](./rules/branch-naming.md) | `branch-naming` | Name branches using `<type>/<short-description>` with typed prefixes. |
| [Conventional Commits](./rules/conventional-commits.md) | `conventional-commits` | Write all commit messages using the Conventional Commits format. |
| [Incremental Changes](./rules/incremental-changes.md) | `incremental-changes` | Break work into small, focused steps; verify each before moving on. |
| [Keep README Current](./rules/keep-readme-current.md) | `keep-readme-current` | Update the README in the same commit when a change affects documented information. |
| [Logical Commits](./rules/logical-commits.md) | `logical-commits` | Each commit should represent a single logical unit of work. |
| [No Automatic Commits](./rules/no-automatic-commits.md) | `no-automatic-commits` | Do not create Git commits unless the user has explicitly requested one. |
| [No Force Push](./rules/no-force-push.md) | `no-force-push` | Do not force-push to shared branches without explicit user approval. |
| [No Hardcoded Secrets](./rules/no-hardcoded-secrets.md) | `no-hardcoded-secrets` | Never embed secrets or credentials directly in source code or committed files. |
| [Open Remote After Push](./rules/open-remote-after-push.md) | `open-remote-after-push` | After every successful push, open the remote's web page in the browser. |
| [Run Tests Before Commit](./rules/run-tests-before-commit.md) | `run-tests-before-commit` | Run the project's test suite before committing. |
| [Stay Within Scope](./rules/stay-within-scope.md) | `stay-within-scope` | Execute exactly what was requested; do not expand scope without asking. |

## Adding or Updating Rules

See [`AGENTS.md`](./AGENTS.md) for the full convention, rule format, and workflow.

## Using the Rules in Another Project

The rule files are plain Markdown and can be consumed by any agent that reads project-level rules. The methods below use a git submodule so updates flow in from this repository. The examples target Cline (`.clinerules/`); adapt the target directory for your tool (e.g. `.cursor/rules/` for Cursor).

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
   ln -s ../.llm-rules/rules/conventional-commits.md .clinerules/conventional-commits.md
   ln -s ../.llm-rules/rules/open-remote-after-push.md .clinerules/open-remote-after-push.md
   git add .clinerules
   git commit -m "chore: enable llm-rules in .clinerules"
   ```

3. Update later by advancing the submodule (links pick up new content; link any newly added rules you want to adopt):

   ```sh
   git submodule update --remote .llm-rules
   git add .llm-rules
   git commit -m "chore: update llm-rules submodule"
   ```

Symlinks need a POSIX shell, or Windows with Developer Mode/admin and `git config core.symlinks true`. Where symlinks are unavailable, copy the files instead (`cp .llm-rules/rules/<rule>.md .clinerules/`) and re-copy after each submodule update.

### Sparse-checkout

Place the submodule directly at `.clinerules/` and restrict its working tree to only the rule files with a non-cone sparse-checkout. This avoids symlinks (useful on Windows without symlink support), but because a submodule path is owned by the submodule, you cannot keep your own project rules in `.clinerules/` alongside it — use this when you want the vendored rules alone.

1. Add the submodule at `.clinerules/`:

   ```sh
   git submodule add https://github.com/0x5374656c6c6172/llm-rules.git .clinerules
   git commit -m "chore: add llm-rules submodule at .clinerules"
   ```

2. Restrict the working tree to the rule files (non-cone mode takes an explicit, slash-anchored file list):

   ```sh
   git -C .clinerules sparse-checkout set --no-cone /rules/conventional-commits.md /rules/open-remote-after-push.md
   ```

   This step configures the submodule's working tree only and records nothing in your repository — there is nothing to commit here.

3. Update later by advancing the submodule; the sparse set persists in this working tree:

   ```sh
   git submodule update --remote .clinerules
   git add .clinerules
   git commit -m "chore: update llm-rules submodule"
   ```

The sparse-checkout config lives in the submodule's `$GIT_DIR/info/sparse-checkout` and is not versioned, so after a fresh `git clone --recurse-submodules` a teammate must re-run step 2. To make it reproducible, commit the file list (for example in a setup script) and document the re-apply command. To adopt a new upstream rule, run `git -C .clinerules sparse-checkout add /rules/<rule>.md`.

### Nix flake

For projects that use Nix, consume the rules as a versioned flake input and pick rules by name. The upstream exposes a `rules` catalog (name → file), a `lib.materializeRules` helper (flat and nested modes), and a `lib.lintRules` validator; commit the generated `.clinerules/*.generated.md` so a plain `git clone` works without Nix.

1. Add the input to your `flake.nix`:

   ```nix
   inputs.llm-rules.url = "github:0x5374656c6c6172/llm-rules";
   ```

2. Declare your selection (`nix/llm-rules.nix`) — level path → ordered rule set:

   ```nix
   {
     "." = {
       "10-conventional-commits"   = "conventional-commits";
       "20-open-remote-after-push" = "open-remote-after-push";
     };
   }
   ```

3. Materialize the selection and expose a sync app:

   The provider is agent-agnostic: the consumer names the derivation (`name`)
   and decides which workspace directory the rules land in (`.clinerules/` for
   Cline, `.cursor/rules/` for Cursor, and so on). The example below is wired
   for Cline.

   ```nix
   # Walk up from $PWD to the enclosing git repo root (coreutils only).
   findRepoRoot = ''
     root="$PWD"
     while [ "$root" != "/" ] && [ ! -e "$root/.git" ]; do root="$(dirname "$root")"; done
     [ -e "$root/.git" ] || { echo "must run inside the git repo" >&2; exit 1; }
   '';

   packages.${system}.clinerules =
     llm-rules.lib.materializeRules pkgs {
       levels = import ./nix/llm-rules.nix;
       name = "clinerules";
     };

   apps.${system}.sync-rules =
     let clinerules = self.packages.${system}.clinerules; in {
       type = "app";
       program = pkgs.writeShellApplication {
         name = "sync-rules";
         runtimeInputs = [ pkgs.findutils pkgs.coreutils ];
         text = ''
           set -euo pipefail
           ${findRepoRoot}
           target="$root/.clinerules"
           mkdir -p "$target"
           find "$target" -name '*.generated.md' -delete
           copy_tree() {
             local src="$1" dest_base="$2"
             for item in "$src"/*; do
               [ -e "$item" ] || continue
               local bn="$(basename "$item")"
               if [ -d "$item" ]; then
                 copy_tree "$item" "$dest_base/$bn"
               elif [ -f "$item" ]; then
                 mkdir -p "$dest_base/.clinerules"
                 cp "$item" "$dest_base/.clinerules/"
               fi
             done
           }
           copy_tree "${clinerules}" "$root"
           echo "Cline rules synchronized."
         '';
       };
     };
   ```

4. Generate and commit the rules:

   ```sh
   nix run .#sync-rules
   git add .clinerules
   git commit -m "chore: sync llm-rules"
   ```

5. Update later by bumping the input and re-syncing:

   ```sh
   nix flake update llm-rules
   nix run .#sync-rules
   git commit -am "chore: update llm-rules"
   ```

By default, rules land as `<prefix>.generated.md` (set `sentinel` to change the managed marker). That default suffix is the managed sentinel — `sync-rules` only touches `*.generated.md`, so your own `.clinerules/*.md` rules are never clobbered. Unknown rule names fail at evaluation time, so typos surface immediately. Each generated file is prefixed with a provenance header (`<!-- generated by llm-rules @<rev> — do not edit -->`) so the source revision is always visible.

#### Nested rules

For projects that need different rules at different directory levels (e.g., general rules at root, domain-specific rules in subdirectories), add more keys to the selection. Each level maps a relative path to an ordered rule set. The derivation output mirrors the level structure: root-level files sit at the top, subdirectories contain their level's rules. Empty levels are skipped.

Declare your nested selection (`nix/llm-rules.nix`):

```nix
{
  "." = {
    "10-conventional-commits"   = "conventional-commits";
    "20-open-remote-after-push" = "open-remote-after-push";
  };
  "backend" = {
    "30-run-tests-before-commit" = "run-tests-before-commit";
  };
  "backend/api" = {
    "40-error-handling" = "error-handling";
  };
}
```

Materialize with `levels` and write a tree-walking sync app:

```nix
packages.${system}.clinerules =
  llm-rules.lib.materializeRules pkgs {
    levels = import ./nix/llm-rules.nix;
    name = "clinerules";
  };

apps.${system}.sync-rules =
  let clinerules = self.packages.${system}.clinerules; in {
    type = "app";
    program = pkgs.writeShellApplication {
      name = "sync-rules";
      runtimeInputs = [ pkgs.findutils pkgs.coreutils ];
      text = ''
        set -euo pipefail
        ${findRepoRoot}
        find "$root" -name '*.generated.md' -delete
        copy_tree() {
          local src="$1" dest_base="$2"
          for item in "$src"/*; do
            [ -e "$item" ] || continue
            local bn="$(basename "$item")"
            if [ -d "$item" ]; then
              copy_tree "$item" "$dest_base/$bn"
            elif [ -f "$item" ]; then
              mkdir -p "$dest_base/.clinerules"
              cp "$item" "$dest_base/.clinerules/"
            fi
          done
        }
        copy_tree "${clinerules}" "$root"
        echo "Cline rules synchronized."
      '';
    };
  };
```

The derivation output mirrors the level structure:

```
clinerules/
├── 10-conventional-commits.generated.md   # root level (".")
├── 20-open-remote-after-push.generated.md
├── backend/
│   └── 30-run-tests-before-commit.generated.md
└── backend/
    └── api/
        └── 40-error-handling.generated.md
```

Agents like Cline accumulate rules as they descend the directory tree — a file at `backend/api/handler.ts` inherits rules from all three levels.

To validate rule format, wire `lib.lintRules` into your flake's `checks`:

```nix
checks.${system}.rules-lint = llm-rules.lib.lintRules pkgs;
```

The `rules` attribute set is the public API. Renaming or removing a rule is a breaking change for consumers and must be signaled accordingly.

## License

This project is licensed under the [MIT License](./LICENSE).
