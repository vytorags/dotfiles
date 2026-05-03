# DankTranslate

A launcher plugin for [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) that translates text between languages using [translate-shell](https://github.com/soimort/translate-shell).

![Screenshot](docs/screenshot.png)

## Features

- Translate text from the launcher with debounced async results
- Default target language (configurable, defaults to English)
- Override target language with a prefix code (e.g. `pt`, `ja`, `es`)
- Copy translations to clipboard on selection

## Installation

### Nix (flake)

Add as a `flake = false` input and include in your DMS plugin configuration:

```nix
inputs.dms-plugin-translate = {
  url = "github:alcxyz/DankTranslate";
  flake = false;
};
```

```nix
programs.dank-material-shell.plugins.DankTranslate = {
  enable = true;
  src = inputs.dms-plugin-translate;
};
```

### Manual

Copy the plugin directory to `~/.config/DankMaterialShell/plugins/DankTranslate/`.

## Usage

Activate with `>` (default trigger) in the DMS launcher, then:

- `>hello world` — translate to English (default)
- `>pt hello world` — translate to Portuguese
- `>ja good morning` — translate to Japanese
- Select a result to copy it to clipboard

## Requirements

- [translate-shell](https://github.com/soimort/translate-shell) (`trans` command)
- `wl-copy` — Wayland clipboard utility

## License

MIT

<details>
<summary>Support</summary>

- **BTC:** `bc1pzdt3rjhnme90ev577n0cnxvlwvclf4ys84t2kfeu9rd3rqpaaafsgmxrfa`
- **ETH / ERC-20:** `0x2122c7817381B74762318b506c19600fF8B8372c`
</details>
