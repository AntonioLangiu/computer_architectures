LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
VET1    DW          LUNG DUP(?)
VET2    DW          LUNG DUP(?)
        .CODE
        .STARTUP
        LEA DI, VET1
        LEA SI, VET2
        MOV CX, LUNG
ciclo:  MOV AX, [DI]
        MOV [SI], AX
        ADD SI, 2
        ADD DI, 2
        LOOP ciclo
        NOP
        .EXIT
        END
