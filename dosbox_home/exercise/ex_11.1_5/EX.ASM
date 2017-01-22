        .MODEL small
        .STACK
        .DATA
TESTA   DB          "TESTA", 0DH, 0AH, "$"
CROCE   DB          "CROCE", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        MOV AH, 2CH
        INT 21H
        MOV AL, DL
        CBW
        MOV BH, 02H
        DIV BH      ; I Should have the rest in AH
        CMP AH, 0
        JNE other
        LEA DX, TESTA
        JMP print
other:  LEA DX, CROCE
print:  MOV AH, 09H
        INT 21H
        .EXIT
        END
