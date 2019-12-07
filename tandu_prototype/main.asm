
DATA SEGMENT
    multiplier db ? ;被乘数
DATA ENDS

CODE BEGIN
    LDI R1, 61H             ;初始化 X0
MAINLOOP:
    OUT 40H, R1             ;输出

    LDI R0, 11H             ; LCG_A = 17        
    STA 00 multiplier, R0   ;写入被乘数
    
    ;MULTI (A*X)
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
    
    LDI R0, 0DH ;C=13
    ADD R1, R0  ;(...) + C 新的迭代值在 R1 中
    
    ;DELAY
    LDI R0, 0       ;当前计数
    LDI R2, 1       ;累加数
    LDI R3, 100     ;最大计数 DELAY_CYCLE
    DELAY:
        ADD R0, R2
        CMP R0, R3
        BZC 00 DELAY
    JMP 00 MAINLOOP
CODE ENDS