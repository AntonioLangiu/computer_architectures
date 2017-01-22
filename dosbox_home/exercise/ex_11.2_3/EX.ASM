        .MODEL small
        .STACK
        .DATA
VALUE   DB              12H
        .CODE
        .STARTUP
        MOV AH, VALUE
        MOV CL, 4       ; on 8080 I can't use the direct value
        ROR AH, CL
        MOV VALUE, AH
        .EXIT
        END
