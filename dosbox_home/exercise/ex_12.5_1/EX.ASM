LUNG    EQU             100
        .MODEL small
        .STACK
        .DATA
STRING  DB              LUNG DUP(?), 0DH, 0AH, "$"
STRING_PTR DD           STRING
        .CODE
        .STARTUP
        LES DI, STRING_PTR
        MOV AL, " "
        MOV CX, LUNG
        CLD
        REP STOSB
        LEA DX, STRING
        MOV AH, 09H
        INT 21H
        .EXIT
        END
