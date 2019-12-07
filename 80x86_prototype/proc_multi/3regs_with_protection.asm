data segment
    multiplier db ? ;被乘数
data ends

code segment
    assume cs:code
start:
    MOV AX, data
    MOV DS, AX
    MOV AX, 0FFFFH
    CALL MULT
    MOV AH, 4CH
    INT 21H

; 原码一位乘子程序
MULT:
    ;内存multiplier：输入被乘数
    ;AL: 自由的寄存器
    ;AH: 输入：乘数，输出：结果低位
    MOV BH, 1 ;循环次数，通过循环右移实现
    MOV BL, 0 ;结果高位
PANDUAN:
    TEST AH, 1 ;乘数当前位是否为1
    JLE XUNHUAN
    MOV AL, BYTE PTR [multiplier]
    ADD BL, AL ;加上被乘数
XUNHUAN:
    RCR BL, 1 ;带进位的循环右移
    RCR AH, 1 ;带进位的循环右移
    ROR BH, 1 ;循环右移
    TEST BH, 1 ;循环是否终止
    JLE PANDUAN
    RET

code ends
    end start


; 唐都版本
MULT:
    ;内存multiplier：输入被乘数
    ;R0: 自由的寄存器
    ;R1: 输入：乘数，输出：结果低位
    ;R2、R3：均会被用到
    LDI R3, 1 ;循环次数，通过循环右移实现
    LDI R2, 0 ;结果高位
PANDUAN:
    LDI R0, 1
    TEST R1, R0 ;乘数当前位是否为1
    BZC XUNHUAN
    LAD R0, multiplier
    ADD R2, R0 ;加上被乘数
XUNHUAN:
    RCR R2 ;带进位的循环右移
    RCR R1 ;带进位的循环右移
    ROR R3, 1 ;循环右移
    LDI R0, 1
    TEST R3, R0 ;循环是否终止
    BZC PANDUAN
    RET
