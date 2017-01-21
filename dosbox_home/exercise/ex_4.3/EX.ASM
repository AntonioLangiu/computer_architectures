        .MODEL small
        .STACK
        .DATA
VECTOR  DW          5, 7, 3, 4, 3
RESULT  DW          ?
        .CODE
        .STARTUP
        MOV AX, VECTOR
        ADD AX, VECTOR+2
        ADD AX, VECTOR+4
        ADD AX, VECTOR+6
        ADD AX, VECTOR+8
        MOV RESULT, AX
        .EXIT
        END
