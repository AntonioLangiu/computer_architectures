LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
VETT    DW          -1, -3, -5, -6, 10, 10, 5, 4, 3, 10
        .CODE
        .STARTUP
        MOV CX, LUNG
        XOR SI, SI
ciclo:  CMP VETT[SI], 0
        JNL next
        NEG VETT[SI]
next:   ADD SI, 2
        LOOP ciclo
        NOP         ; check the result. It should loop 4 times
                    ; negating the value and 6 time leaving it 
                    ; positive
        .EXIT
        END
