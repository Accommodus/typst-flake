# Typst Development Environment Flake

A Nix flake providing a complete Typst development environment with Typst, TinyMist LSP, and the Besley font family.

## What's Included

- **Typst** - The typesetting system
- **TinyMist** (v0.14.4) - Language Server Protocol for Typst
- **Besley** - Font family for Typst
- **Fontconfig** - Configured to use Besley fonts

## Prerequisites

- [Nix](https://nixos.org/download.html) with Flakes enabled
- (Optional) [Cursor](https://cursor.sh/) editor for the default shell behavior

## Usage

### Direct Usage

If you have this flake locally or cloned from GitHub:

```bash
# Default: Automatically opens Cursor with typst profile
nix develop

# Or specify a different shell variant
nix develop .#simple
nix develop .#manual
```

### Using from GitHub

You can use this flake directly from GitHub without cloning:

```bash
# Default shell (opens Cursor automatically)
nix develop github:yourusername/typst-flake

# Simple shell (no Cursor auto-launch)
nix develop github:yourusername/typst-flake#simple

# Manual shell (shows instructions)
nix develop github:yourusername/typst-flake#manual
```

### Using in Your Own Flake

Add this flake as an input in your `flake.nix`:

```nix
{
  inputs = {
    typst-flake.url = "github:yourusername/typst-flake";
    # ... other inputs
  };

  outputs = { self, typst-flake, ... }: {
    devShells.default = typst-flake.devShells.${system}.simple;
    # Or use .default or .manual
  };
}
```

## Shell Variants

This flake provides three devShell variants:

### `default` (or no suffix)

Automatically executes `cursor --profile "typst" .` when entering the shell, opening Cursor in the current directory with the typst profile.

**Use when:** You want to immediately start editing Typst files in Cursor.

```bash
nix develop
# or
nix develop github:yourusername/typst-flake
```

### `simple`

Sets up the environment without any automatic Cursor launch. Just provides a ready-to-use Typst environment.

**Use when:** You want the Typst tools but prefer to open your editor manually or use a different editor.

```bash
nix develop .#simple
# or
nix develop github:yourusername/typst-flake#simple
```

### `manual`

Shows helpful instructions for opening Cursor manually, but doesn't auto-launch it.

**Use when:** You want a reminder of how to use Cursor but prefer manual control.

```bash
nix develop .#manual
# or
nix develop github:yourusername/typst-flake#manual
```

## Examples

### Compile a Typst file

```bash
nix develop
typst compile document.typ
```

### Use TinyMist LSP

The TinyMist language server is available in the environment. Configure your editor to use it:

```bash
# TinyMist binary location
which tinymist
```

### Check available tools

```bash
nix develop
typst --version
tinymist --version
```

## Font Configuration

The Besley font family is automatically configured via `FONTCONFIG_FILE`. Typst will be able to use Besley fonts without additional configuration.

## License

This flake is provided as-is. Check the licenses of the included packages:
- Typst: Apache-2.0
- TinyMist: Check [Myriad-Dreamin/tinymist](https://github.com/Myriad-Dreamin/tinymist)
- Besley: SIL Open Font License
