# 小学数学学习系统（pep-math-coach 衍生部署版）

开源项目 [kenowong/pep-math-coach](https://github.com/kenowong/pep-math-coach) 的静态部署成品。
**小学 1–6 年级数学 · 人教版章节同步教练 + 240 个奥数/应用题专题系统归类**，纯前端、零依赖、可完全离线。

## 它包含什么
- **章节主线**：学段 → 年级/册 → 章（人教版 1–6 年级）
- **奥数题库（#/oly）**：240 个专题（6 年级 × 每册 40 周），每个专题对应参数化出题引擎，每轮现场原创生成、不重样；含分步解析 + SVG 配图 / 交互动图
- **学习方法 / 技巧 / 错题复盘 / 间隔复习（Leitner）/ 打印错题卷扫码复核**闭环
- 已实读确认收录的经典应用题专题：鸡兔同笼、植树、工程、行程、牛吃草、浓度、时钟、年龄、盈亏、和差倍、归一、相遇、追及、抽屉、周期、平均数

> 诚实边界：本项目是**应用题练习/出题 + 系统归类**工具，**不含真人教学视频**（仅有 SVG 配图与交互动图）。要看老师讲视频，需另配同桌100/可汗学院等站点。许可证沿用上游 MIT（奥数专题仅收录目录级信息与自创同题型，规避版权）。

## 方式一：本地 / 离线直接用（无需联网、无需账号）
- **最简单**：双击 `pep-math-coach-standalone.html`（单文件 991KB，零依赖，断网可用）。
- **多文件版（功能完整）**：在本目录执行
  ```
  node serve.js
  ```
  然后浏览器打开 http://127.0.0.1:8142/ （自带 Node 即可；本机 Python 环境已损坏，请用 Node）。

## 方式二：部署到公网（GitHub Pages，生成可分享链接）
需要你自己的 GitHub 账号（本项目无内置凭据）。两步：
1. 在 https://github.com/settings/tokens 生成一个 **Personal Access Token**（classic 勾 `repo`，或 fine-grained 给"创建仓库"权限）。令牌仅在部署时用于推送，部署后可随时在 GitHub 撤销。
2. 在本目录执行（把 `ghp_xxx` 换成你的令牌）：
   ```
   powershell -ExecutionPolicy Bypass -File deploy.ps1 -Token ghp_xxx
   ```
   脚本会自动建仓库、推送、开启 Pages，最后打印公网地址：
   `https://<你的用户名>.github.io/pep-math-coach/`

> 若想让我（WorkBuddy）代你执行部署，把令牌发给我即可；部署完成后建议立即在 GitHub 撤销该令牌。
