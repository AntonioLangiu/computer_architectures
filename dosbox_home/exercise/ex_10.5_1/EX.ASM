        .MODEL small
        .DATA
NUM     DW          225
SQR     DW          ?
        .CODE
        .STARTUP
        MOV AX, NUM     ; use AX as partial result
        MOV BX, 1       ; use BX as odd number accumulator
        MOV SI, -1
ciclo:  SUB AX, BX
        INC SI
        ADD BX, 2
        CMP AX, 0
        JGE ciclo
        MOV SQR, SI
        NOP             ; check the result, SQR should be 15
        .EXIT
        END
