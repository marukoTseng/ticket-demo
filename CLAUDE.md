# ticket-demo

交通票券系統 demo（系統名稱：購票系統）。

技術棧：Vue 3 / Vuetify / Vite；Java 17 / Spring Boot / WildFly；Quartz；SQL Server。

## 版控策略

### 分支

| 分支 | 用途 |
|---|---|
| `main` | 整合各 feature、hotfix 內容，產出 prod 新版 |
| `hotfix` | 緊急修復 prod 版本錯誤，從 `main` 切出 |
| `sit` | 上線前 PT 測試 |
| `dev` | 共用的整合分支，所有 feature 都從 `dev` 切出 |
| `feature/*` | 開發新功能 |

- feature 分支命名：`feature/西元年_月份_CR需求名稱`，月份兩位數，例：`feature/2026_10_SQLServer開發環境`
- feature 完成後開 PR 合併回 `dev`
- `main`、`dev`、`sit` 受 GitHub ruleset 保護：不可直接 push、強推或刪除，只能透過 PR 合併
- 待定義：`dev → sit → main` 的推進方式、hotfix 分支命名、hotfix 合併回 `dev` / `sit` 的方式

### Commit 格式

標籤之間不加空格，冒號後不加空格，`DB Script` 一律寫作 `[DB Script:是]` 或 `[DB Script:否]`。
有 DB Script（schema、資料異動 SQL）時填「是」。

**CR**

```
[CR][DB Script:是/否][系統名稱:購票系統][需求:<需求編號與名稱>][模組:<模組1、模組2>]<commit 內容>
```

例：`[CR][DB Script:否][系統名稱:購票系統][需求:Req_28自訂帳號規則調整][模組:首次登入、強制更換帳號、帳號變更]不允許特殊符號含底線(_)、破折號(-)、半形句號(.)或是空白`

**Hotfix**

```
[hotfix][DB Script:是/否][系統名稱:購票系統][<編號>]<commit 內容>
```

例：`[hotfix][DB Script:否][系統名稱:購票系統][2]調整忘記密碼token時限為20分鐘`

**Other**（環境、文件、工具等非需求變更）

```
[Other][DB Script:是/否][<需求內容>][功能名稱:<功能名稱>]<說明>
```

例：`[Other][DB Script:否][建立本機開發資料庫][功能名稱:SQL Server Docker 開發環境]新增 docker-compose 啟動 SQL Server`

PR 標題沿用該 PR 主要 commit 的標籤格式。

## 本機開發環境

- SQL Server：`docker compose up -d`（設定見 `docker-compose.yml`，sa 密碼放在不進版控的 `.env`，範本為 `.env.example`）
- 資料庫：`ticket_demo`，定序 `Chinese_Taiwan_Stroke_CI_AS`
- JDK：Temurin 17，`JAVA_HOME=C:\Program Files\Java\jdk-17-temurin`
