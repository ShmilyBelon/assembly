.386
CODE   SEGMENT   USE16
       ASSUME   CS:CODE , SS:STACK

START: XOR  AX , AX
       MOV  DS , AX
       CLI
       MOV  WORD PTR  DS:[16H*4] ,  11E0H   ;恢复正常16H号中断的ip
       MOV  WORD PTR  DS:[16H*4+2] , 0F000H  ;恢复正常16H号中断的CS
       STI

       MOV  AH , 4CH
       INT 21H

CODE   ENDS
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS
       END START
