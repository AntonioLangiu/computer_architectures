LUNG    EQU         80  ; the string max is fixed to 80 chars
EOS     EQU         0DH
DIFF    EQU         "a"-"A"
        .MODEL small
        .STACK
        .DATA
STRING  DB          LUNG DUP(?)
MSG     DB          "Write a string terminated by CR", 0DH, 0AH, "$"
ERR     DB          "String too long", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        MOV AX, LUNG
        LEA BX, STRING
        PUSH AX
        PUSH BX
        CALL LOAD_STR
        POP CX
        POP CX
        JC fine
        PUSH BX
        CALL CONV_MAIU
        POP CX
        PUSH BX     ; this is the address of the string
        CALL VISU_STR
        POP CX
fine:   NOP
        .EXIT
LOAD_STR PROC
        MOV BP, SP
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        ; start the procedure
        MOV BX, [BP+2]    ; this is the address of the string
        MOV CX, [BP+4]    ; this is the number of elements
        LEA DX, MSG
        PUSH DX
        CALL VISU_STR
        POP DX
ciclo:  MOV AH, 01H
        INT 21H
        CMP AL, EOS
        JE ok
        MOV [BX], AL
        INC BX
        LOOP ciclo
        ; if you are here you exited from the cycle but no \n was found
        ; the string is invalid, print the error and exit
        LEA DX, ERR
        PUSH DX
        CALL VISU_STR
        POP CX
        JMP finep
ok:     MOV BYTE PTR [BX], "$"
finep:  ; end the procedure
        POP DX
        POP CX
        POP BX
        POP AX
        RET
LOAD_STR ENDP

CONV_MAIU PROC
        MOV BP, SP
        PUSH BX
        MOV BX, [BP+2]    ; this is the address of the string
ciclo2: CMP BYTE PTR [BX], "a"
        JL next
        CMP BYTE PTR [BX], "z"
        JG next
        SUB BYTE PTR [BX], DIFF
next:   CMP BYTE PTR [BX], EOS
        JE esci2
        INC BX
        JMP ciclo2
esci2:  ; end of the procedure       
        POP BX
        RET
CONV_MAIU ENDP

VISU_STR PROC
        MOV BP, SP
        PUSH DX
        PUSH AX
        MOV DX, [BP+2]
        MOV AH, 09H
        INT 21H
        POP AX
        POP DX
        RET
VISU_STR ENDP
        END
