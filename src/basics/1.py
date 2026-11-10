"""基本类型与转换练习：int / float / str / bool 互转、f-string、真值判断。"""

print(int(1.2))  # 1.2 -> 1（截断，不是四舍五入）
print(int("1"))  # 字符串转整数
print(float(1))  # 1 -> 1.0
print(str(1))  # 1 -> "1"
print(str(1.2))  # 1.2 -> "1.2"
print(type(str(1.2)))
print(type(int("1")))
print(type(float(1)))
name = "ccbshr"
print(f"{name}")
a = 0 > 1  # noqa: PLR0133  故意用常量比较演示 bool 结果
print(bool(a))  # False
