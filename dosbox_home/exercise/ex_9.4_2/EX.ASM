LUNG    EQU         10        
        .MODEL small
        .STACK
        .DATA
VETT    DW          5,5,5,5,5,-5,-5,-5,-5,-5
MSG1    DB          "Negative number", 0Dh, 0AH, "$"
MSG2    DB          "Positive number", 0Dh, 0AH, "$"
        .CODE
        .STARTUP
        MOV CX, LUNG
        MOV SI, 0
ciclo:  CMP VETT[SI], 0
        JL nega
        LEA DX, MSG2
        JMP next
nega:    LEA DX, MSG1
next:   ADD SI, 2
        MOV AH, 09H
        INT 21H
        LOOP ciclo
        NOP
        .EXIT
        END
