"""列表常用操作：增（append / extend）、删（pop / del）、查（index）。"""

list1 = [21, 25, 21, 23, 22, 20]
list1.append(31)
print(list1)  # 尾部追加 31

list2 = [29, 33, 30]
list1.extend(list2)
print(list1)  # 合并 list2 的全部元素

list1.pop(0)
print(list1)  # 删除索引 0（值为 21）

del list1[-1]
print(list1)  # 删除最后一个（值为 30）

print(list1.index(31))  # 修复点：原代码没 print，返回值被丢弃；此处应输出 5
