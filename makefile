.PHONY: help install start-server start-web start clean

help:
	@echo "Available commands:"
	@echo "  make install      - Install all dependencies"
	@echo "  make start-server - Start API server (port 3456)"
	@echo "  make start-web  - Start web frontend (port 2024)"
	@echo "  make start     - Start both server and web"
	@echo "  make clean    - Clean node_modules and logs"

install:
	bun install
	cd desktop && bun install

start-server:
	cd $(PWD) && SERVER_PORT=3456 bun run src/server/index.ts

start-web:
	cd $(PWD)/desktop && bun run dev --host 127.0.0.1 --port 2024

start:
	@echo "Starting API server on port 3456..."
	@echo "Starting web frontend on http://127.0.0.1:2024"
	cd $(PWD) && SERVER_PORT=3456 bun run src/server/index.ts &
	sleep 2
	cd $(PWD)/desktop && bun run dev --host 127.0.0.1 --port 2024

clean:
	rm -rf node_modules desktop/node_modules
	rm -f *.log /tmp/server.log