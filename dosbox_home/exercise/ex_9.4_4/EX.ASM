        .MODEL small
        .CODE
        .STARTUP
read:   MOV AH, 08H
        INT 21H
        CMP AL, "r"
        JNE read
        NOP
        .EXIT
        END
