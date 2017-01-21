        .MODEL small
        .STACK
        .DATA
MSGA    DB          "char is a", 0DH, 0AH, "$"
MSGB    DB          "char is b", 0DH, 0AH, "$" 
MSGC    DB          "char is c", 0DH, 0AH, "$"
MSGNO   DB          "char is not a, not b, not c", 0DH, 0AH, "$"
MSG     DW          MSGA
        DW          MSGB
        DW          MSGC
        .CODE
        .STARTUP
        MOV AH, 08H
        INT 21H
        CMP AL, "a"
        JB invalid
        CMP AL, "c"
        JA invalid
        MOV AH, 0
        MOV SI, AX
        SUB SI, "a"
        ADD SI, SI
        MOV DX, MSG[SI]
        JMP print
invalid: LEA DX, MSGNO
print:  MOV AH, 09H
        INT 21H
        .EXIT
        END
