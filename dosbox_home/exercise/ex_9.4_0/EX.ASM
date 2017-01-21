LUNG    EQU         22
        .MODEL small
        .STACK
        .DATA
VETT    DW          1, -1, LUNG DUP(?)
        .CODE
        .STARTUP
        MOV CX, LUNG
        MOV SI, 0
ciclo:  CMP VETT[SI], 0
        JNL next
        MOV VETT[SI], 0
next:   ADD SI, 2
        LOOP ciclo
        NOP
        .EXIT
        END
