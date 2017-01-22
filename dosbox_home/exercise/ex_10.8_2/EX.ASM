LUNG    EQU             10
        .MODEL small
        .STACK
        .DATA
VECTOR  DW              10, 20, 10, -9, 20, 10, -7, 20, -3, -5 
AVERAGE DW              ? ; the result should be 15
ERR     DB              "An overflow occurred while summing numbers", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        XOR SI, SI      ; use this as vector index
        XOR AX, AX      ; use this as partial sum
        XOR BL, BL      ; use this as number accumulator
        MOV CX, LUNG
ciclo:  CMP VECTOR[SI], 0
        JNG next
        ADD AX, VECTOR[SI] ; in v2 check the overflow
        INC BL
        JNO next
        LEA DX, ERR
        MOV AH, 09H
        INT 21H
        JMP fine
next:   ADD SI, 2
        LOOP ciclo
        DIV BL
        MOV AVERAGE, AX ; what should we do with the rest?
fine:   NOP             ; check the result
        .EXIT
        END
