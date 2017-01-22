LENG    EQU         10        
CR      EQU         13
EOS     EQU         "$"
        .MODEL small
        .DATA
STRING  DB          (LENG+1) DUP(?)
        .CODE
        .STARTUP
        XOR SI, SI
        MOV CX, LENG
ciclo:  MOV AH, 01H
        INT 21H
        MOV STRING[SI], AL
        INC SI
        CMP AL, CR
        LOOPNE ciclo
        MOV STRING[SI], EOS
        LEA DX, STRING
        MOV AH, 09H
        INT 21H
        .EXIT
        END
