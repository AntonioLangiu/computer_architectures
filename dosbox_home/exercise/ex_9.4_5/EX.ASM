LENG    EQU         10
        .MODEL small
        .STACK
        .DATA
VETT    DB          LENG DUP(?), 0DH, 0AH, "$"
        .CODE
        .STARTUP
        XOR SI, SI
        MOV CX, LENG
ciclo:  MOV AH, 01H
        INT 21H
        MOV VETT[SI], AL
        INC SI
        LOOP ciclo
        
        LEA DX, VETT
        MOV AH, 09H
        INT 21H
        .EXIT
        END
