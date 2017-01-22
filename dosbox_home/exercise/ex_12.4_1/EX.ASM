LUNG    EQU         13
        .MODEL small
        .STACK
        .DATA
STRING  DB          "     prova", 0DH, 0AH, "$"
STR_PTR DD          STRING
        .CODE
        .STARTUP
        MOV AL, " "
        MOV CX, LUNG
        LES DI, STR_PTR
        CLD
        REPE SCASB
        JE fine
        DEC DI
        MOV DL, [DI]
        MOV AH, 02H
        INT 21H
fine:   NOP             ; check the final value, it should print p
        .EXIT
        END
