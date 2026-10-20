# ticket-demo

交通票券系統 demo（系統名稱：購票系統）。

技術棧：Vue 3 / Vuetify / Vite；Java 17 / Spring Boot / WildFly；Quartz；SQL Server。

## 版控策略

### 分支

| 分支 | 用途 |
|---|---|
| `main` | 整合各 feature、hotfix 內容，產出 prod 新版 |
| `hotfix/*` | 緊急修復 prod 版本錯誤，從 `main` 切出 |
| `sit` | 上線前 PT 測試 |
| `dev` | 共用的整合分支，所有 feature 都從 `dev` 切出 |
| `feature/*` | 開發新功能 |

- `main`、`dev`、`sit` 受 GitHub ruleset 保護：不可直接 push、強推或刪除，只能透過 PR 合併

**命名**

- feature：`feature/西元年_月份_CR需求名稱`，月份兩位數，例：`feature/2026_10_SQLServer開發環境`
- hotfix：`hotfix/西元年_月份_編號_問題`，例：`hotfix/2026_10_2_忘記密碼token時限`

**流程**

1. 開發：從 `dev` 切出 `feature/*`，完成後開 PR 合併回 `dev`
2. 上線前：從 `dev` 開 PR 到 `sit`，進行 PT 測試
3. 上線：PT 測完，從 `sit` 開 PR 到 `main`，產出 prod 新版
4. 緊急修復：從 `main` 切出 `hotfix/*`，修好後開 PR 合併回 `main`；**上線後**再把 `main` 同步回 `dev` 與 `sit`（各開一個 PR）

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

commit 訊息與 PR 說明不寫帳號名稱、密碼或機密的存放位置。

commit 作者使用本 repo 設定的 GitHub noreply 信箱（`git config user.email`），不要用個人信箱。

## DB Script

- 所有 DB script（建庫、建帳號、schema、資料異動）都要進版控，放在 `db/` 底下；有 DB script 的 commit 標 `[DB Script:是]`
- 涉及密碼等機敏欄位時，不寫真實值，改用佔位變數或範例值：
  - 由工具執行的腳本用 sqlcmd 變數，例：`WITH PASSWORD = N'$(APP_DB_PASSWORD)'`，實際值由不進版控的環境設定提供
  - 需人工執行的腳本用明顯的範例值，例：`N'<請替換為實際密碼>'`，並在註解說明須替換
- 腳本盡量可重複執行（先判斷是否存在再建立）

## 本機開發環境

- SQL Server：`docker compose up -d`（設定見 `docker-compose.yml`，連線所需的機密設定不進版控，依 `.env.example` 建立）
- 資料庫：`ticket_demo`，定序 `Chinese_Taiwan_Stroke_CI_AS`；啟動時由 `db/init/*.sql` 自動建立資料庫與應用程式帳號
- 後端連線使用應用程式帳號（僅限 `ticket_demo`），不使用 sa
- 1433 僅綁定 127.0.0.1
- JDK：Temurin 17，`JAVA_HOME=C:\Program Files\Java\jdk-17-temurin`
