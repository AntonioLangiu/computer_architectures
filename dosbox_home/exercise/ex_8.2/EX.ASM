LEN     EQU         5      
        .MODEL small
        .STACK
        .DATA
STRING  DB          "antani"
        .CODE
        .STARTUP
        XOR DI, DI
        MOV SI, LEN
        MOV CX, LEN
swap:   MOV AH, STRING[DI]
        XCHG AH, STRING[SI]
        MOV STRING[DI], AH
        INC DI
        DEC SI
        LOOP swap
        .EXIT
        END
