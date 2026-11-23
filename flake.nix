{
  description = "Noctalia local/gpu-status bar indicator for active rendering and monitor scanout GPUs";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHelper = { pkgs, umbriel ? null }:
        pkgs.writeShellApplication {
          name = "noctalia-gpu-status";
          runtimeInputs = [ pkgs.python3 ] ++ pkgs.lib.optional (umbriel != null) umbriel;
          text = ''
            exec python3 ${./helper/gpu-status.py} "$@"
          '';
        };
      helper = mkHelper { inherit pkgs; };
      plugin = pkgs.runCommand "noctalia-plugin-gpu-status" { } ''
        cp -r ${./gpu-status} $out
      '';
    in {
      lib = {
        inherit mkHelper;
        pluginDir = ./gpu-status;
        helperScript = ./helper/gpu-status.py;
      };
      packages.${system} = {
        inherit helper plugin;
        default = helper;
      };
      checks.${system} = {
        helper = pkgs.runCommand "noctalia-gpu-status-checked" {
          nativeBuildInputs = [ pkgs.python3 ];
        } ''
          python3 ${./tests/test-gpu-status.py} ${./helper/gpu-status.py}
          touch $out
        '';
      };
    };
}
