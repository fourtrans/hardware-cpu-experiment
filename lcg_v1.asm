#include <stdix>

DATA SEGMENT
    lcg_a 17
    lcg_c 13
    multiplier 00
DATA ENDS

CODE SEGMENT
    ldi_seq 0 97 0 0                ; 初始化寄存器
                                    ; 全局中 r1 放置迭代值 X
    mainloop:
        out 40h r1                  ; 输出

        lad 00 r0, lcg_a            ; 载入常数 a
        sta 00 multiplier, r0       ; 写入被乘数

        @call multi                 ; 执行乘法子程序

        lad 00 r0, lcg_c            ; 载入常数 c
        add1 r1, r0                 ; 迭代得到新的值在 r1 中

        @call delay                 ; 延时

        jmp 00 mainloop             ; 主循环

delay:
    ldi r0, 0
    ldi r2, 1
    ldi r3, 100
    add1 r0, r2
    cmp r0, r3
    bzc 00 delay
    @ret

multi:
    @push r0
    @push r2
    @push r3
    ldi r3, 1;循环次数，通过循环右移实现
    ldi r2, 0;结果高位
    panduan:
        ldi r0, 1
        test r1, r0;乘数当前位是否为1
        bzc 00 xunhuan
        lad 00 r0, multiplier
        add1 r2, r0;加上被乘数
    xunhuan:
        rcr r2, r2;带进位的循环右移
        rcr r1, r1;带进位的循环右移
        ror r3, r3, 1;循环右移
        ldi r0, 1
        test r3, r0;循环是否终止
        bzc 00 panduan
    @pop r3
    @pop r2
    @pop r0
    @ret

CODE ENDS

ldi_seq macro value1 value2 value3 value4
    ldi r0, value1
    ldi r1, value2
    ldi r2, value3
    ldi r3, value4
endm
; 55 non-empty lines in total