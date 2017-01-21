        .MODEL small
        .STACK
        .DATA
OPD1    DW      10
OPD2	DW	24
RESULT  DW      ?
        .CODE
        .STARTUP
        MOV AX, OPD1
        ADD AX, OPD2
        MOV RESULT, AX
        .EXIT
        END
