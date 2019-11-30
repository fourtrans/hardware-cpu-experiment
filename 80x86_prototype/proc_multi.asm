; 乘法指令汇编模拟
; 输入 AL, AH
; 过程 AL <- AL*AH
; 输出 AL
MULTI PROC NEAR
    PUSH BX
    MOV BH, 8 ;循环次数
    MOV BL, 0
PANDUAN:
    ROL AH, 1
    SHL BL, 1
    TEST AH, 1 ;乘数当前位是否为1
    JZ XUNHUAN
    ADD BL, AL ;加上被乘数
XUNHUAN:
    SUB BH, 1
    JNZ PANDUAN
    MOV AL, BL ;AL存放结果
    MOV AH, BH ;AH结果一定为零
    POP BX
    RET
MULTI ENDP