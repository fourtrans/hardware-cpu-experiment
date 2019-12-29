DATA SEGMENT
    ;used in main
    lcg_X0 DB 97
    ;used in LCG proc
    lcg_A DB 17
    lcg_C DB 13
    MODULE DB 7FH
    ;used in MULTI proc
    
    ;used in OUTPUT proc
    OUTPUT_PORT DB 88 ; 只是占位
    ;pesudo-aera 此部分数据只在 x86 原型中使用，不需要计入数据量
    CHAR_TBL DB '0123456789ABCDEF'
DATA ENDS

CODE SEGMENT
    assume cs:CODE, ds:DATA
    
START:
    mov ax, DATA                    ;x86 only
    mov ds, ax                      ;x86 only
    mov al, lcg_X0
MAIN_LOOP:
    ;call LCG   
        mov ah, lcg_A
        ;call MULTI
            push bx
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
            pop bh
        
        add al, lcg_C
        mov ah, MODULE
        and al, ah
    
    ;>>>>>>>TODO: delay in tangdu
    mov ah, 07h                                              ;x86 only
    int 21h                                                  ;x86 only
    cmp al, 65h     ;接收一个键盘字符，如果是 'e' 就结束     ;x86 only
    jnz MAIN_LOOP                                    ;x86 only    
    pop ax                                                   ;x86 only
    mov ax, 4c00h                                            ;x86 only
    int 21h                                                  ;x86 only

CODE ENDS
    END START