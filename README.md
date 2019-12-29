# Project Dunny (硬件综合实验)
基于唐都仪器实验箱设计。  
Our instruction set named as _**`dunny`**_.

# 硬件条件限制
- 没有原生堆栈
- 没有循环，只有两种条件跳转指令:
> JMP 无条件跳转指令  
> BZC ZF或CF为1时跳转，即当<=0时跳转<和=无法拆开  
- 16 条指令限制  
- 4 个 8bit 通用寄存器，其中一个是变址寄存器  
- 支持直接寻址、间接寻址、相对寻址、变址寻址，但仅允许四条指令进行操作数准备  
- 16个固定的 ALU 功能

# Authors
[oowsxq](https://github.com/oowsxq)  
[CSGlobalOffensive](https://github.com/CSGlobalOffensive)
