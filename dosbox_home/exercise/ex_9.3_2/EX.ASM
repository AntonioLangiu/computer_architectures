LUNG    EQU         50
        .MODEL small
        .STACK
        .DATA
VETT    DB      LUNG DUP(1)
        .CODE
        .STARTUP
        MOV CX, LUNG
        XOR SI, SI
        XOR AX, AX
itera:  ADD AH, VETT[SI]
        JO overf
        INC SI
        LOOP itera
        JMP fine
overf:  MOV CX, LUNG
        XOR SI, SI
azzera: MOV VETT[SI], AL ; use AL and not a direct value because it's faster
        INC SI
        LOOP azzera
fine:   NOP ; the final value of AH should be 0x32 == 50
        .EXIT
        END
