#!/bin/bash
# dev-server stop script
set -e

PROJECT_DIR="${1:-.}"
RAILS_PORT="${RAILS_PORT:-3000}"
STOP_PG="${STOP_PG:-false}"

cd "$PROJECT_DIR"

info()  { echo "==> $*"; }
ok()    { echo "  ✓ $*"; }

# --- Rails停止 ---
info "Stopping Rails"
if [ -f tmp/pids/server.pid ]; then
  kill "$(cat tmp/pids/server.pid)" 2>/dev/null && ok "stopped" || ok "was not running"
  rm -f tmp/pids/server.pid
elif lsof -i ":$RAILS_PORT" -t &>/dev/null; then
  kill $(lsof -i ":$RAILS_PORT" -t) 2>/dev/null
  ok "stopped (via port)"
else
  ok "was not running"
fi

# --- PostgreSQL停止（明示的に要求された場合のみ） ---
if [ "$STOP_PG" = "true" ]; then
  info "Stopping PostgreSQL"
  if command -v systemctl &>/dev/null; then
    sudo systemctl stop postgresql && ok "stopped" || ok "was not running"
  elif command -v brew &>/dev/null; then
    brew services stop postgresql@16 2>/dev/null || brew services stop postgresql 2>/dev/null
    ok "stopped"
  else
    sudo service postgresql stop && ok "stopped" || ok "was not running"
  fi
fi

echo ""
echo "✅ Done"
