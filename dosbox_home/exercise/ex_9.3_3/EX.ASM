LUNG    EQU         100
        .MODEL small
        .STACK
        .DATA
VETT    DW          LUNG-2 DUP(0), 10, 0
        .CODE
        .STARTUP
        MOV CX, LUNG
        MOV SI, -2
ciclo:  ADD SI, 2
        CMP VETT[SI], 0
        LOOPE ciclo
        NOP ; here the SI register should be 196
        .EXIT
        END
