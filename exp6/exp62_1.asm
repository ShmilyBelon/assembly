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
       PUSHF                        ;��־�Ĵ�����ջ
       CALL  DWORD  PTR  OLD_INT  ;�����ϵ�16H�жϴ������
       CMP   AL , 97            ;�Ƚ������ascii��
       JAE   NEXT1
       JMP   QUIT
NEXT1: CMP   AL , 122          ;���Ǵ�д��ĸ����Сд��ĸ
       JBE   CAPS_LOCK
       JMP   QUIT
CAPS_LOCK:
       SUB AL,32

QUIT:  IRET

START: XOR  AX , AX
       MOV  DS , AX
       MOV  AX , DS:[16H*4]
       MOV  OLD_INT , AX           ;����ip
       MOV  AX , DS:[16H*4+2]
       MOV  OLD_INT+2 , AX         ;������׵�ַ
       CLI                         ;���ж�
       MOV  WORD PTR DS:[16H*4] , OFFSET NEW16H
       MOV  DS:[16H*4+2] , CS
       STI                         ;���ж�
       MOV  DX , OFFSET START+15
       SHR  DX , 4
       ADD  DX , 10H             ;�����ڴ�פ���������
       MOV  AL , 0
       MOV  AH , 31H             ;�ڴ�פ��
       INT  21H
CODE   ENDS
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS
       END START
