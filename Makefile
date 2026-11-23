.PHONY: build run lint fmt repl repl.run

build:
	mix do deps.get + compile

run:
	mix phx.server

# Code Quality

lint:
	mix format --check-formatted

fmt:
	mix format

# Repl
repl:
	iex -S mix

repl.run:
	iex -S mix phx.server
