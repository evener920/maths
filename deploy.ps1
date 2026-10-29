<#
.SYNOPSIS
  一键把本目录部署到 GitHub Pages，生成公开可访问的在线数学学习站。
.DESCRIPTION
  1) 用你的 GitHub Personal Access Token 在 GitHub 新建仓库
  2) 把当前目录(纯静态站点)推送到该仓库
  3) 开启 GitHub Pages（从 main 分支根目录）
  4) 输出公网地址  https://<用户名>.github.io/<仓库名>/
.PARAMETER Token
  GitHub Personal Access Token（需具备 repo 权限，fine-grained 或 classic 均可）。
.PARAMETER RepoName
  仓库名，默认 pep-math-coach
.PARAMETER UserName
  GitHub 用户名（不填则自动从 Token 查询）
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File deploy.ps1 -Token ghp_xxxxxxxxx
#>
param(
  [Parameter(Mandatory=$true)][string]$Token,
  [string]$RepoName = "pep-math-coach",
  [string]$UserName = ""
)

$ErrorActionPreference = "Stop"
$api = "https://api.github.com"

# 若未提供用户名，用 Token 查询
if (-not $UserName) {
  $me = Invoke-RestMethod -Uri "$api/user" -Headers @{Authorization="Bearer $Token"}
  $UserName = $me.login
}
Write-Host "GitHub 账号: $UserName" -ForegroundColor Cyan

# 1) 新建仓库（若已存在则忽略）
$body = @{ name=$RepoName; description="小学应用题系统整理 · 人教版同步教练 + 240 奥数专题（开源衍生）"; homepage=""; private=$false } | ConvertTo-Json
try {
  Invoke-RestMethod -Uri "$api/user/repos" -Method Post -Headers @{Authorization="Bearer $Token"; "Content-Type"="application/json"} -Body $body | Out-Null
  Write-Host "已创建仓库 $RepoName" -ForegroundColor Green
} catch {
  if ($_.Exception.Response.StatusCode -eq 422) {
    Write-Host "仓库已存在，继续..." -ForegroundColor Yellow
  } else { throw }
}

# 2) 本地 git 初始化并推送
Set-Location $PSScriptRoot
if (-not (Test-Path .git)) { git init -q }
git add -A
git commit -q -m "deploy: 小学数学学习系统静态站" 2>$null
$remote = "https://$UserName`:$Token@github.com/$UserName/$RepoName.git"
# 若 remote 已存在则更新
if (git remote | Select-String -Quiet origin) { git remote set-url origin $remote } else { git remote add origin $remote }
git branch -M main
git push -q -f origin main
Write-Host "已推送到 main 分支" -ForegroundColor Green

# 3) 开启 GitHub Pages（source: branch main, / root）
$pagesBody = @{ source=@{ branch="main"; path="/" } } | ConvertTo-Json
$pagesUrl = "$api/repos/$UserName/$RepoName/pages"
try {
  Invoke-RestMethod -Uri $pagesUrl -Method Post -Headers @{Authorization="Bearer $Token"; "Content-Type"="application/json"} -Body $pagesBody | Out-Null
} catch {
  # 已经开启则更新
  try { Invoke-RestMethod -Uri $pagesUrl -Method Put -Headers @{Authorization="Bearer $Token"; "Content-Type"="application/json"} -Body $pagesBody | Out-Null } catch {}
}
Write-Host "已请求开启 GitHub Pages" -ForegroundColor Green

# 4) 输出地址
$site = "https://$UserName.github.io/$RepoName/"
Write-Host "`n✅ 部署完成！公网地址（通常 1 分钟内生效，最多等 10 分钟）：" -ForegroundColor Green
Write-Host $site -ForegroundColor White
Write-Host "`n如需自定义域名，在仓库 Settings > Pages 里填 CNAME 即可。" -ForegroundColor Gray
