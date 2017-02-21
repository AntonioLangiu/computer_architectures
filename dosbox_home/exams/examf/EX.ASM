;*******************************************;
;************* CONSTANTS *******************;
;*******************************************;
CR      EQU     13
LF 		EQU		10
DOT		EQU		46
TAB     EQU		9
;*******************************************;
;**************  MACRO  ********************;
;*******************************************;

;*******************************************;
;				PRINTP						;
; Macro to print a dot						;
;*******************************************;
PRINTP 	MACRO
		PUSH AX
		PUSH DX
			XOR DH, DH;
			MOV DL, DOT
			MOV AH, 2
			INT 21H
		POP DX
		POP AX
		ENDM

;*******************************************;
;				PRINTT						;
; Macro to print a tab						;
;*******************************************;
PRINTT 	MACRO
		PUSH AX
		PUSH DX
			XOR DH, DH;
			MOV DL, TAB
			MOV AH, 2
			INT 21H
		POP DX
		POP AX
		ENDM
;*******************************************;
;				PRINTLN						;
; Macro to print a new line					;
;*******************************************;
PRINTLN MACRO
		PUSH AX
		PUSH DX
			XOR DH, DH;
			MOV DL, CR
			MOV AH, 2
			INT 21H

			XOR DH, DH;
			MOV DL, LF
			MOV AH, 2
			INT 21H	
		POP DX
		POP AX
		ENDM

		.MODEL small
        .STACK
        .DATA
;*******************************************;
;           INPUT VARIABLES                 ;
;*******************************************;
CAT_TAX                 DB 4 DUP(0)
NUM_PUR                 DB 8
PUR_OBJ                 DW 8 DUP(0)
;CAT_TAX                 DB 00H, 0BH, 019H, 10H
;NUM_PUR                 DB 8
;PUR_OBJ                 DW 02BB0H, 08B58H, 03AA8H, 0514H
;                        DW 0F58H, 011DCH, 02BF8H, 0E000H
;*******************************************;
;           OUTPUT VARIABLES                ;
;*******************************************;
TOTAL_FINAL_PRICE   	DW ?
TOTAL_DISCOUNT      	DW ?
TOTAL_NET_PRICE     	DW ?
TOTAL_TAX          		DW ?
OUTPUT              	DB 8*4 DUP(?)
CAT_TOTAL_FINAL_PRICE 	DW 4 DUP(0)
CAT_TOTAL_TAX_DUE     	DW 4 DUP(0)
CAT_TOTAL_APPL_DISC   	DW 4 DUP(0)
CAT_TOTAL_NET_PRICE   	DW 4 DUP(0)
;*******************************************;
;           MESSAGES                        ;
;*******************************************;
MESS_INV_NUMBER DB "Errore, numero non valido!", 0DH, 0AH, "$"
MESS_OVERFLOW	DB "The number you are trying to convert can't be stored on 32 bit", 0DH, 0AH, "$"
MESS_LINE       DB "|==============================================|", 0DH, 0AH, "$"
MESS_WELCOME    DB "|    Welcome to the FOREVER 56 calculator      |", 0DH, 0AH, "$"
MESS_TAX_INS    DB "Please insert the tax for each category", 0DH, 0AH, "$"
MESS_TAX_CAT    DB "Insert the tax for category ", "$"
MESS_PUR_OBJ    DB "You will be now asked to insert the purchased objects", 0DH, 0AH, "$"
MESS_ADD_OBJ    DB "Start inserting the object number ", "$"
MESS_ADD_OBJ_CAT DB "Please insert the category", 0DH, 0AH, "$"
MESS_ADD_OBJ_NET DB "Please insert the net price", 0DH, 0AH, "$"
MESS_ADD_OBJ_DIS DB "Please insert the discount factor", 0DH, 0AH, "$"
MESS_REQ_NEW    DB "Do you want to add a new object? (y|n)", 0DH, 0AH, "$"
MESS_RECEIPT	DB "|                FOREVER 56 RECEIPT            |", 0DH, 0AH, "$"
MESS_HEADER1	DB "|   prod# | discount |  net  | tax due | final |", 0DH, 0AH, "$"
MESS_HEADER2	DB "|         |          | price |         | price |", 0DH, 0AH, "$"
MESS_TOTAL		DB "|   TOTAL |", "$"
MESS_CAT_QUE	DB "Do you want to see the totals by category? (y|n)", 0DH, 0AH, "$"
MESS_HEADERC 	DB "|               TOTAL BY CATEGORY              |", 0DH, 0AH, "$"
MESS_HEADERC1	DB "|  category |    1   |     2  |    3   |   4   |", 0DH, 0AH, "$"
MESS_CAT_DISC   DB "TOT DISCOUNT", "$"
MESS_CAT_NET	DB "TOT NET PRICE", "$"
MESS_CAT_TAX	DB "TOT TAX", "$"
MESS_CAT_FINAL  DB "TOT FINAL", "$"
;*******************************************;
;			SUPPORT VARIABLES				;
;*******************************************;
TRANSLATION_VETT    	DB 0, 25, 50, 75
CBUF                	DB 5 DUP(0)

        .CODE
        .STARTUP
        CALL READ_INPUT

        ; 122 -> 228 has been written during the examination

        MOV CL, NUM_PUR
        XOR CH, CH

        LEA SI, PUR_OBJ
        LEA DI, OUTPUT

loop1:  MOV BX, [SI]
        XOR AX, AX
        XCHG AH, BH
        AND BL, 03FH
        SHR AX, 1
        SHR AX, 1
        SHL BX, 1
        SHL BX, 1
        MUL BX
        CMP DX, 0
        JE smaller
        PUSH CX
        MOV CX, 14
loop2:  SHR DX, 1
        RCR AX, 1
        LOOP loop2
        POP CX
        JMP ok
smaller: PUSH CX
        MOV CL, 14
        SHR AX, CL
        POP CX
ok:     MOV [DI], AL

        PUSH CX
        MOV CX, [SI]
        SHL CX, 1
        SHL CX, 1
        AND CH, 3
        XOR CH, CL
        XOR CL, CH
        XOR CH, CL
        XOR CH, CH
        SHL CX, 1
        MOV BP, CX

        XOR AH, AH
        ADD TOTAL_DISCOUNT, AX
        MOV BL, BYTE PTR [SI]+1

        SUB BL, AL ; in BL I have the net price
        XOR BH, BH

        ADD TOTAL_NET_PRICE, BX
        MOV [DI][1], BL
        ; start calculating the total tax due
        XCHG AX, BX
        ; in BX I have the discount and in AX the net price

        ADD CAT_TOTAL_NET_PRICE[BP], AX
        ADD CAT_TOTAL_APPL_DISC[BP], BX

        MOV BL, BYTE PTR [SI]
        XOR BH, BH
        SHL BX, 1
        SHL BX, 1
        XOR BL, BL
        XCHG BL, BH
        ; now in BH I have the category
        MOV DH, CAT_TAX[BX]
        AND DH, 00011111B

        XOR DL, DL
        SHR DX, 1

        PUSH AX
        MOV CL, 6
        SHL AX, CL

        MOV BX, DX
        MUL BX
        ; now in DX I have the high part of the result and in AX the low part
        ; I should divide by 100
        MOV BX, 06400H
        DIV BX
        ; now in AX I have the result
        XCHG BX, AX
        POP AX
        ; now I have the net price in AX and tax due in BX
        ; but the tax needs to be shifted
        MOV CL, 6
        SHR BX, CL

        ADD TOTAL_TAX, BX
        ; start calculating the final price
        ADD AX, BX
        ; in Ax I have now the final price
        ADD TOTAL_FINAL_PRICE, AX
        ADD CAT_TOTAL_FINAL_PRICE[BP], AX
        ADD CAT_TOTAL_TAX_DUE[BP], BX

        MOV [DI][2], BL
        MOV [DI][3], AL

        ADD DI, 4
        ADD SI, 2
        POP CX
        DEC CX
        JNZ loop1

        CALL REPORT
        .EXIT

	;*******************************************;
	;               FUNCTIONS                   ;
	;*******************************************;

	;*******************************************;
	;               READ_INPUT                  ;
	;*******************************************;
	READ_INPUT PROC near
			; this function should do the following things:
			;   1: print the instructions
			;   2: read the category taxes: loop of 
			;   3: read the values
			; print the welcome instructions
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_WELCOME
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			;===================== print the category helper
			LEA DX, MESS_TAX_INS
			MOV AH, 09H
			INT 21H
			;===================== read the category tax value
			MOV BX, 0
	f0loop1:        
			LEA DX, MESS_TAX_CAT
			MOV AH, 09H
			INT 21H
			MOV DX, BX      ; print the category number
			INC DX
			CALL PRINT
			PRINTLN
			CALL READ_TAX   ; it returns just when it received a valid number
			MOV CAT_TAX[BX], DL ; in DX I have the output, copy it to the vector
			PRINTLN
			INC BX
			CMP BX, 4
			JL f0loop1

			;===================== read the purchased objects
			LEA DX, MESS_PUR_OBJ ; print the helper message
			MOV AH, 09H          ; set the sys call value
			INT 21H              ; call the DOS sys call
			XOR BP, BP           ; use BP as index for the iterations of objects
			MOV CX, 1

	f0loop2:
			LEA DX, MESS_ADD_OBJ
			MOV AH, 09H
			INT 21H
			MOV DX, CX      ; print the category number
			CALL PRINT
			PRINTLN
			CALL READ_OBJ
			ADD BP, 2
			INC CX

	f0req:  LEA DX, MESS_REQ_NEW    
			MOV AH, 09H
			INT 21H
			MOV AH, 1		; set the sys call value
			INT 21H			; sys call
			CMP AL, 'y'		; check if it is y
			JE f0loop2
			CMP AL, 'n'     ; check if it is n
			JE f0break
			JMP f0req

	f0break: 
			DEC CL
			MOV NUM_PUR, CL 

			NOP
			RET
	READ_INPUT ENDP

	;*******************************************;
	;               READ_OBJ                    ;
	; this function will access to the PUR_OBJ  ;
	; array and it expect to access through     ;
	; PUR_OBJ[BP], so you should be sure    	;
	; before calling this function that BP      ;
	; is setted in the correct way. This        ;
	; function will set BX in the correct way   ;
	;*******************************************;
	READ_OBJ PROC near
			PUSH AX
			PUSH BX
			PUSH CX
			PUSH DX
			PUSH SI
			PUSH DI
			; read the net price
			XOR BX, BX     ; use BX for the result
	read_obj_phase0:
			LEA DX, MESS_ADD_OBJ_NET
			MOV AH, 09H
			INT 21H

			MOV CL, DOT
			CALL READ16     ; the output is stored in DX
			JC read_obj_error0
			CMP DX, 1
			JB read_obj_error0
			CMP DX, 56
			JA read_obj_error0
			MOV SI, DX
			MOV CL, CR
			CALL READ16_2     ; the output is stored in DX
			JC read_obj_error0
			CMP DX, 0
			JB read_obj_error0
			CMP DX, 99
			JA read_obj_error0
			MOV AX, DX		; set the input of CONV2
			CALL CONV2		; the output is stored in AL
			XCHG BH, AL
			MOV DX, SI
			SHL DX, 1
			SHL DX, 1
			ADD BH, DL		; move the six integer bits into BH
			JMP read_obj_phase1

	read_obj_error0:
			LEA DX, MESS_INV_NUMBER
			MOV AH, 9		; set the sys call value
			INT 21H			; call sys call
			JMP read_obj_phase0
			
			; read the category
	read_obj_phase1:
			LEA DX, MESS_ADD_OBJ_CAT
			MOV AH, 09H
			INT 21H

			MOV CL, CR      ; reads until it finds a new line
			CALL READ16     ; the output is stored in DX
			JC read_obj_error1
			CMP DX, 0
			JB read_obj_error1
			CMP DX, 3
			JA read_obj_error1
			MOV BL, DL      ; now BX contains the category
			MOV CL, 6      	; shift by 6
			SHL BL, CL      ; shift
			JMP read_obj_phase2 ; go to phase 2
	read_obj_error1:
			LEA DX, MESS_INV_NUMBER
			MOV AH, 9		; set the sys call value
			INT 21H			; call sys call
			JMP read_obj_phase1

			; read the discount
	read_obj_phase2:
			LEA DX, MESS_ADD_OBJ_DIS
			MOV AH, 09H
			INT 21H
			CALL READ32     ; this function reads a 32 bit value from the command line
			; it stores it in DX:AX
			CALL CONV6      ; this function covnerts the 32 bit integer value to fixed
			; point value with a precision of 2^-6
			; the result of CONV6 is in AX
			ADD BL, AL
			
			MOV PUR_OBJ[BP], BX

			POP DI
			POP SI
			POP DX
			POP CX
			POP BX
			POP AX
			RET
	READ_OBJ ENDP

	;*******************************************;
	;               READ_TAX                    ;
	; this function will return the output in DX;
	;*******************************************;
	READ_TAX PROC near
	read_tax_loop:
			MOV CL, DOT
			CALL READ16     ; the output is stored in DX
			JC read_tax_error
			CMP DX, 0
			JB read_tax_error
			CMP DX, 12
			JA read_tax_error
			; now read just a single number and approximate
			MOV AH, 1		; set the sys call value
			INT 21H			; sys call
			CMP AL, '0'		; check if it's a number
			JB read_tax_error		; if not print an error and iterate
			CMP AL, '9'		; check if it's a number
			JA read_tax_error		; if not print an error and iterate
			SUB AL, '0'		; now you have in AL the number between 0 and 9
			CMP AL, 3       ; if the decimal part is greather that 3 that I consider it 5 TODO fix it
			JL read_tax_less
			STC
			RCL DX, 1
			JMP read_tax_fine
	read_tax_less:
			SHL DX, 1
			JMP read_tax_fine
	read_tax_error:  
			LEA DX, MESS_INV_NUMBER
			MOV AH, 9		; set the sys call value
			INT 21H			; call sys call
			JMP read_tax_loop
	read_tax_fine:
			RET
	READ_TAX ENDP

	;*******************************************;
	;               REPORT	                    ;
	;*******************************************;
	REPORT 	PROC near
			; print introduction
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_RECEIPT
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			; print header
			LEA DX, MESS_HEADER1
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_HEADER2
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			; print lines
			MOV CL, NUM_PUR
			XOR CH, CH
			MOV DI, 1
			LEA SI, OUTPUT
	report_loop1:
			PRINTT			; add a starting tab
			MOV DX, DI		; print the category number
			CALL PRINT
			PRINTT			; add a tab
			MOV AL, [SI]	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+1	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+2	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+3	; print the category number
			CALL PRINTFP8
			PRINTLN
			INC DI
			ADD SI, 4
			LOOP report_loop1
			; print totals
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_TOTAL
			MOV AH, 09H
			INT 21H

			PRINTT
			MOV AX, TOTAL_DISCOUNT
			CALL PRINTFP16
			PRINTT
			MOV AX, TOTAL_NET_PRICE
			CALL PRINTFP16
			PRINTT
			MOV AX, TOTAL_TAX
			CALL PRINTFP16
			PRINTT
			MOV AX, TOTAL_FINAL_PRICE
			CALL PRINTFP16
			PRINTT

			PRINTLN
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			; now ask the user if it wants to see the total by category
report_req:
		   	LEA DX, MESS_CAT_QUE
			MOV AH, 09H
			INT 21H
			MOV AH, 1		; set the sys call value
			INT 21H			; sys call
			CMP AL, 'y'		; check if it is y
			JE report_tot_cat
			CMP AL, 'n'     ; check if it is n
			JE report_end
			JMP report_req
report_tot_cat:
			; print total by category
			PRINTLN
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_HEADERC
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_HEADERC1
			MOV AH, 09H
			INT 21H
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
			; print the discount
			MOV DI, 1
			LEA SI, CAT_TOTAL_APPL_DISC
			LEA DX, MESS_CAT_DISC
			MOV AH, 09H
			INT 21H
			PRINTT			; add a tab
			MOV AL, [SI]	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+2	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+4	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+8	; print the category number
			CALL PRINTFP8
			PRINTLN
			INC DI
			; print the total net price
			MOV DI, 1
			LEA SI, CAT_TOTAL_NET_PRICE
			LEA DX, MESS_CAT_NET
			MOV AH, 09H
			INT 21H
			PRINTT			; add a tab
			MOV AL, [SI]	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+2	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+4	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+8	; print the category number
			CALL PRINTFP8
			PRINTLN
			INC DI
			; print the total tax
			MOV DI, 1
			LEA SI, CAT_TOTAL_TAX_DUE
			LEA DX, MESS_CAT_TAX
			MOV AH, 09H
			INT 21H
			PRINTT			; add a tab
			PRINTT			; add a tab
			MOV AL, [SI]	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+2	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+4	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+8	; print the category number
			CALL PRINTFP8
			PRINTLN
			INC DI
			; print the total final price
			MOV DI, 1
			LEA SI, CAT_TOTAL_FINAL_PRICE
			LEA DX, MESS_CAT_FINAL
			MOV AH, 09H
			INT 21H
			PRINTT			; add a tab
			MOV AL, [SI]	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+2	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+4	; print the category number
			CALL PRINTFP8
			PRINTT			; add a tab
			MOV AL, [SI]+8	; print the category number
			CALL PRINTFP8
			PRINTLN
			INC DI
			; print an ending line
			LEA DX, MESS_LINE
			MOV AH, 09H
			INT 21H
report_end:
			RET
	REPORT	ENDP


	;*******************************************;
	;               READ16_2					;
	; This function reads a number from the 	;
	; command line and returns it through		;
	; the CL register. It is good to be used 	;
	; with conv2 because it return a value 		;
	; of at least 2 digits						;
	; This function return the readed values	;
	; in DX										;
	; This function compares the final value    ;
	; with CL                                   ;
	;*******************************************;
	READ16_2  PROC near
			PUSH AX			; save the registers
			PUSH BX
			PUSH SI
			CLC
			MOV SI, 2
	f1lab0: XOR DX, DX		; use DX to hold part of the result
	f1lab1: MOV BX, 10		; store in BX the multiplier
			MOV AH, 1		; set the sys call value
			INT 21H			; sys call
			CMP AL, CL		; check if it's a new line
			JE f1fine       ; if it's return
			CMP AL, '0'		; check if it's a number
			JB f1error		; if not print an f1error and iterate
			CMP AL, '9'		; check if it's a number
			JA f1error		; if not print an f1error and iterate
			SUB AL, '0'		; now you have in AL the number between 0 and 9
			XCHG AX, BX		
			XOR BH, BH		; now in BX you have the readed number
			MUL DX			; multiply DX with 10
			CMP DX, 0		; if DX is 0 we have an overflow
			JNE f1error		; because we cant' rapresent the number on 16 bits
			MOV DX, AX		; mov the multiplied number again to DX
			ADD DX, BX		; add the readed number to the previous number
			JC f1error		; overflow, print the f1error
			DEC SI
			JMP f1lab1		; loop again
	f1error:  STC
	f1fine: CMP SI, 0
			JE f1end
			MOV AX, DX
			MOV BL, 10
			MUL BL
			MOV DX, AX
	f1end:
			POP SI  
			POP BX
			POP AX
			RET
			READ16_2 ENDP
	;*******************************************;
	;               READ16                      ;
	; This function reads a number from the 	;
	; command line and returns it through		;
	; the stack									;
	; This function return the readed values	;
	; in DX										;
	; This function compares the final value    ;
	; with CL                                   ;
	;*******************************************;
	READ16  PROC near
			PUSH AX			; save the registers
			PUSH BX
			CLC
	f1lab0: XOR DX, DX		; use DX to hold part of the result
	f1lab1: MOV BX, 10		; store in DX the multiplier
			MOV AH, 1		; set the sys call value
			INT 21H			; sys call
			CMP AL, CL		; check if it's a new line
			JE f1fine       ; if it's return
			CMP AL, '0'		; check if it's a number
			JB f1error		; if not print an f1error and iterate
			CMP AL, '9'		; check if it's a number
			JA f1error		; if not print an f1error and iterate
			SUB AL, '0'		; now you have in AL the number between 0 and 9
			XCHG AX, BX		
			XOR BH, BH		; now in BX you have the readed number
			MUL DX			; multiply DX with 10
			CMP DX, 0		; if DX is 0 we have an overflow
			JNE f1error		; because we cant' rapresent the number on 16 bits
			MOV DX, AX		; mov the multiplied number again to DX
			ADD DX, BX		; add the readed number to the previous number
			JC f1error		; overflow, print the f1error
			JMP f1lab1		; loop again
	f1error:  STC
	f1fine:   POP BX
			POP AX
			RET
			READ16 ENDP
	;*******************************************;
	;               READ 32                     ;
	; This function reads a number from the 	;
	; command line and it saves on 32 bits		;
	; register AX, DX							;
	; It should be used in this context			;
	; because it converts number like 6			;
	; to 600000, to be easily converted to		;
	; fixed point numbers						;
	; It is limited to read at most 6 numers	;
	; you can change that parameter				;
	; by changing CX							;
	;*******************************************;
	READ32  PROC near
			PUSH CX			; save the registers
			PUSH DI
			PUSH SI
	f2lab0: XOR AX, AX
			XOR DX, DX
			XOR DI, DI		; this will be used fot the low part
			XOR SI, SI		; this will be used for the high part
			MOV CX, 6		; CX will be used as index to stopping reading numbers after CX times
	f2lab1: MOV AH, 1		; set the value for the sys call
			INT 21H			; sys call
			CMP AL, CR		; check if it's a Carriage Return
			JE f2finalizza    ; f2finalizza is used to convert numbers to a format compatible to
			CMP CX, 0		; when CX is 0 and the previous char the user is trying to insert an invalid number
			JE f2error		
			CMP AL, '0'		; check if it's a number
			JB f2error
			CMP AL, '9'		; check if it's a number
			JA f2error
			SUB AL, '0'		; now the value readed is in AL. It's between 0 and 9
			DEC CX
			XOR AH, AH		; store the readed number
			PUSH AX
				MOV AX, 10  ; set the multiply factor
				MUL DI		; multiply the low part
				MOV DI, AX	
				PUSH DX		; save the low part
					MOV AX, 10	; reset the multiply factor
					MUL SI		; multiply the high part
					CMP DX, 0	; if DX is not 0 we have an overflow
					JG f2error	; bacause the number is can't be rapresented on 32 bits
				POP DX
				MOV SI, AX
				ADD SI, DX		; now SI contains the high part
			POP AX			; recover the readed value
			ADD DI, AX		; add it to the low part
			ADC SI, 0		; add a possible carry to the high part SI
			JMP f2lab1
	f2error: LEA DX, MESS_INV_NUMBER
			MOV AH, 9		; print the f2error message
			INT 21H
			JMP f2lab0		; get another number
	f2finalizza:
			CMP CX, 0		; if CX is not 0 I need to multiply the number by 10 for CX times
			JE f2fine
	f2loop3: MOV AX, 10		; set the multiply factor
			MUL DI			; multiply the low part
			MOV DI, AX		; save the low part
			PUSH DX			; save the high part of the multiplication
				MOV AX, 10	; multiply the low part
				MUL SI      ; we should never have an overflow in this situation because it's limited to 2^6
			POP DX			; recover the high part of the first multiplication
			MOV SI, AX		
			ADD SI, DX		; add it to the high part
			LOOP f2loop3
	f2fine: MOV DX, SI      ; mov the high part to DX
			MOV AX, DI      ; mov the low part to AX
			POP SI
			POP DI
			POP CX
			RET
	READ32 	ENDP
	;*******************************************;
	;           CONV2          					;
	; This function converts a 8 bit number     ;
	; stored in AL to the fractionary           ;
	; part of a fixed point number, with        ;
	; fractionary part of 2 bits                ;
	; The result is returned in the two last  	;
	; bits of AL                        		;
	;*******************************************;
	CONV2   PROC near
			PUSH BX
			PUSH CX         ; save the registers
			PUSH DX         ; save the registers
			MOV CX, 2
			XOR BX, BX      ; BX will be used to hold the result
							; start conversion
	f5loop1:  
			SHL AX, 1       ; multiply low part by 2
			SHL BL, 1       ; shift BL by one. In the first iteration it has no effect 0«1 == 0
			CMP AX, 064H    ; compare high part with 064H, that is the limit for 10^2
			JAE f5greather   ; if it is f5greather than 064H the whole number is f5greather than 100
			JMP f5next      ; if it's below than the number is < 100 and we can consider the f5next
	f5greather:
			OR BL, 01H      ; if you are here the number is > 100 and you need to set the bit to 1
			SUB AX, 064H    ; subtract 100
	f5next: LOOP f5loop1
			JMP f5fine
	f5fine: 
			MOV AL, BL
			POP DX
			POP CX
			POP BX
			RET 
	CONV2   ENDP
	;*******************************************;
	;               CONV6                      ;
	; This function converts a 32 bit number 	;
	; stored in AX and DX to the fractionary 	;
	; part of a fixed point number, with 		;
	; fractionary part of 6 bits				;
	; The result is returned in AX				;
	;*******************************************;
	CONV6   PROC near
			PUSH BX
			PUSH CX			; save the registers
			PUSH DX			; save the registers
			MOV CX, 6
			XOR BX, BX		; BX will be used to hold the result
							; start conversion
	f3loop1:  SHL AX, 1 		; multiply low part by 2
			RCL DX, 1		; multiply high part by 2 adding carry
			JC f3overflow  	; if the carry flag is 1 we have an f3overflow
			SHL BX, 1		; shift BX by one. In the first iteration it has no effect 0<<1 == 0
			CMP DX, 0FH 	; compare high part with 0FH, that is the limit for 10^6
			JA f3greather		; if it is f3greather than 0FH the whole number is f3greather than 10^6
			CMP DX, 0FH 	; compare the high part to check if it's exacly 0FH
			JB f3next			; if it's below 0FH it cant' be higher than 10^6
			CMP AX, 04240H 	; compare the low part with the limit
			JB f3next			; if it's below than the number is < 10^6 and we can consider the f3next
	f3greather:
			OR BL, 01H		; if you are here the number is > 10^6 and you need to set the bit to 1
			SUB AX, 04240H	; subtract the low part of 10^6
			SBB DX, 0FH 	; subtract the high part of 10^6 (you should not have a borrow because it is higher than 10^6)
	f3next:   LOOP f3loop1
			JMP f3fine
	f3overflow: 
			LEA DX, MESS_OVERFLOW
			MOV AH, 09		; print message stored in DX
			INT 21H			; call system call
	f3fine: MOV AX, BX  
			POP DX
			POP CX
			POP BX
			RET
	CONV6   ENDP
	;*******************************************;
	;				PRINTFP16					;
	; This function prints a fixed point on		;
	; 16 bits on 2 fract. bits					;
	;*******************************************;
	PRINTFP16 PROC NEAR
			PUSH AX
			PUSH DX
			CALL TRANSLATE16 	; result in DX : AX
			CALL PRINT 			; prints a number contained in DX (the integer part)
			PRINTP 				; prints a point
			XOR DH, DH			; prepare to print the low part
			MOV DL, AL 			; mov the low part to DL
			CALL PRINT			; print the low part contained in DL (fractionary)
			POP DX
			POP AX
			RET 
	PRINTFP16 ENDP

	;*******************************************;
	;				PRINTFP8					;
	; This function prints a fixed point 		;
	; number stored on 8 bits					;
	; It receives the input in AX				;
	;*******************************************;
PRINTFP8 PROC NEAR
		CALL TRANSLATE8		; It receives the input in AX and call translate8 to translate it
    	XOR DH, DH 			; set DH to 0
    	MOV DL, AH			; move the integer part to DL
    	CALL PRINT			; prints it
		PRINTP				; prints a dot
		XOR DH, DH			; set DH to 0
    	MOV DL, AL			; moves the fractionary part to DL
   		CALL PRINT			; prints the fractionary part
		RET 				
PRINTFP8 ENDP

;*******************************************;
;				TRANSLATE 8					;
; This function receives in AL the value to	;
; translate									;
; The format is zzzzzzvv					;
; where z is the integer part and v the 	;
; fractionary								;
;*******************************************;
TRANSLATE8 PROC NEAR
		PUSH BX				; save registers
		PUSH CX

		XOR AH, AH			; set AH to 0
		XOR BX, BX			; initialize BX
		XOR CX, CX			; initialize CX

		MOV BX, AX			
		AND BL, 00000011B	; apply mask to the number to extract fractionary part

		MOV CL, 6			; shift the the integer part of to AH
		SHL AX, CL			; shift

		MOV AL, BL			; move the fractionary part to AL
		MOV BX, OFFSET TRANSLATION_VETT
		XLAT				; use translation table
							; now in AH you have the integer part and in AL the fractional part,
							; both rapresented in binary
		POP CX				; restore registers
		POP BX
RET
TRANSLATE8 ENDP

;*******************************************;
;				TRANSLATE 16				;
; This functions translates from a 16 bits	;
; fixed point number to binary values.		;
; It receives in AX the the value with 		;
; this format: vvvvvvvvvvvvvvff				;
; and returns in DX the integer part and in ;
; AX the fractionary part					;
;*******************************************;
TRANSLATE16 PROC NEAR
		PUSH BX				; save registers
		PUSH CX		
		XOR BX, BX			; initialize BX
		XOR CX, CX			; initialize CX
		MOV BL, AL			
		AND BL, 00000011B	; apply mask to the low part to obtain the fractionary part
		MOV CL, 2			; shift AX by two to remove the fractionary part
		SHR AX, CL			; shift
		MOV DX, AX			; now in DX you have the integer part
		MOV AL, BL			; now in AL	you have the fractionary part
		MOV BX, OFFSET TRANSLATION_VETT
		XLAT				; apply translation table
		XOR AH, AH			; set AH to 0
		POP CX
		POP BX
		RET
TRANSLATE16 ENDP

;*******************************************;
;				PRINT						;
; Print numbers stored in DX				;
;*******************************************;
PRINT PROC NEAR
		PUSH DI				; save registers 
		PUSH AX
		PUSH BX
		PUSH DX
		XOR DI, DI			; initialize DI that will be used as a counter
		MOV AX, DX			; move received number to AX
		XOR DX, DX			
		MOV BX, 10			; set divider
f4loop1:
		DIV BX				; divide the number by 10
		ADD DL, '0'			; convert the number to ASCII
		MOV CBUF[DI], DL	; move the number to a buffer
		INC DI 				
		XOR DX, DX			; initialize DX
		CMP AX, 0			; while AX != 0 convert the numbers
		JNE f4loop1
f4loop2: 	
		XOR DH, DH			; set DH to 0
		DEC DI				; decrement the counter DI
		MOV DL, CBUF[DI]	; print the buffer in reverse order
		MOV AH, 2			; set the sys call number
		INT 21H				; call DOS sys call
		CMP DI, 0			; cycle until DI is equal to 0
		JNE f4loop2
		
		POP DX				; restore registers
		POP BX
		POP AX
		POP DI
RET
PRINT ENDP

        .EXIT
        END
