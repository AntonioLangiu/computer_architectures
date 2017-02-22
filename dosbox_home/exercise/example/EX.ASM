        .MODEL small
        .STACK
        .DATA
STRING  DB          "Hello, World!", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        LEA DX, STRING
        MOV AH, 09H
        INT 21H
        .EXIT
        END
