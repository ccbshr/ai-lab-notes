"""条件判断练习：年龄满 18 或身高超过 180 视为 adult，否则 child。

修复点：
1. 变量名拼写错误 hight -> height
2. 输入时就转成 int，避免每处都 int() 一次
3. 加输入提示，运行时不至于对着光标发呆
4. 两个分支做的事完全相同，按 ruff SIM114 合并为 or 条件
"""

height = int(input("请输入身高（cm）："))
age = int(input("请输入年龄："))

if age >= 18 or height > 180:
    print("adult")
else:
    print("child")
