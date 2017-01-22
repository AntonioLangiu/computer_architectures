LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
VETT    DW          -3, -2, 8, (LUNG-3) DUP(?)
        .CODE
        .STARTUP
        XOR AX, AX  ;use AX as accumulator
        MOV CX, LUNG
        LEA SI, VETT
ciclo:  ADD AX, [SI]
        ADD SI, 2
        DEC CX
        CMP AX, 0
        JL ciclo
        NOP
        NOP
        .EXIT
        END
