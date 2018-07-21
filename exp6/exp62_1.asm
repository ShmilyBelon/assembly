.386
CODE   SEGMENT USE16
       ASSUME CS:CODE,SS:STACK
OLD_INT DW ?,?

NEW16H:CMP  AH , 0
       JE   CMPC
       CMP  AH , 10H
       JE   CMPC
       JMP  DWORD PTR OLD_INT
CMPC:
       PUSHF                        ;标志寄存器入栈
       CALL  DWORD  PTR  OLD_INT  ;调用老的16H中断处理程序
       CMP   AL , 97            ;比较输入的ascii码
       JAE   NEXT1
       JMP   QUIT
NEXT1: CMP   AL , 122          ;若是大写字母则变成小写字母
       JBE   CAPS_LOCK
       JMP   QUIT
CAPS_LOCK:
       SUB AL,32

QUIT:  IRET

START: XOR  AX , AX
       MOV  DS , AX
       MOV  AX , DS:[16H*4]
       MOV  OLD_INT , AX           ;保存ip
       MOV  AX , DS:[16H*4+2]
       MOV  OLD_INT+2 , AX         ;保存段首地址
       CLI                         ;关中断
       MOV  WORD PTR DS:[16H*4] , OFFSET NEW16H
       MOV  DS:[16H*4+2] , CS
       STI                         ;开中断
       MOV  DX , OFFSET START+15
       SHR  DX , 4
       ADD  DX , 10H             ;计算内存驻留保存节数
       MOV  AL , 0
       MOV  AH , 31H             ;内存驻留
       INT  21H
CODE   ENDS
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS
       END START
