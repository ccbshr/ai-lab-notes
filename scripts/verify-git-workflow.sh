#!/usr/bin/env bash
# 验证「feature 分支开发 + --no-ff 合并回主线」的完整工作流，并自动断言结果。
# 用法：bash verify-git-workflow.sh
# 特点：全程在临时目录里做，不碰任何真实仓库。
set -uo pipefail

T="$(mktemp -d)/workflow-demo"
mkdir -p "$T"
cd "$T" || exit 1

# 仓库内身份（不污染全局）
git init -q -b main
git config user.name  "AI-Lab Trainee"
git config user.email "trainee@example.com"

echo "=== 1) main 上先做 2 次规范语义提交 ==="
printf '# Workflow Demo\n\n用于验证分支合并流程。\n' > README.md
git add README.md
git commit -q -m "docs: 初始化 README"

printf 'line 1\n' > notes.md
git add notes.md
git commit -q -m "docs: 添加 notes.md"

echo "=== 2) 建 feature 分支，做 2 次提交 ==="
git checkout -q -b feature/report
printf '# 报告草稿\n\n- 结论待补充\n' > report.md
git add report.md
git commit -q -m "feat(report): 新增报告草稿"

printf '\n## 结论\n\n数据支持原假设。\n' >> report.md
git add report.md
git commit -q -m "feat(report): 补充结论"

echo "=== 3) 合并回 main（--no-ff 强制生成合并节点）==="
git checkout -q main
git merge -q --no-ff feature/report -m "merge: 合并 feature/report 到 main"

echo
echo "=== 4) 提交树 ==="
git log --oneline --graph --all

echo
echo "=== 5) 断言 ==="
total=$(git rev-list --count HEAD)
merges=$(git rev-list --merges --count HEAD)
echo "  主干提交总数 : $total   （要求 >= 5）"
echo "  合并提交数量 : $merges  （要求 >= 1）"

status=0
[ "$total" -ge 5 ]  || { echo "  ❌ 提交数不足 5"; status=1; }
[ "$merges" -ge 1 ] || { echo "  ❌ 没有合并提交（是否漏了 --no-ff？）"; status=1; }
git rev-parse --verify -q feature/report >/dev/null && echo "  ✅ feature 分支存在"
git log --merges --format='  ✅ merge commit: %h %s' -1

cd / && rm -rf "$(dirname "$T")"
echo
if [ "$status" -eq 0 ]; then echo "RESULT: PASS"; else echo "RESULT: FAIL"; fi
exit "$status"
