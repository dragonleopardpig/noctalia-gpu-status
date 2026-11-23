# noctalia-gpu-status

Noctalia bar plugin (`local/gpu-status`) and helper (`noctalia-gpu-status`) reporting the active renderer GPU and per-monitor scanout GPU under Umbriel.

## Usage

- **Noctalia plugin source**: add this repository as a Noctalia plugin source (`catalog.toml` + `gpu-status/`).
- **Nix flake**: provides `packages.x86_64-linux.{helper,plugin}`, `lib.{mkHelper,pluginDir,helperScript}`, and `checks.x86_64-linux.helper`. Pass an Umbriel package via `lib.mkHelper { inherit pkgs umbriel; }`.
