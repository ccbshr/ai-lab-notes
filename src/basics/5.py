"""while 嵌套循环：打印九九乘法表（对应 4.py 的 for 版本，输出完全一致）。

修复点：
1. 原代码把 j += 1 写在 print 之前，导致每行从 2 开始、且少了 j == n 那一项
2. 乘数顺序改为与 4.py 一致（n * j 而非 j * n）
"""

n = 1
while n <= 9:
    j = 1
    while j <= n:
        print(f"{n} * {j} = {n * j}\t", end="")
        j += 1
    print()
    n += 1
