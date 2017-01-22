LUNG    EQU         10
        .MODEL small
        .STACK
        .DATA
SORG    DW          1, 2, 3, -1, 4, 5, 7, 8, 9, 10
DEST    DW          LUNG DUP(?)
DEST_PTR DD         DEST
        .CODE
        .STARTUP
        MOV CX, LUNG
        LEA SI, SORG
        LES DI, DEST_PTR
        CLD
ciclo:  LODSW ; this stores the value pointed by SI into AX
        CMP AX, 0
        JNL next
        NEG AX
next:   STOSW ; this stores the value of AX into the 2bytes pointed by ES:DS
        LOOP ciclo
        NOP             ; check the result
        .EXIT
        END
