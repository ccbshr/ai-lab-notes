# Git 协作速查（含本机实战踩坑）

> 整理：2026-10-17　环境：Windows 11 + Git 2.56 + Git Bash
> 这份速查里的「坑」全部是**本机真实撞过的**，不是抄来的通用建议。

---

## 一、日常三连

```bash
git status                       # 我在哪个分支、改了什么
git add -A                       # 全部暂存（先确认 .gitignore 有效）
git commit -m "feat: 做了什么事"   # 规范提交信息
git push                         # 上游已设，不用再写 origin xxx
```

## 二、提交信息规范（Conventional Commits）

| 前缀 | 用途 | 例 |
|---|---|---|
| `feat` | 新功能 / 新内容 | `feat(notes): 新增 Linux 命令速查` |
| `fix` | 修 bug | `fix(script): 修正批量重命名的前缀替换` |
| `docs` | 纯文档 | `docs: 补充环境基线` |
| `chore` | 杂务（构建/配置/依赖） | `chore: 统一行尾策略` |
| `refactor` | 重构（不改行为） | `refactor: 抽出公共函数` |
| `test` | 测试相关 | `test: 补 venv 创建用例` |
| `merge` | 合并提交 | `merge: 合并 feature/x 到主线` |

**三条硬规矩**：
1. **一条提交只做一件事**（便于 revert / cherry-pick）；
2. 描述用**祈使句**（"新增"而不是"新增了"），结尾不加句号；
3. 标题不超过 50 字，细节放正文（`git commit -m "标题" -m "正文"`）。

## 三、分支与合并

```bash
git branch feature/x            # 建分支（不切换）
git checkout -b feature/x       # 建并切换（等价 git switch -c）
git branch -vv                  # 看各分支与上游
git merge feature/x             # 合并（能快进就快进）
git merge --no-ff feature/x     # 强制生成合并节点 ← 交付要求里"清晰的提交树"就靠它
git branch -d feature/x         # 合并后删除
```

**`--no-ff` 的意义**：即使能快进，也保留一个 merge 提交，让历史图里看得见"这条分支曾经存在、什么时候合回去的"。评审看 `git log --graph` 时一眼就能识别。

## 四、冲突解决三步

```bash
git merge feature/x             # 预期冲突：CONFLICT ...
git status --short              # 看状态：UU=双方都改、AA=双方都新建、DU/UD=一方删除
cat 冲突文件                     # 看到 <<<<<<< ======= >>>>>>> 标记

# ① 编辑文件：删掉三行标记，留下想要的内容
# ② 标记为已解决
git add 冲突文件
# ③ 提交（merge 状态下 git commit 不需要 -m，会自动带合并信息）
git commit
```

**必记**：解决完**必须 `git add` + `git commit`**，否则一直在 MERGING 状态，后续命令全报 `You have not concluded your merge`。

想放弃这次合并：`git merge --abort`。

## 五、远程交互

```bash
git remote add origin git@github.com:USER/REPO.git   # 关联（占位符别写 <尖括号>！）
git remote -v                                        # 确认
git ls-remote origin                                 # 只读验证连通性，不改本地
git push -u origin HEAD:feature/x                    # 首推并建立上游跟踪
git pull                                             # 拉取并合并
git clone git@github.com:USER/REPO.git               # 换机器
```

## 六、本机真实踩过的四个坑

### 坑 1：占位符写尖括号被 shell 吃掉

```bash
git remote add origin https://github.com/<你的账号>/<仓库>.git
# → bash: 你的账号: No such file or directory
```

`<` `>` 是**重定向符号**。改用 `USER/REPO` 这种占位符，或整体加引号。

### 坑 2：本地分支名与上游名不一致，push 被拒

```text
fatal: The upstream branch of your current branch does not match the name of your current branch
```

`push.default=simple` 不允许"本地 main 推到远程 other-name"。两种解法：

```bash
git branch -m main 目标分支名      # ① 改名对齐（推荐，一劳永逸）
git push origin HEAD:目标分支名    # ② 一次性显式指定
```

### 坑 3：两条无关历史无法直接推

本地 2 个提交、远程 main 已有 23 个提交，**没有共同祖先** → `push` 报 `non-fast-forward`。
正确做法（按意图选一）：

```bash
git push origin HEAD:新分支名                       # ① 推新分支，走 PR（最安全）
git pull --allow-unrelated-histories origin/main    # ② 强行合并两套历史，再推
```

别用 `--force` 覆盖别人分支 —— 会丢掉队友的提交。

### 坑 4：`.sh` 被 checkout 成 CRLF，在 WSL 里报 `$'\r'`

Windows 上 `core.autocrlf=true`，克隆出来的 `.sh` 是 CRLF，拿到 Linux/WSL 执行就炸。用 `.gitattributes` 从根上解决：

```gitattributes
* text=auto eol=lf
*.sh text eol=lf
*.bat text eol=crlf
*.docx binary
*.png binary
```

## 七、动手前的安全检查

| 检查 | 命令 | 看什么 |
|---|---|---|
| 我在哪个仓库根 | `git rev-parse --show-toplevel` | 别在 `~` 里 init |
| 会不会提交垃圾 | `git status --short` | 有 `preview-*/`、`__pycache__/` 就先补 `.gitignore` |
| 有没有夹带密钥 | `git diff --cached \| grep -iE 'key\|token\|password'` | 有就先撤销 |
| 要推的分支对不对 | `git branch -vv` | 看上游是谁 |

## 八、撤销与补救

| 想干的事 | 命令 |
|---|---|
| 撤销工作区改动 | `git restore 文件` |
| 取消暂存 | `git restore --staged 文件` |
| 改最后一条提交信息 | `git commit --amend -m "新信息"`（**已推送要谨慎**） |
| 撤销最后一次提交但保留改动 | `git reset --soft HEAD~1` |
| 查看某次提交改了什么 | `git show <hash>` |
| 找回被删的分支 | `git reflog` |
