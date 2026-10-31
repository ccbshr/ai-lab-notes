# Git 踩坑记录

| 现象 | 根因 | 解决 |
|---|---|---|
| `syntax error near unexpected token '('` | 提交信息里的括号未加引号，被 shell 当成元字符 | `git commit -m "feat(x): …"` 整串加引号 |
| `pathspec '…' did not match any file(s)` | `git commit` 漏了 `-m`，参数被当成文件路径 | 补上 `-m` |
| `remote origin already exists` | 重复 `add`，`origin` 已存在 | 改地址用 `git remote set-url` |
| `upstream branch does not match` | 本地分支名与远程分支名不同 | `git branch -m 新名` 或 `git push origin HEAD:目标名` |
