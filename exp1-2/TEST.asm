.386
DATA  SEGMENT  USE16
BUF    DB  'HOW  ARE  YOU ! $'
DATA  ENDS
STACK SEGMENT USE16 STACK
      DB  200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
ASSUME CS:CODE , DS:DATA , SS: STACK
START:MOV  AX,DATA
            MOV  DS,AX
            LEA  DX,BUF
            MOV  AH,9            ; ÊäÈë×Ö·û´®
            INT   21H
            MOV  AH, 4CH
            INT 21H
CODE   ENDS
       END  START
