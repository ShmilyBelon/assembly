.386

STACK SEGMENT STACK USE16
      DB 200 DUP(0)
STACK ENDS
CODE SEGMENT USE16
     ASSUME CS:CODE ,SS:STACK
START:
      MOV  AL,  1H
      MOV  AH,  35H
      INT   21H

      MOV  AL , 10H
      MOV  AH , 35H
      INT  21H

      MOV  AH ,4CH
      INT 21H
CODE ENDS
   END START
