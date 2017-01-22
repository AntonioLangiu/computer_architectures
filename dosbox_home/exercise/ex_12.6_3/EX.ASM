LUNG    EQU         10
DIFF    EQU         "a"-"A"
        .MODEL small
        .STACK
        .DATA
SORG    DB          "antaninull", "$"
DEST    DB          LUNG DUP(?), "$"
DEST_PTR DD         DEST
        .CODE
        .STARTUP
        LEA SI, SORG
        LES DI, DEST_PTR
        MOV CX, LUNG
        CLD
ciclo:  LODSB
        CMP AL, "a"
        JL next
        CMP AL, "z"
        JG next
        SUB AL, DIFF
next:   STOSB
        LOOP ciclo
        NOP         ; check the result
        .EXIT
        END
