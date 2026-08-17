{
  description = "LLM-agnostic agent rules — a Nix catalog of rule files.";

  outputs = { self }:
    let
      root = ./.;

      # The naming convention in AGENTS.md (lowercase kebab-case `.md`) is the
      # discovery contract: every compliant rule file at the repo root joins the
      # catalog; non-rule root files (AGENTS.md, README.md, LICENSE, flake.nix,
      # .gitignore) are excluded because they are not lowercase kebab-case.
      ruleRegex = "([a-z][a-z0-9-]*)\\.md";
      isRule = n: builtins.match ruleRegex n != null;
      ruleFiles = builtins.filter isRule (builtins.attrNames (builtins.readDir root));
      nameOf = f: builtins.head (builtins.match ruleRegex f);

      # Stable public API: rule name -> store path of the rule file.
      rules = builtins.listToAttrs (map (f: {
        name  = nameOf f;
        value = root + "/${f}";
      }) ruleFiles);

      # Build an ordered directory of selected rules. The provider is
      # agent-agnostic: the consumer names the derivation (`name`) and chooses
      # the managed-file marker (`sentinel` -> `<key>${sentinel}.md`). Which
      # workspace directory the rules land in is the consumer's sync concern.
      # `ordered` maps an output basename (e.g. "10-conventional-commits") to a
      # rule name. Unknown names fail at evaluation time (typo-safe). `pkgs` is
      # the consumer's nixpkgs, so this flake stays input-free.
      materializeRules = pkgs: { ordered ? { }, name ? "rules", sentinel ? ".generated" }:
        let
          entries = builtins.attrValues (builtins.mapAttrs
            (out: rule: { name = "${out}${sentinel}.md"; src = rules.${rule}; })
            ordered);
          copyLines = map (e: ''cp "${e.src}" "$out/${e.name}"'') entries;
        in pkgs.runCommand name { } ''
          mkdir -p "$out"
          ${builtins.concatStringsSep "\n" copyLines}
        '';
    in {
      inherit rules;
      lib.materializeRules = materializeRules;
    };
}
