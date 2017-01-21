DIM     EQU         5        
        .MODEL small
        .STACK
        .DATA
VECTOR  DW          5, 7, 3, 4, 3
RESULT  DW          ?
        .CODE
        .STARTUP
        MOV AX, 0
        MOV CX, DIM
        MOV DI, 0
lab:    ADD AX, VECTOR[DI]
        ADD DI, 2
        DEC CX
        CMP CX, 0
        JNZ lab
        MOV RESULT, AX
        .EXIT
        END
