.386
STACK SEGMENT USE16 STACK
      DB 200 DUP(0)
STACK ENDS

DATA  SEGMENT USE16
XUEHAO  DB  4 DUP(0)

DATA  ENDS
CODE  SEGMENT  USE16
      ASSUME CS:CODE, DS:DATA, SS:STACK
START: MOV   AX,DATA   ;寄存器直接寻址
       MOV   DS,AX     ;寄存器直接寻址
       MOV   SI,OFFSET   XUEHAO  ;寄存器直接寻址
       MOV   AL,'0'  ;寄存器直接寻址
       MOV   BL,'4'  ;寄存器直接寻址
       MOV   CL,'8'  ;寄存器直接寻址
       MOV   DL,'9'  ;寄存器直接寻址
       MOV   [SI],AL  ;寄存器间接寻址
       MOV   [SI+1],BL ;变址寻址
       MOV   XUEHAO+2,CL ;直接寻址
       MOV   SI,1H   ;寄存器直接寻址
       MOV   BX,OFFSET   XUEHAO  ;寄存器直接寻址
       MOV   2[BX][SI], DL   ;基址加变址寻址
CODE   ENDS
       END   START
