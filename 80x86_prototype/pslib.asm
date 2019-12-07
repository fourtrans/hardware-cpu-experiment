;Pseudo-Stack-marco-LIBrary .mac
DATA SEGMENT
    PS_BUF DB 16 DUP(0)
    PS_TOP DB PS_BUF
    PS_TMP DB 0
DATA ENDS

MY_PUSH_AL marco
    mov [PS_TOP], al
    add PS_TOP, 1
ENDM

MY_PUSH_AH marco
    mov [PS_TOP], ah
    add PS_TOP, 1
ENDM

MY_PUSH_BL marco
    mov [PS_TOP], bl
    add PS_TOP, 1
ENDM

MY_PUSH_BH marco
    mov [PS_TOP], bh
    add PS_TOP, 1
ENDM

MY_PUSH_IP marco
    LOCAL END_PUSH_IP
    mov [PS_TOP], END_PUSH_IP
    add [PS_TOP], 2
    add PS_TOP, 2     ; 2 byte for ip
    END_PUSH_IP:
ENDM

MY_POP_AL marco
    sub PS_TOP, 1
    mov al, [PS_TOP]
ENDM

MY_POP_AH marco
    sub PS_TOP, 1
    mov ah, [PS_TOP]
ENDM

MY_POP_BL marco
    sub PS_TOP, 1
    mov bl, [PS_TOP]
ENDM

MY_POP_BH marco
    sub PS_TOP, 1
    mov bh, [PS_TOP]
ENDM

MY_POP_IP marco
    sub PS_TOP, 2
    mov ip, [PS_TOP]
ENDM

MY_PUSH marco reg
    MY_PUSH_&reg
ENDM

MY_POP marco reg
    MY_POP_&reg
ENDM