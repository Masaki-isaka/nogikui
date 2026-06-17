---
name: dev-server
description: Rails開発サーバとPostgreSQLサーバの起動・停止・状態確認を行う。「rails起動」「サーバ立ち上げ」「rails s」「開発サーバ開始」「ポスグレ起動」「PostgreSQL開始」「DB起動」「postgres start」「開発環境セットアップ」「サーバ全部起動して」「start server」「boot up」「run rails」「dev environment」などのリクエストに反応する。RailsとPostgreSQLどちらか一方、または両方まとめて操作できる。
---

# Dev Server Manager

**速度最優先**: すべての操作はスクリプト1本を1回のbash実行で完了させる。複数のbash_tool呼び出しに分割しないこと。

## スクリプトの場所

このスキルのディレクトリ内に実行スクリプトがある:
- `scripts/start.sh` — PostgreSQL + Rails を一括起動
- `scripts/stop.sh` — 停止
- `scripts/status.sh` — 状態確認

## 起動（最も頻繁に使う）

**1回のbash_toolで以下を実行する。それ以上呼ばないこと:**

```bash
bash /mnt/skills/user/dev-server/scripts/start.sh /path/to/rails/project
```

スクリプトが自動で行うこと:
1. PostgreSQLの起動確認 → 未起動なら起動（macOS/Linux自動判定）
2. 古いRailsプロセス/PIDファイルの掃除
3. bundle check → 必要時のみ bundle install
4. pending migration → あれば db:migrate
5. `rails server -d`（デーモンモード）で起動
6. 起動確認

プロジェクトパスが不明な場合はユーザーに聞く。

## 停止

```bash
bash /mnt/skills/user/dev-server/scripts/stop.sh /path/to/rails/project
```

PostgreSQLも停止したい場合:
```bash
STOP_PG=true bash /mnt/skills/user/dev-server/scripts/stop.sh /path/to/rails/project
```

## 状態確認

```bash
bash /mnt/skills/user/dev-server/scripts/status.sh /path/to/rails/project
```

## トラブルシューティング（起動失敗時のみ参照）

スクリプトがエラーを返した場合のみ、以下を個別に実行して原因を特定する:

- ポート競合: `sudo lsof -i :3000` / `sudo lsof -i :5432`
- Railsログ: `tail -50 log/development.log`
- PGログ（Linux）: `sudo journalctl -u postgresql --no-pager -n 30`
- PGログ（macOS）: `tail -50 /opt/homebrew/var/log/postgresql@16.log`
