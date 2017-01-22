LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
VECTOR  DW          0, 1, 2, 3, 4, 5, 6, 7, 8, 9
ODDV    DW          ?
EVENV   DW          ?
        .CODE
        .STARTUP
        MOV CX, LUNG
        XOR SI, SI
ciclo:  MOV AX, VECTOR[SI]
        TEST AX, 1
        JNZ isodd
        ADD EVENV, AX
        JMP next
isodd:  ADD ODDV, AX
next:   ADD SI, 2
        LOOP ciclo
        NOP             ; check the result
        .EXIT
        END
