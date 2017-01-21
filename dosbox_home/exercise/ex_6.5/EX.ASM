MOVE    MACRO V1, V2
        PUSH AX
        MOV AX, V2
        MOV V1, AX
        POP AX
        ENDM
        .MODEL small
        .STACK
        .DATA
VAR1    DW          10
VAR2    DW          20
        .CODE
        .STARTUP
        NOP
        NOP
        MOVE VAR1, VAR2
        .EXIT
        END
