;This file is DISCARDED

DATA SEGMENT
    A DB 17
    C DB 13
    MODULE DB 128
DATA ENDS

; 获取下一个数
; 输入 AL
; 过程 AL <- (A * AL + C) % MODULE
; 输出 AL
LCG PROC NEAR
    mov ah, A
    call MULTI
    add al, C
    and al, 7fh
    ret
LCG ENDP

; MULTI MOCK
; 输入 AL, AH
; 过程 AL <- AL*AH
; 输出 AL
MULTI PROC NEAR
    mul al
    ret
MULTI ENDP