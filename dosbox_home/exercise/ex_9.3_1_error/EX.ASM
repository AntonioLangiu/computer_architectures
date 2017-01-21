LUNG    EQU         8
        .MODEL small
        .STACK
        .DATA
VETT    DW          10, -3, 5, 0, -20, 30, 150, -16 ; POS=4, NEG=3
COUNT_POS      DW        ?
COUNT_NEG      DW        ?
        .CODE
        .STARTUP
        MOV CX, LUNG
        MOV SI, 0
        XOR AX, AX ; positive counter
        XOR BX, BX ; negative counter
lp:     CMP VETT[SI], 0
        JZ next
        JB nega
        INC AX
        JMP next
nega:  INC BX
next:   INC SI
        LOOP
        MOV COUNT_POS, AX
        MOV COUNT_NEG, BX
        .EXIT
        END
