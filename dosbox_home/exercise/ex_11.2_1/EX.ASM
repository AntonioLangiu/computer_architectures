        .MODEL small
        .STACK
        .DATA
PAROLA   DB              01100011B
        .CODE
        .STARTUP
        AND PAROLA, 00111000B
        CLC
        MOV CL, 3
        SHR PAROLA, CL
        .EXIT
        END
