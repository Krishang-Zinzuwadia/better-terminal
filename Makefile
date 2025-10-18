.PHONY: all install test clean

all: better-terminal

better-terminal: bin/better-terminal lib/color.sh
	@echo "Building better-terminal..."

install: better-terminal
	@echo "Installing better-terminal..."
	@install -Dm755 bin/better-terminal /usr/local/bin/better-terminal
	@install -d /usr/local/lib/better-terminal
	@install -Dm644 lib/color.sh /usr/local/lib/better-terminal/color.sh
	@if [ -f completions/better-terminal.bash ]; then \
		install -Dm644 completions/better-terminal.bash /etc/bash_completion.d/better-terminal; \
		echo "Installed bash completion to /etc/bash_completion.d/better-terminal"; \
	fi

test:
	@echo "Running tests..."
	@if command -v bats >/dev/null 2>&1; then \
		if [ -d tests ] && ls tests/*.bats >/dev/null 2>&1; then \
			bats tests/*.bats; \
		else \
			echo "No Bats tests found (create tests/*.bats to enable)."; \
		fi \
	else \
		echo "bats not found; install bats-core to run tests."; \
	fi

clean:
	@echo "Cleaning up..."
	@rm -f bin/better-terminal
	@echo "Clean complete."