	NAME PART1
	EXTERN FUNC3_4:FAR,FUNC3_5:FAR,FUNC3_6:FAR
	PUBLIC F2T10,RADIX,S1,S2,GA1,GB1,GA2,GB2,GA3,GB3,BUF


.386
PRINT MACRO A
	LEA DX,A
	MOV AH,9
	INT 21H
	ENDM
WRITE MACRO B
	LEA DX,B
	MOV AH,10
	INT 21H
	ENDM
PRINT1 MACRO C
	MOV DL,C
	MOV AH,2
	INT 21H
	ENDM
STACK SEGMENT USE16  PARA STACK  'STACK'
	DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PARA PUBLIC
	BNAME DB 'C' XOR 'f' , 'H' XOR 'f', 'E' XOR 'f', 'N' XOR 'f' ,'G' XOR 'f' ,'U' XOR 'f' ,'O' XOR 'f' ,'X' XOR 'f' ,0  XOR 'f' ,0  XOR 'f'
	BPASS DB 't' XOR 'k' ,'e' XOR 'k' ,'s' XOR 'k' ,'t' XOR 'k' , 0  XOR 'k'  , 0  XOR 'k'
	N EQU 3
	S1     DB  'SHOP1','$'           ;�������ƣ���0����
	GA1 DB   'BAG', 7 DUP('$')  ; ��Ʒ����
		DW   35  XOR 'u' ,56,100,1,?  ;�����ʻ�δ����  ������(������)�����ۼۣ������ͣ������������������ͣ������������������ͣ�
	GA2 DB    'BOOK', 6 DUP('$') ; ��Ʒ����
    DW   12  XOR 'u' ,30,25,5,?   ;�����ʻ�δ����
	GA3 DB    'PEN', 7 DUP('$') ; ��Ʒ����
    DW   12  XOR 'u' ,30,25,12,?   ;�����ʻ�δ����


	S2  DB  'SHOP2','$'           ;�������ƣ���0����
	GB1 DB    'BAG', 7 DUP('$')  ; ��Ʒ����
      DW   35  XOR 'u' ,50,100,1,0  ;�����ʻ�δ����
	GB2 DB  'BOOK', 6 DUP('$') ; ��Ʒ����
      DW   12  XOR 'u' ,28,20,15,0   ;�����ʻ�δ����
	GB3 DB  'PEN', 7 DUP('$') ; ��Ʒ����
	  	DW   12  XOR 'u' ,28,20,19,0   ;�����ʻ�δ����
    MES DB 'Please input your name: $'
    PASS DB 'Please input your password: $'
	GOODS DB 'Please input a name of goods: $'
	FAILMES DB 'log fail please input again $'
	MENU1 DB 'select goods input 1,modify goods input 2,calculate APR input 3',0AH,0DH,'APR rank input 4,output all informations input 5,exit input 6',0AH,0DH,'$'
	MENU2 DB 'select goods input 1,exit input 6',0AH,0DH,'$'
	SHOP1 DB 'SHOP1 ','$'
	SHOP2 DB 'SHOP2 ','$'
	OPRICE DB 'BUYING PRICE:$'
	SPRICE DB 'SALING PRICE:$'
	SNUMBER DB 'SALED NUMBERS:$'
	SHOPNAME DB 'choose shop 1 or 2$'
	BUF DB 12 DUP(?)
    IN_NAME DB 10
    		DB ?
    		DB 10 DUP(0)
    IN_PWD  DB 6
    		DB ?
    		DB 6 DUP(0)
	IN_GOODS DB 10
			 DB ?
			 DB 10 DUP('$')
	BUF1 DB 10
    	DB ?
    	DB 10 DUP(0)
	BUF2 DB 10
    	DB ?
    	DB 10 DUP(0)
	BUF3 DB 10
    	DB ?
    	DB 10 DUP(0)
    AUTH DB ?
	Z_COUNT DW N
	SIGN DB ?
	CR DW 0
ERR_TIM DB  0;
OLDINT1 DW  0,0               ;1���жϵ�ԭ�ж�ʸ���������ж�ʸ�������٣�
OLDINT3 DW  0,0               ;3���жϵ�ԭ�ж�ʸ��


DATA ENDS
CODE SEGMENT USE16 PUBLIC 'CODE'
	ASSUME CS:CODE,DS:DATA,SS:STACK
START:  MOV	AX,DATA
	MOV	DS,AX


	xor  ax,ax                  ;�ӹܵ������жϣ��ж�ʸ��������
       mov  es,ax
       mov  ax,es:[1*4]            ;����ԭ1�ź�3���ж�ʸ��
       mov  OLDINT1,ax
       mov  ax,es:[1*4+2]
       mov  OLDINT1+2,ax
       mov  ax,es:[3*4]
       mov  OLDINT3,ax
       mov  ax,es:[3*4+2]
       mov  OLDINT3+2,ax
       cli                           ;�����µ��ж�ʸ��
       mov  ax,OFFSET NEWINT
       mov  es:[1*4],ax
       mov  es:[1*4+2],cs
       mov  es:[3*4],ax
       mov  es:[3*4+2],cs
       sti






	JMP BEGIN

FAIL:
	PRINT FAILMES 	;�����ʾ

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H

  MOV   DL , ERR_TIM
  INC   DL   ;���������һ
	MOV   ERR_TIM , DL
	CMP   DL ,3
	JE   OVER

	JMP BEGIN

BEGIN:
	PRINT MES 	;�����ʾ

 	MOV DL, 0AH             ; ���з�
  MOV AH, 2H
  INT 21H

	WRITE IN_NAME 		;��������

	MOV BL,IN_NAME+1
	MOV BH,0
	MOV BYTE PTR IN_NAME+2[BX],0 ;�ѻس�������

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H

	PRINT PASS 		;�����ʾ

 	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H

	WRITE IN_PWD 		;��������

	MOV DL, 0AH  	; ���з�
    MOV AH, 2H
    INT 21H

	MOV BL,IN_PWD+1
	MOV BH,0
	MOV BYTE PTR IN_PWD+2[BX],0 ;�ѻس�������

	LEA BP,IN_NAME
	ADD BP,2
	CMP DS:BYTE PTR [BP-1],0H 	;ֻ����س�
	JE NO
	CMP	DS:BYTE PTR [BP],71H 	;����q
	JE JUDQ

LOOPA:
	MOV CX,10
	LEA SI,IN_NAME
	ADD SI,2
	LEA DI,BNAME
	JMP CMPNAME

JUDQ:
	CMP DS:BYTE PTR [BP-1],1H
	JE OVER
	JMP LOOPA

CMPNAME:
	MOV BL,[SI]		 ;�Ƚ�����
;	XOR BL , 't'   ;����
  MOV AL ,[DI]
  XOR AL , 'f'

	CMP  BL,AL

	JNE FAIL
	INC SI
	INC DI
	SUB CX,1
	JNZ CMPNAME

	MOV CX,6
	LEA SI,IN_PWD
	ADD SI,2
	LEA DI,BPASS
	JMP CMPWORD

CMPWORD:
	MOV BL , [SI]		;�Ƚ�����
;	XOR BL , 't'   ;����
  MOV AL , [DI]
	XOR AL , 'k'   ;����
	CMP BL , AL
 	JNE FAIL
	INC SI
	INC DI
	SUB CX,1
	JNZ CMPWORD
	JMP RIGHT

MENU:
	MOV CR,0
	CMP AUTH,0
	JZ NO
	JNZ RIGHT

NO:
	MOV AUTH,0
	PRINT MENU2 	;�����ʾ

	MOV AH,1		;���빦�����
	INT 21H

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	MOV DL, 0DH             ; ���з�
    MOV AH, 2H
    INT 21H

	CMP AL,'6'		;����6�˳�����
	JZ OVER
	CMP AL,'1'
	JZ F1
	JNE NO
RIGHT:
	MOV AUTH,1
	PRINT MENU1 	;�����ʾ

	CMP AL,'6'		;����6�˳�����
	JZ OVER

	MOV AH,1		;���빦�����
	INT 21H

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	MOV DL, 0DH             ; ���з�
    MOV AH, 2H
    INT 21H

	CMP AL,'6'		;����6�˳�����
	JZ OVER
	CMP AL,'1'
	JZ F1
	CMP AL,'2'
	JZ F2
	CMP AL,'3'
	JZ F3
	CMP AL,'4'
	JZ F4
	CMP AL,'5'
	JZ F5
	JNZ RIGHT
F1:
	CALL FUNCTION1
	SUB CR,1
	JZ MENU

	PRINT SHOP1
	MOV BL,IN_GOODS+1
	MOV BH,0
	MOV BYTE PTR IN_GOODS+2[BX],'$' ;���봮β����$
	PRINT IN_GOODS+2
	LEA BX,GA1
	SUB DI,BX


	PRINT1 ' '
	MOV DX,16
	MOV AX,2[BX+DI]
	CALL F2T10

	PRINT1 ' '
	MOV DX,16
	MOV AX,4[BX+DI]
	CALL F2T10

	PRINT1 ' '
	MOV DX,16
	MOV AX,6[BX+DI]
	CALL F2T10


	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	PRINT SHOP2
	PRINT IN_GOODS+2
	LEA BX,GB1

	PRINT1 ' '
	MOV DX,16
	MOV AX,2[BX+DI]
	CALL F2T10

	PRINT1 ' '
	MOV DX,16
	MOV AX,4[BX+DI]
	CALL F2T10

	PRINT1 ' '
	MOV DX,16
	MOV AX,6[BX+DI]
	CALL F2T10

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	JMP MENU
F2:
	CALL FUNCTION2
	CMP CR,1
	JZ MENU
	LEA SI,GA1
	SUB DI,SI

ERR1:
	PRINT OPRICE
	MOV DX,16
	MOV AX,2[BX+DI]
	CALL F2T10
	PRINT1 '>'
	WRITE BUF1
	MOV CL,[BUF1+1]
	MOV CH,0
	CMP CL,0
	JZ ERR2
	MOV DX,16
	LEA SI,BUF1+2
	CALL F10T2
	CMP SI,-1
	JZ ERR1
	MOV 2[BX+DI],AX

ERR2:
	PRINT1 0AH
	PRINT SPRICE
	MOV DX,16
	MOV AX,4[BX+DI]
	CALL F2T10
	PRINT1 '>'
	WRITE BUF2
	MOV CL,[BUF2+1]
	MOV CH,0
	CMP CL,0
	JZ ERR3
	MOV DX,16
	LEA SI,BUF2+2
	CALL F10T2
	CMP SI,-1
	JZ ERR2
	MOV 4[BX+DI],AX

ERR3:
	PRINT1 0AH
	PRINT SNUMBER
	MOV DX,16
	MOV AX,6[BX+DI]
	CALL F2T10
	PRINT1 '>'
	WRITE BUF3
	MOV CL,[BUF3+1]
	MOV CH,0
	CMP CL,0
	JZ O
	MOV DX,16
	LEA SI,BUF3+2
	CALL F10T2
	CMP SI,-1
	JZ ERR3
	MOV 6[BX+DI],AX
O:
	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	JMP MENU
F3:

PASS3: mov  bx,es:[1*4]             ;����ж�ʸ�����Ƿ񱻵��Թ�����ֹ�޸Ļ�ָ�
		 inc  bx
		 jmp  bx                 ;�����޸��˵Ļ������ｫת�Ƶ�TESTINT������Ͳ�֪��ת������
		 db   'Now,you see.'
PASS4:

	CALL FUNC3_4
	JMP MENU
F4:
;  db 'sb'

	CALL FUNC3_5
	JMP MENU
F5:

;	db 'u f**k'

	CALL FUNC3_6
	JMP MENU



NEWINT: iret
TESTINT: jmp PASS4


OVER:

cli                           ;��ԭ�ж�ʸ��
mov  ax,OLDINT1
mov  es:[1*4],ax
mov  ax,OLDINT1+2
mov  es:[1*4+2],ax
mov  ax,OLDINT3
mov  es:[3*4],ax
mov  ax,OLDINT3+2
mov  es:[3*4+2],ax
sti



	MOV	AH,4CH
	INT	21H

F10T2 PROC
	PUSH EBX
	MOV EAX,0
	MOV SIGN,0
	MOV BL,[SI]
	CMP BL,'+'
	JE F10
	CMP BL,'-'
	JNE NEXT2
	MOV SIGN,1
F10:
	DEC CX
	JZ ERR
NEXT1:
	INC SI
	MOV BL,[SI]
NEXT2:
	CMP BL,'0'
	JB ERR
	CMP BL,'9'
	JA ERR
	SUB BL,30H
	MOVZX EBX,BL
	IMUL EAX,10
	JO ERR
	ADD EAX,EBX
	JO ERR
	JS ERR
	JC ERR
	DEC CX
	JNZ NEXT1
	CMP DX,16
	JNE PP0
	CMP EAX,7FFFH
	JA ERR
PP0:
	CMP SIGN,1
	JNE QQ
	NEG EAX
QQ:
	POP EBX
	RET
ERR:
	MOV SI,-1
	JMP QQ
F10T2 ENDP


FUNCTION1 PROC
SARTE:
	PRINT GOODS 	;�����ʾ

 	MOV DL, 0AH  	; ���з�
    MOV AH, 2H
    INT 21H

	MOV SI,11
	LEA BX,IN_GOODS
FRESH:
	MOV BYTE PTR [BX+SI],'$'
	SUB SI,1
	CMP SI,1
	JNZ FRESH
	WRITE IN_GOODS ;������Ʒ����

	MOV DL, 0AH  	; ���з�
    MOV AH, 2H
    INT 21H

	LEA BX,IN_GOODS
	CMP BYTE PTR [BX+1],0H 	;ֻ����س�
	JZ C1

	MOV BL,IN_GOODS+1
	MOV BH,0
	MOV BYTE PTR IN_GOODS+2[BX],'$' ;�ѻس�������

	MOV CX,10
	LEA SI,IN_GOODS
	ADD SI,2
	MOV Z_COUNT,N
	LEA DI,GA1
	JMP CMPGOODS1

NOTCMP:
	ADD DI,20
	SUB Z_COUNT,1
	JNZ CMPGOODS1
	JZ SARTE

CMPGOODS1:
	MOV BL,[SI]		;�Ƚ���Ʒ����
	CMP BL,[DI]
	JNE NOTCMP
	INC SI
	INC DI
	SUB CX,1
	JNZ CMPGOODS1
	RET
C1:
	MOV CR,1
	RET
FUNCTION1 ENDP


FUNCTION2 PROC
	PRINT SHOPNAME 	;�����ʾ

	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H

	MOV AH,1
	INT 21H

	CMP AL,'1'
	JZ ONE
	JNE TWO
ONE:
	LEA BX,GA1
	JMP L
TWO:
	LEA BX,GB1
	JMP L
L:
	MOV DL, 0AH             ; ���з�
    MOV AH, 2H
    INT 21H
	MOV DL, 0DH             ; ���з�
    MOV AH, 2H
    INT 21H
	PUSH BX
	CALL FUNCTION1
	POP BX
	RET
FUNCTION2 ENDP

F2T10 PROC FAR
	PUSH EBX
	PUSH SI
	LEA SI,BUF
	CMP DX,32
	JE B
	MOVSX EAX,AX
B:
	OR EAX,EAX
	JNS PLUS
	NEG EAX
	MOV BYTE PTR [SI],'-'
	INC SI
PLUS:
	MOV EBX,10
	CALL RADIX
	MOV BYTE PTR [SI],'$'
	LEA DX,BUF
	MOV AH,9
	INT 21H
	POP SI
	POP EBX
	RET
F2T10 ENDP

RADIX PROC FAR
	PUSH CX
	PUSH EDX
	XOR CX,CX
LOP1:
	XOR EDX,EDX
	DIV EBX
	PUSH DX
	INC CX
	OR EAX,EAX
	JNZ LOP1
LOP2:
	POP AX
	CMP AL,10
	JB L1
	ADD AL,7
L1:
	ADD AL,30H
	MOV [SI],AL
	INC SI
	LOOP LOP2
	POP EDX
	POP CX
	RET
RADIX ENDP

	CODE ENDS
	END	START
