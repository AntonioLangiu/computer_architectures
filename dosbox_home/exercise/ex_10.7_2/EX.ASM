FR      EQU             297
        .MODEL small
        .STACK
        .DATA
FRANCS  DW              10000
LIRA    DW              ?
ERR     DB              "The conversion is not possible, an overflow happened", 0DH, 0AH, "$"
OK      DB              "The conversion is possible, no overflow happened", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        MOV AX, FRANCS
        MOV BX, FR
        MUL BX
        JNC valid
        LEA DX, ERR
        JMP exit
valid:  MOV LIRA, AX
        LEA DX, OK
exit:   MOV AH, 09H
        INT 21H
        .EXIT
        END
