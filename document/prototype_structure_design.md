# 汇编级结构设计
此文档对应 $root/80x86_prototype/

## 设计原则
由于 x86 汇编程序只作为原型使用，之后需要转移到唐都试验箱上使用。考虑到向后迁移的需求，
在原型设计中我们有一些限制规则。
1. 由于存储器只有 256B，所以程序编写在满足可读性需求基础上尽可能精简。
2. 只允许使用部分指令
3. 不允许使用乘除指令，使用子程序模拟实现
4. 不允许直接使用堆栈相关指令，使用模拟指令实现


**允许使用的指令一览表**  
|编号|指令|补充说明|
|:-:|:-|:-|
|1|MOV||
|2|ADD||
|3|SUB||
|4|AND||
|5|OR||

|编号|指令|补充说明|
|:-:|:-|:-|
|1|JLE|相当于试验箱中BZC|
|2|JMP|无条件跳转|

|编号|指令|补充说明|
|:-:|:-|:-|
|1|ROR|右环移，第一选择，能选它就选它|
|2|SHL|逻辑左移|
|3|SHR|逻辑右移|
|4|RCL|带进位循环左移|
|5|RCR|带进位循环右移|


另外关于程序量的限制：
> 标签算一行。预期所有代码行总和小于128行，最多不能超过180行。
> 每行代码计作 1 byte，
> 数据段按照数据量计算，
> 总计数据量应当小于 220 byte
## LCG算法
核心递推公式  
$$x_{n+1}=(a \cdot x_n + c)\ \%\ module$$
其中初始状态为：

> $x_0=97$
  
在 8bit 的运行环境下常数部分取值为：  

> $a=17$  
> $c=13$  
> $module=128$  

## 程序结构
|程序|功能|
|:-:|:-|
|main|程序入口，存在一个主循环，不断调用其他部分|
|... 各种子程序 ...|_参见下文接口设计部分_|
|... 各种宏操作 ...|_参见下文接口设计部分_|


## 模拟堆栈
本程序为了适应后续迁移需要，限制不适用 x86 自带的堆栈相关操作。故手动实现了堆栈。其中关键数据结构如下。
|数据结构|作用|
|:-|:-|
|PS_BUF|存放堆栈数据的缓冲区基地址|
|PS_TOP|栈顶指针，总是指向下一个空位置|
|PS_TMP|用于弹栈操作的临时区|

TODO:FIX NOTE

**NOTE:**  `PS_TMP` 用在需要操作IP的时候。弹栈时要先将内容装入临时区，再调整栈顶指针，再将临时区移动到IP中。

## 接口设计（子程序）

### MULTI 子程序
由于我们的 CPU 指令设计中没有乘法指令，故编写一段子程序进行乘法计算
|||
|:-|:-|
|**Input**|被乘数 `AL`, 乘数 `AH`|
|**Process**|`AL` <- `AL` * `AH`|
|**Output**|乘积 `AL`|


### LCG 子程序
此子程序用于获取下一个随机数的值
|||
|:-|:-|
|**Input**|`AL` 中是当前的值，即 $x_{n}$|
|**Process**|`AL` <- ( _A_ * `AL` + _C_ ) % _MODULE_ |
|**Output**|`AL` 更新为下一个值|


### OUPUT 子程序
用于输出AL中的内容
|||
|:-|:-|
|**Input**|`AL` 需要输出的值|
|**Process**|None|
|**Output**|None|

## 接口设计（宏操作）

<!-- ### MY_PUSH_OPR 宏操作
Pseudo Stack Push Operation 模拟栈的压栈操作
|||
|:-|:-|
|**Input**|`PS_TARGET` 需要压栈的寄存器编号|
|**Process**|first `(PS_TOP)` <- `Register` then `PS_TOP` <- `PS_TOP + 1` |
|**Output**|None|

寄存器编号表:
|Number|Register|
|:-|:-:|
|1|`AL`|
|2|`AH`|
|3|`BL`|
|4|`BH`|
|5|`CS`|
|6|`IP`|

### MY_POP_OPR 宏操作
Pseudo Stack Pop Operation 模拟栈的弹栈操作
|||
|:-|:-|
|**Input**|`PS_TARGET` 需要弹栈的寄存器编号|
|**Process**| _first_ `PS_TMP` <- `(PS_TOP)` _then_ `PS_TOP` <- `PS_TOP - 1` _then_ `Register` <- `PS_TMP` |
|**Output**|None|

弹栈操作中之所以要先减栈顶指针再移出数据是为了 -->

### MY_PUSH_AL
|||
|:-|:-|
|**Input**|None|
|**Process**|first `(PS_TOP)` <- `AL` then `PS_TOP` <- `PS_TOP + 1` |
|**Output**|None|

### MY_PUSH_AH
|||
|:-|:-|
|**Input**|None|
|**Process**|first `(PS_TOP)` <- `AH` then `PS_TOP` <- `PS_TOP + 1` |
|**Output**|None|

### MY_PUSH_BL
|||
|:-|:-|
|**Input**|None|
|**Process**|first `(PS_TOP)` <- `BL` then `PS_TOP` <- `PS_TOP + 1` |
|**Output**|None|

### MY_PUSH_BH
|||
|:-|:-|
|**Input**|None|
|**Process**|first `(PS_TOP)` <- `BH` then `PS_TOP` <- `PS_TOP + 1` |
|**Output**|None|

<!-- ### MY_PUSH_IP
IP入栈比较复杂，需要先将当前IP插入栈内，再加上一个偏移量（因为手动实现的栈操作不止一条指令），然后再给栈指针加1。
|||
|:-|:-|
|**Input**|None|
|**Process**|first `(PS_TOP)` <- `IP` then `(PS_TOP)` <- `(PS_TOP) + <offset>` then `PS_TOP` <- `PS_TOP + 2` |
|**Output**|None|
**NOTE:** 因为使用 80x86 环境模拟，ip操作需要 2 bytes。
**NOTE:** 实际 80x86 模拟的时候使用LOCAL伪操作直接获取结束地址，而非 `+<offset>`。 -->

### MY_POP_AL
|||
|:-|:-|
|**Input**|None|
|**Process**| _first_ `PS_TOP` <- `PS_TOP - 1` _then_ `AL` <- `(PS_TOP)`|
|**Output**|None|

### MY_POP_AH
|||
|:-|:-|
|**Input**|None|
|**Process**| _first_ `PS_TOP` <- `PS_TOP - 1` _then_ `AH` <- `(PS_TOP)`|
|**Output**|None|

### MY_POP_BL
|||
|:-|:-|
|**Input**|None|
|**Process**| _first_ `PS_TOP` <- `PS_TOP - 1` _then_ `BL` <- `(PS_TOP)`|
|**Output**|None|

### MY_POP_BH
|||
|:-|:-|
|**Input**|None|
|**Process**| _first_ `PS_TOP` <- `PS_TOP - 1` _then_ `BH` <- `(PS_TOP)`|
|**Output**|None|

<!-- ### MY_POP_IP
|||
|:-|:-|
|**Input**|None|
|**Process**| _first_ `PS_TOP` <- `PS_TOP - 2` _then_ `IP` <- `(PS_TOP)` |
|**Output**|None|
**NOTE:** 因为使用 80x86 环境模拟，ip操作需要 2 bytes。 -->

### MY_PUSH 宏操作
|||
|:-|:-|
|**Format**|`MY_PUSH <reg>`|
|**Function**|将指定的寄存器压栈|
是对 `MY_PUSH_<Reg>` 的一个简单包装

### MY_POP 宏操作
|||
|:-|:-|
|**Format**|`MY_POP <reg>`|
|**Function**|弹栈存入指定的寄存器|
是对 `MY_POP_<Reg>` 的一个简单包装

<!-- ### MY_NEAR_RET 宏操作
|||
|:-|:-|
|**Format**|`MY_NEAR_RET`|
|**Function**|弹栈IP，在段内提供和 RET 相同的功能|

### MY_NEAR_CALL 宏操作
|||
|:-|:-|
|**Format**|`MY_NEAR_CALL <proc>`|
|**Function**|将当前 IP+1 压栈，保存下一条指令的位置，然后 jmp proc，在段内实现和 CALL 相同的功能| -->
