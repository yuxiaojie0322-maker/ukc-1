# unikraft-deploy

在 [Unikraft Cloud](https://unikraft.cloud) 上部署 VLESS over WebSocket 代理服务。

## 准备工作

### 1. Unikraft 账号与 Token

1. 注册并登录 [Unikraft Cloud Console](https://console.unikraft.cloud/)

2. 获取 API Token（用于 CLI 登录）

   登录后点击 **左边菜单 Organization → API Keys**，可以查看当前用户的 API TOKEN。

### 2. 准备 UUID

生成一个标准 UUID（例如 `uuidgen` 或在线工具），请自行妥善保存，不要提交到仓库。

### 3.（可选）Cloudflare Tunnel

若希望节点额外多一个 Cloudflare 隧道的入口，准备：

| 参数 | 说明 |
|------|------|
| `ARGO_DOMAIN` | Tunnel 对外域名，如 `example.com` |
| `ARGO_TOKEN` | Cloudflare Tunnel Token |

两者需**同时填写**或**同时留空**，Argo 服务的内部访问地址是 `http://127.0.0.1:8080` (必须一致)

### 4. Fork 本仓库

将本仓库 Fork 到你的 GitHub 账号下，也可以顺手点个赞 ⭐ 支持一下。

## GitHub 配置

在仓库 **Settings → Secrets and variables → Actions** 中添加：

| Secret | 必填 | 说明 |
|--------|------|------|
| `UNIKRAFT_TOKEN` | 是 | Unikraft API Token |
| `UUID` | 是 | VLESS UUID，兼作解密密钥 |
| `ARGO_DOMAIN` | 否 | Cloudflare Tunnel 域名 |
| `ARGO_TOKEN` | 否 | Cloudflare Tunnel Token |

## 部署步骤

1. 打开仓库 **Actions → Create Unikraft Instance**
2. 点击 **Run workflow**
3. 选择部署地区（metro）：

| 选项 | 代码 | 说明 |
|------|------|------|
| `dal - 达拉斯 (Dallas, US)` | `dal` | 美国达拉斯 |
| `fra - 法兰克福 (Frankfurt, DE)` | `fra` | 德国法兰克福 |
| `sfo - 旧金山 (San Francisco, US)` | `sfo` | 美国旧金山 |
| `sin - 新加坡 (Singapore)` | `sin` | 新加坡（默认） |
| `was - 华盛顿 (Washington DC, US)` | `was` | 美国华盛顿 |

4. 运行完成后，在 **Job Summary** 或构建日志中可以查看加密的订阅信息。

## 解密订阅

1. Actions 构建完成后，打开 **Summary** 页面，查看加密的订阅信息，格式如下：

   `https://vevc.github.io/unikraft-deploy/?payload=...`

2. 直接点击链接打开，页面会自动填入加密 Payload
3. 在「解密密钥」输入框填入你配置的 `UUID`
4. 点击 **解密订阅**，得到明文订阅信息

全程在浏览器本地完成（Web Crypto），不会上传 UUID 和订阅信息，安全可控。

## 注意事项

- `UUID`、`UNIKRAFT_TOKEN`、`ARGO_TOKEN` 属于敏感信息，只放在 GitHub Secrets，不要写入代码提交
- 每次部署会构建镜像 `<org>/unikraft:latest` 并启动新实例
- 如需清理旧实例，可以使用 **Actions → Delete Unikraft Instance** 删除
