#!/bin/bash
# dev-server status check
PROJECT_DIR="${1:-.}"
RAILS_PORT="${RAILS_PORT:-3000}"

cd "$PROJECT_DIR" 2>/dev/null

echo "=== Dev Server Status ==="

# PostgreSQL
printf "PostgreSQL: "
pg_isready -q 2>/dev/null && echo "✓ running" || echo "✗ not running"

# Rails
printf "Rails:      "
if [ -f tmp/pids/server.pid ] && kill -0 "$(cat tmp/pids/server.pid)" 2>/dev/null; then
  echo "✓ running (pid $(cat tmp/pids/server.pid), port $RAILS_PORT)"
elif lsof -i ":$RAILS_PORT" -t &>/dev/null; then
  echo "✓ running (port $RAILS_PORT)"
else
  echo "✗ not running"
fi
