#!/bin/bash
# dev-server start script — 1回のbash実行で全サービスを起動する
set -e

# --- 設定 ---
RAILS_PORT="${RAILS_PORT:-3000}"
BIND="${BIND:-0.0.0.0}"
PROJECT_DIR="${1:-.}"

cd "$PROJECT_DIR"

# --- 関数 ---
info()  { echo "==> $*"; }
ok()    { echo "  ✓ $*"; }
fail()  { echo "  ✗ $*" >&2; }

# --- 1. PostgreSQL（既に起動済みならスキップ） ---
info "PostgreSQL"
if pg_isready -q 2>/dev/null; then
  ok "already running"
else
  if command -v systemctl &>/dev/null && systemctl is-enabled postgresql &>/dev/null; then
    sudo systemctl start postgresql
  elif command -v brew &>/dev/null; then
    brew services start postgresql@16 2>/dev/null || brew services start postgresql 2>/dev/null
  else
    sudo service postgresql start
  fi
  # 最大5秒待つ
  for i in 1 2 3 4 5; do
    pg_isready -q 2>/dev/null && break
    sleep 1
  done
  pg_isready -q 2>/dev/null && ok "started" || { fail "failed to start"; exit 1; }
fi

# --- 2. 古いRailsプロセスの掃除 ---
info "Rails (port $RAILS_PORT)"
if [ -f tmp/pids/server.pid ]; then
  OLD_PID=$(cat tmp/pids/server.pid)
  if kill -0 "$OLD_PID" 2>/dev/null; then
    kill "$OLD_PID" 2>/dev/null; sleep 1
    ok "killed stale process ($OLD_PID)"
  else
    rm -f tmp/pids/server.pid
    ok "removed stale pid file"
  fi
elif lsof -i ":$RAILS_PORT" -t &>/dev/null; then
  kill $(lsof -i ":$RAILS_PORT" -t) 2>/dev/null; sleep 1
  ok "freed port $RAILS_PORT"
fi

# --- 3. bundle check（失敗時のみinstall） ---
if ! bundle check --dry-run &>/dev/null; then
  info "bundle install"
  bundle install --jobs=$(nproc) --quiet
  ok "done"
fi

# --- 4. マイグレーション（pendingがある場合のみ） ---
if bin/rails db:migrate:status 2>/dev/null | grep -q "^\s*down"; then
  info "db:migrate"
  bin/rails db:migrate --quiet
  ok "done"
fi

# --- 5. Rails起動（デーモンモード） ---
bin/rails server -b "$BIND" -p "$RAILS_PORT" -d
sleep 2

if curl -s -o /dev/null -w '' "http://localhost:$RAILS_PORT" 2>/dev/null; then
  ok "running at http://localhost:$RAILS_PORT"
else
  # curl失敗でもプロセスが生きていればOK（初回起動は遅いことがある）
  if [ -f tmp/pids/server.pid ] && kill -0 "$(cat tmp/pids/server.pid)" 2>/dev/null; then
    ok "process started (pid $(cat tmp/pids/server.pid)), may still be booting"
  else
    fail "failed to start — check log/development.log"
    exit 1
  fi
fi

echo ""
echo "🚀 Dev server ready: http://localhost:$RAILS_PORT"
