code segment
    assume cs:code
start:
    MOV AX, 0F34CH
    CALL MULT
    mov ah,4ch
    int 21h

; 原码一位乘子程序
MULT:
    ;AL: 输入：被乘数，输出：结果低位
    ;AH: 输入：乘数，输出：结果高位
    PUSH BX ;保护BH和BL
    MOV BH, 1 ;循环次数，通过循环右移实现
    MOV BL, 0 ;结果高位
PANDUAN:
    TEST AH, 1 ;乘数当前位是否为1
    JLE XUNHUAN
    ADD BL, AL ;加上被乘数
XUNHUAN:
    RCR BL, 1 ;带进位的循环右移
    RCR AH, 1 ;带进位的循环右移
    ROR BH, 1 ;循环右移
    TEST BH, 1 ;循环是否终止
    JLE PANDUAN
    MOV AL, AH
    MOV AH, BL
    POP BX ;返回BH和BL
    RET

code ends
    end start
