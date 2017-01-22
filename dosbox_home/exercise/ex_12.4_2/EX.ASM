LUNG    EQU             10
        .MODEL small
        .STACK
        .DATA
STRING  DW              1,2,3,4,5,6,7,8,-1,9
STRING_PTR DD           STRING
ERR     DB              "The terminator value -1 has not be found", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        MOV CX, LUNG
        LES DI, STRING_PTR
        MOV AX, -1
        REPNE SCASW
        JE fine
        LEA DX, ERR
        MOV AH, 09H
        INT 21H
fine:   NOP             ; check the result
        .EXIT
        END
