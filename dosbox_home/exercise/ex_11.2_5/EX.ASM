        .MODEL small
        .STACK
        .DATA
BASE    DW          10000
ALTE    DW          20000
AREA    DW          ?
ERR     DB          "An overflow occurred during the sum", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        XOR DX, DX
        MOV AX, BASE
        MUL ALTE
        SHR DX, 1   ; MOVE THE FIRST BIT OF DX TO THE CF
        RCR AX, 1
        CMP DX, 0
        JZ nooverflow
        LEA DX, ERR
        MOV AX, 09H
        MOV AREA, 0
        INT 21H
        JMP fine
nooverflow:
        MOV AREA, AX
fine:   NOP        
        .EXIT
        END
