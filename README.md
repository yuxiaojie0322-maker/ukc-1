# ukc-deploy (Unikraft Deployment)

基于 [vevc/unikraft-deploy](https://github.com/vevc/unikraft-deploy) 架构在 [Unikraft Cloud](https://unikraft.cloud) 上部署 VLESS over WebSocket 代理服务。

## 特性

- 🚀 **极致精简微内核**：基于 Unikraft 微内核与 Sing-box 最新版构建，秒级启动与极低资源消耗。
- 🌍 **多地区可选**：支持新加坡 (`sin`)、法兰克福 (`fra`)、达拉斯 (`dal`)、旧金山 (`sfo`)、华盛顿 (`was`) 五大 Metro 节点。
- 🔐 **订阅端到端加密**：使用 AES-256-CBC 对节点订阅信息进行加密，防日志泄露；提供本地网页解密工具。
- ☁️ **原生 Cloudflare Tunnel 支持**：支持通过 `ARGO_DOMAIN` 与 `ARGO_TOKEN` 接入 Cloudflare 隧道。
- 📱 **Telegram 机器人通知**：部署完成后自动将节点信息与解密链接推送至 Telegram。

---

## 准备工作

### 1. Unikraft API Token
1. 登录 [Unikraft Cloud Console](https://console.unikraft.cloud/)
2. 在 GitHub 仓库设置 `UNIKRAFT_TOKEN`（或 `UKC_TOKEN`）。

### 2. GitHub Secrets 配置

进入仓库 **Settings → Secrets and variables → Actions**：

| Secret 名称 | 是否必填 | 说明 |
|-------------|----------|------|
| `UKC_TOKEN` 或 `UNIKRAFT_TOKEN` | **必填** | Unikraft API Token |
| `UUID` | 选填 | 节点 UUID（兼作解密密钥，默认预置） |
| `ARGO_DOMAIN` | 选填 | Cloudflare Tunnel 对外域名 |
| `ARGO_TOKEN` | 选填 | Cloudflare Tunnel Token |
| `TG_BOT_TOKEN` | 选填 | Telegram Bot Token（通知用） |
| `TG_CHAT_ID` | 选填 | Telegram Chat ID（通知用） |

---

## 部署流程

1. 进入仓库 **Actions** 标签页。
2. 选择 **Create Unikraft Instance** 工作流。
3. 点击 **Run workflow**：
   - **部署地区 (metro)**：选择需要部署的节点区域（默认新加坡 `sin`）。
   - **VLESS UUID**：可指定 UUID 或留空使用 Secret / 预设 UUID。
4. 部署完成后，在 GitHub Actions **Job Summary** 中查看加密链接。
5. 打开 GitHub Pages 解密页面或备用解密工具，输入你的 UUID 即可获取明文 VLESS 节点链接！

---

## 删除实例

若需清理或重建实例：
1. 进入 **Actions → Delete Unikraft Instance**。
2. 选择地区，填写实例名称或勾选 `delete_all` 删除该区域全部实例。
