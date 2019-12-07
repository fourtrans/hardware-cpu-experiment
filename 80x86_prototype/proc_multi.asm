; 乘法指令汇编模拟
; 输入 AL, AH
; 过程 AL <- AL*AH
; 输出 AL
MULTI PROC NEAR
    PUSH BX ;保护BH和BL
    MOV BH, 1 ;循环次数，通过循环右移实现
    MOV BL, 0 ;结果高位
PANDUAN:
    TEST AH, 1 ;乘数当前位是否为1
    JLE XUNHUAN
    ADD BL, AL ;加上被乘数
XUNHUAN:
    ROR BH, 1 ;循环右移
    RCR BL, 1 ;带进位的循环右移
    RCR AH, 1 ;带进位的循环右移
    TEST BH, 1 ;循环是否终止
    JLE PANDUAN
    MOV AL, AH
    MOV AH, BL
    POP BX
    RET
MULTI ENDP