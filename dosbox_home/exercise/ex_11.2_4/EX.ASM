        .MODEL small
        .STACK
        .DATA
VALUE   DW              10000
        .CODE
        .STARTUP
        MOV AX, VALUE
        MOV CL, 4
        SHR AX, CL
        MOV VALUE, AX
        .EXIT
        END
