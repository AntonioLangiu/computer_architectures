LUNG    EQU             96
        .MODEL small
        .STACK
        .DATA
STRING  DB              "make "
PT      EQU             $-STRING
        DB              LUNG DUP (?) , "$"
        .CODE
        .STARTUP
        PUSH DS
        POP ES
        LEA SI, STRING
        LEA DI, STRING + PT
        MOV CX, LUNG
        CLD
        REP MOVSB
        MOV AH, 09H
        LEA DX, STRING
        INT 21H
        ; I don't need to restore the ES because 
        ; it's not setted in this exercise
        .EXIT
        END
