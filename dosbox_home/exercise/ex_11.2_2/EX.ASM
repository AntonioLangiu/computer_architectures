        .MODEL small
        .STACK
        .DATA
BASE    DB           2
ALTEZZA DB           4
AREA    DW           ?
        .CODE
        .STARTUP
        MOV AL, BASE
        MUL ALTEZZA
        SHR AX, 1
        MOV AREA, AX
        NOP          ; check the value of AREA, it should be 4
        .EXIT
        END
