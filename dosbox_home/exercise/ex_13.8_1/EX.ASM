LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
VETT    DW          LUNG DUP(10000) ; this will produce an overflow
ERR     DB          "The sum didn't succed", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        LEA AX, VETT
        MOV BX, LUNG
        PUSH AX
        PUSH BX
        CALL SUM
        POP BX
        POP AX      ; this is the result
        JNC fine    ; if carry flag is 1 then the procedure had an error
        LEA DX, ERR
        MOV AH, 09H
        INT 21H
fine:   NOP
        .EXIT
SUM     PROC
        MOV BP, SP
        PUSH AX
        PUSH CX
        PUSH BX
        MOV CX, [BP+2]
        MOV BX, [BP+4]
        XOR AX, AX
ciclo:  ADD AX, [BX]
        JC overf
        ADD SI, 2
        LOOP ciclo
        MOV [BP+6], AX
        JMP ok
overf:  STC
ok:     NOP
        POP BX
        POP CX
        POP AX
        RET
SUM     ENDP
        END
