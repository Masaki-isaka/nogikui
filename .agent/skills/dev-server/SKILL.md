---
name: dev-server
description: Rails開発サーバとPostgreSQLサーバの起動・停止・状態確認を行う。「rails起動」「サーバ立ち上げ」「rails s」「開発サーバ開始」「ポスグレ起動」「PostgreSQL開始」「DB起動」「postgres start」「開発環境セットアップ」「サーバ全部起動して」などのリクエストに反応する。RailsとPostgreSQLどちらか一方、または両方まとめて操作できる。
---

# Dev Server（WSL2 Ubuntu）

## 起動（両方まとめて）

以下を順に実行する:

```bash
pg_isready || sudo service postgresql start
pg_isready
bundle check || bundle install
bin/rails db:migrate:status 2>/dev/null | grep -q "down" && bin/rails db:migrate
bin/rails server -b 0.0.0.0 -p 3000
```

## PostgreSQLのみ

起動: `sudo service postgresql start`
停止: `sudo service postgresql stop`
確認: `pg_isready`

## Railsのみ

起動: `bin/rails server -b 0.0.0.0 -p 3000`
停止: `kill $(cat tmp/pids/server.pid)` またはCtrl+C

## エラー時のみ参照

- ポート競合: `sudo lsof -i :5432` / `sudo lsof -i :3000`
- PGログ: `sudo tail -f /var/log/postgresql/postgresql-*-main.log`
