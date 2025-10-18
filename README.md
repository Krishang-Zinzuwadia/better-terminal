# better-terminal

```markdown
# better-terminal

better-terminal is a small Bash utility that colorizes piped text using a 6-digit hex color (truecolor / 24-bit). It's built to be simple, predictable, and easy to use on modern Linux distributions.

Key features
- Colorizes input text using a single hex color (foreground truecolor escape sequences).
- Accepts a hex color with or without a leading `#` and also supports 3-digit hex and numeric ANSI/256/SGR values.
- Designed to be callable as a global command (e.g. `better-terminal`) or from the repository `bin/` directory.

Important shell note
- In shells like bash, an unquoted `#` begins a comment. That means this will not work as you might expect:

   better-terminal #FFFF00

   The shell treats the `#FFFF00` as a comment. Use one of the following forms instead:

   - Quote the hex:  cat art.txt | better-terminal '#FFFF00'
   - Escape the hash: cat art.txt | better-terminal \#FFFF00
   - Omit the hash:  cat art.txt | better-terminal FFFF00

Installation

Two common approaches are available. If you want a one-shot system-wide install, the `Makefile` now provides an `install` target which installs both the `better-terminal` executable and the library.

- Per-user (no sudo required):

   ```bash
   mkdir -p ~/.local/bin
   install -Dm755 bin/better-terminal ~/.local/bin/better-terminal
   mkdir -p ~/.local/lib/better-terminal
   install -Dm755 lib/color.sh ~/.local/lib/better-terminal/color.sh
   # ensure ~/.local/bin is on your PATH (add to ~/.profile or ~/.bashrc)
   export PATH="$HOME/.local/bin:$PATH"
   ```

- System-wide (requires sudo):

   ```bash
   sudo make install
   ```

   The `make install` target will install the binary to `/usr/local/bin/better-terminal`, the library to `/usr/local/lib/better-terminal/color.sh`, and (if present) the bash completion to `/etc/bash_completion.d/`.

Usage

Pipe text into `better-terminal` and pass a 6-digit hex color (with or without `#`):

```bash
echo "Hello, World!" | better-terminal '#FF5733'   # quoted hex
echo "Hello, World!" | better-terminal FFFF00     # no leading #

# here-doc / ASCII art example
cat <<'EOF' | better-terminal '#FFFF00'
<your ascii art here>
EOF
```

Behavior and validation
- The script validates that the provided color is 6 hex digits (case-insensitive) or 3-digit hex; numeric SGR/256 values are accepted too. On invalid input it prints `Invalid hex code` to stderr and exits with a non-zero code.
- The tool uses ANSI truecolor escape sequences (ESC[38;2;R;G;Bm). Your terminal must support 24-bit color for exact color rendering (most modern terminals do).

Development and tests
- The project has support for tests using Bats. If a `tests/` directory exists with Bats tests, run them from the repo root with:

```bash
# ensure bats is installed (bats-core), then
make test
```

If `bats` is not installed or there are no tests present, the `make test` target will print a helpful message instead of failing.

Contributing
- Bug reports and pull requests welcome. If you change behavior (for example, preserve blank lines or add more color formats), please update or add tests in `tests/*.bats` accordingly.

Notes
- `bin/better-terminal` looks for its helper `color.sh` in a few places so an installed binary can find the library: the repo `lib/` directory, `~/.local/lib/better-terminal/`, and `/usr/local/lib/better-terminal/`.
- If you'd like blank lines preserved (instead of skipped), open an issue or a PR — it's a small behavior change and tests may need adjustments.

License

This project is licensed under the MIT License — see the `LICENSE` file for details.
```

## Options & examples

The script accepts a few flags and positional color arguments. Typical usage is via a pipe:

```bash
# basic: color stdin with a hex color
echo "Hello" | better-terminal '#FF5733'

# or without the leading '#'
echo "Hello" | better-terminal FF5733

# explicit flag form
echo "Hello" | better-terminal -c '#FF5733'
```

Options
- -t, --truecolor: force truecolor (24-bit) output. If omitted the tool will prefer ANSI/256 or SGR codes when appropriate.
- -c <hex>: specify a hex color via option instead of positional argument.
- --gradient <color1> <color2>: enable a gradient between two colors. Colors may be 3/6-digit hex, or numeric SGR/256 values.
- --direction <left|right|top|bottom>: gradient direction (default: left).
- -u, --unit <char|word>: in `left`/`right` gradients, whether the gradient is applied per-character or per-word (default: char).
- -h, --help: print a short usage message.

Gradient examples

```bash
# left-to-right per-character gradient (default unit)
cat art.txt | better-terminal --gradient '#ff0000' '#0000ff' --direction left

# right-to-left per-word gradient
cat art.txt | better-terminal --gradient '#ff0000' '#0000ff' --direction right --unit word

# vertical gradient (top->bottom)
cat art.txt | better-terminal --gradient '#ff0000' '#0000ff' --direction top

# bottom->top
cat art.txt | better-terminal --gradient '#ff0000' '#0000ff' --direction bottom
```

Notes on accepted color formats
- 6-digit hex: `#RRGGBB` or `RRGGBB`.
- 3-digit hex shorthand: `#RGB` or `RGB` (expanded internally to `RRGGBB`).
- Numeric values: standard SGR codes (30-37, 90-97) or ANSI/256 indexes (0-255) are supported; gradients accept numeric colors too.

Behavior details
- By default the tool skips blank lines (they are not printed). If you want blank-line preservation that's a small behavior change we can add on request.
- When `--truecolor` is used the script emits 24-bit `ESC[38;2;R;G;Bm` sequences. Without `--truecolor`, 256-color or SGR fallbacks are used when numeric or when the hex is mapped to the closest ANSI/256 index.
- `bin/better-terminal` searches for `lib/color.sh` in these locations (in order): `lib/` relative to the repo, `~/.local/lib/better-terminal`, `/usr/local/lib/better-terminal`.

Installation (updated)

Per-user (no sudo required):

```bash
mkdir -p ~/.local/bin
install -Dm755 bin/better-terminal ~/.local/bin/better-terminal
mkdir -p ~/.local/lib/better-terminal
install -Dm644 lib/color.sh ~/.local/lib/better-terminal/color.sh
# ensure ~/.local/bin is on your PATH
export PATH="$HOME/.local/bin:$PATH"
```

System-wide (requires sudo):

```bash
sudo make install
```

The `make install` target installs the binary to `/usr/local/bin/better-terminal`, the helper library to `/usr/local/lib/better-terminal/color.sh`, and (if present) the bash completion to `/etc/bash_completion.d/better-terminal`.

Testing

If you add Bats tests under `tests/*.bats` you can run them with:

```bash
# ensure bats-core is available
make test
```

If `bats` is not installed or no tests exist the `make test` target will print a descriptive message and exit cleanly.

Changelog (recent)
- 2025-10-18: Fixed gradient `--unit word` handling for `left` direction so per-word gradients match `right` behavior.
- 2025-10-18: Fixed `bottom` direction to map colors to the correct (reversed) lines when printing.
- 2025-10-18: `Makefile install` updated to install `lib/color.sh` and bash completion (if present).

Contributing

Bug reports and pull requests welcome. If you change behavior (for example, preserve blank lines or add additional color formats), please add or update tests in `tests/*.bats` accordingly.

License

This project is licensed under the MIT License — see the `LICENSE` file for details.
