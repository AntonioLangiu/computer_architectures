LEN     EQU         10
        .MODEL small
        .STACK
        .DATA
VECTOR  DW	    1,2,3,4,5,10,7,8,9,6
MAX     DW          ?
        .CODE
        .STARTUP
        LEA SI, VECTOR
        MOV CX, LEN
	    MOV BX, [SI]	 ; use the BX register as local max
        ADD SI, 2
here:	CMP BX, [SI]	 ; is [DI] >= CX
        JA isnot            ; is not
	    MOV BX, [SI]
isnot:	ADD SI, 2
        LOOP here
        MOV MAX, BX
        .EXIT
        END
