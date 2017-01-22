LUNG    EQU             10        
        .MODEL small
        .STACK
        .DATA
SORG    DB              "antani nul", "$"
DEST    DB              LUNG DUP(?)
DEST_PTR DD             DEST
        .CODE
        .STARTUP
        MOV CX, LUNG
        LEA SI, SORG
        LES DI, DEST_PTR
        CLD
ciclo:  LODSB
        CMP AX, " "
        JE next
        STOSB
next:   LOOP ciclo
        NOP
        .EXIT
        END
