# 硬件综合实验 CPU设计
基于唐都仪器实验箱设计

# 硬件条件限制
- 没有原生堆栈
- 没有循环，只有两种条件跳转指令:
> JMP 无条件跳转指令  
> BZC ZF或CF为1时跳转，即当<=0时跳转<和=无法拆开
>> 可以用其他方式判断是否=0，比如先用异或再用BZC

# Authors
[oowsxq](https://github.com/oowsxq)
[CSGlobalOffensive](https://github.com/CSGlobalOffensive)
