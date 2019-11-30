DATA SEGMENT
    ;used in main
    X0 DB 97
    ;used in LCG proc
    A DB 17
    C DB 13
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
    mov ax, DATA
    mov ds, ax
    mov al, X0
    push ax
MAIN_LOOP:
    pop ax
    call OUTPUT
    call LCG    
    push ax
    mov ah, 07h
    int 21h
    cmp al, 65h     ;接收一个键盘字符，如果是 'e' 就结束
    jnz MAIN_LOOP
    pop ax
    mov ax, 4c00h
    int 21h

; 获取下一个数
; 输入 AL
; 过程 AL <- (AH * AL + C) % MODULE
; 输出 AL
LCG PROC NEAR
    mov ah, A
    call MULTI
    add al, C
    mov ah, MODULE
    and al, ah
    ret
LCG ENDP

; MULTI MOCK
; 输入 AL, AH
; 过程 AL <- AL*AH
; 输出 AL
MULTI PROC NEAR
    mul ah
    ret
MULTI ENDP

; 用于输出AL中的内容
; 整个此处子程序算作20行
; 输入 AL需要输出的值
; 过程 None
; 输出 None
OUTPUT PROC NEAR
    push dx
    push ax
    push ax
    xor bx,bx
    and al,0f0h
    ror al,1
    ror al,1
    ror al,1
    ror al,1
    mov bl,al
    mov dl,[CHAR_TBL][bx]
    mov ah, 2h
    int 21h
    pop ax
    and al,0fh
    mov bl,al
    mov dl,[CHAR_TBL][bx]
    mov ah, 2h
    int 21h
    mov dl, 20h
    mov ah, 2h
    int 21h
    pop ax
    pop dx
    ret
OUTPUT ENDP

CODE ENDS
    END START