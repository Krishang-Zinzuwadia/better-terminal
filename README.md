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