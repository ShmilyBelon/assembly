.386
DATA SEGMENT USE16

BUF1    DB 'PLEASE INPUT YOUR USERNAME!',0AH,0DH,0AH,0DH,':$'
BUF2    DB 'PLEASE INPUT YOUR PASSWORD!',0AH,0DH,0AH,0DH,':$'
BUF3    DB 'WRONG USERNAME! PLEASE INPUT YOUR USERNAME AND PASSWORD AGAIN!',0AH,0DH,':$'
BUF4    DB 'WRONG PASSWORD! PLEASE INPUT YOUR USERNAME AND PASSWORD AGAIN!',0AH,0DH,':$'
BUF5    DB 'PLEASE INPUT THE GOODS YOU WANNA QUERY',0AH,0DH,0AH,0DH,':$'
BUF6    DB 'THE GOODS DOES NOT EXSIT , INPUT AGAIN!',0AH,0DH,0AH,0DH,':$'
BUF7    DB  0AH,0DH,0AH,0DH,'$'
IN_NAME DB  80
        DB  ?
        DB  80 DUP('$')
IN_PWD  DB  80
        DB  ?
        DB  80 DUP('$')
IN_GOODS DB  80
         DB   ?
         DB   80 DUP('$')

AUTH    DB  -1


BNAME  DB  'CHENGUOX',0,0  ;�ϰ��������������Լ����ֵ�ƴ����
BPASS  DB  'test',0,0    ;������
N      EQU   102
S1     DB  'SHOP1',0           ;�������ƣ���0����
GA1    DB   'Bag', 7 DUP(0)  ; ��Ʒ����
       DW   35,56,1000,1,?  ;�����ʻ�δ����  ������(������)�����ۼۣ������ͣ������������������ͣ������������������ͣ�
GA2    DB    'BOOK', 6 DUP(0) ; ��Ʒ����
       DW   12,30,25,5,?   ;�����ʻ�δ����
GAN    DB   N-2 DUP( 'Temp-Value', 15,0,20,0,?,30,0,2,0,?) ;����2���Ѿ����嶨������Ʒ��Ϣ���⣬������Ʒ��Ϣ��ʱ�ٶ�Ϊһ���ġ�
S2     DB  'SHOP2',0           ;�������ƣ���0����
GB1    DB    'Bag', 7 DUP(0)  ; ��Ʒ����
       DW   35,50,1000,1,?  ;�����ʻ�δ����

GB2    DB  'BOOK', 6 DUP(0) ; ��Ʒ����
       DW   12,28,20,15,?   ;�����ʻ�δ����


JINJIA    DW  0 , 0
SHOUJIA   DW  0 , 0
LIRUN     DW  0 , 0
PINGJUN   DW  0 , 0

JINJIAN    DW  0 , 0
SHOUJIAN   DW   0 , 0
LIRUNN     DW   0 , 0
PINGJUNN   DW   0 , 0


DATA ENDS

STACK SEGMENT USE16 STACK
      DB  200  DUP(0)
STACK ENDS

CODE   SEGMENT  USE16
       ASSUME  CS: CODE , DS: DATA , SS: STACK

START: MOV    AX , DATA
       MOV    DS , AX
FUNC1: LEA    DX , BUF1   ;��ʾ�û������û���
       MOV    AH , 9
       INT    21H

       LEA   DX , IN_NAME  ;�����û�������û���
       MOV   AH , 10
       INT   21H

       LEA    DX , BUF2   ;��ʾ�û���������
       MOV    AH , 9
       INT    21H

       LEA   DX , IN_PWD  ;�����û����������
       MOV   AH , 10
       INT   21H

       MOV   DL , 0DH    ;�Ƚ��û�������û����ĵ�һ���ַ��ǲ���'\n'
       CMP   DL , IN_NAME+2
       JE    NEXT1       ;�����\n AUTH��ֵ0 ֱ����ת����3
       JMP   NEXT2       ;�������ǲ���q
NEXT1: MOV   AUTH , 0
       JMP  FUNC3

NEXT2: MOV   DL , 'q'    ;����û�����q
       CMP   DL , IN_NAME+2
       JE    NEXT3
       JMP   FUNC2
NEXT3: MOV   DL , 0DH  ; ����û�������ǲ��ǽ�����q
       CMP   DL , IN_NAME+3
       JE    OVER
       JMP   FUNC2

FUNC2: ;MOV  CX , 8       ;ѭ���Ƚ��û��������Ƿ���ȷ
       MOV  SI , -1
NEXT4: INC  SI
       MOV  DL , BNAME[SI]
       CMP  DL , IN_NAME[SI+2]
       JE   NEXT4
       JMP  NEXT5

NEXT5: MOV  AL , 0DH         ;�����Ƚ��û�����ĵ�9���ַ��ǲ��ǻس�
       CMP  SI , 8
       JE   NEXT5_A
       JMP  NEXT5_B
NEXT5_A: CMP  AL , IN_NAME[SI+2]
         JE   NEXT6_            ;�û�����ȷ

NEXT5_B: LEA    DX , BUF3   ;�û������� ��ʾ�û����������û���
       MOV    AH , 9
       INT    21H
       JMP    FUNC1    ;�ص�����1


NEXT6_:  MOV  SI , -1  ;ѭ����������Ƿ���ȷ
NEXT6: INC  SI
       MOV  DL , BPASS[SI]
       CMP  DL , IN_PWD[SI+2]
       JE   NEXT6
       JMP  NEXT7

      NEXT7:  MOV  AL , 0DH
              CMP  SI , 4
              JE   NEXT7_A
              JMP  NEXT7_B
      NEXT7_A: CMP AL , IN_PWD[SI+2]
               JE  NEXT8          ;������ȷ

      NEXT7_B: LEA    DX , BUF4   ;������� ��ʾ�û�������������
              MOV    AH , 9
              INT    21H
              JMP    FUNC1    ;�ص�����1

NEXT8: MOV    AUTH , 1

FUNC3:

        LEA    DX , BUF5  ;�����ʾ��Ϣ����ʾ�û�����Ҫ��ѯ����Ʒ
        MOV    AH , 9
        INT    21H


        LEA   DX , IN_GOODS  ;�����û������Ҫ��ѯ����Ʒ��
        MOV   AH , 10
        INT   21H

        LEA  DX , BUF7  ;����
        MOV  AH , 9
        INT  21H


        MOV   DL , 0DH      ;���ֻ����س�����ת����1
        CMP   IN_GOODS+2 , DL
        JE    FUNC1

      ;  MOV     AL , 1     ;�жϵ�¼״̬
      ;  CMP     AL , AUTH
      ;  JE      NEXT9
      ;  JMP     SHOW6    ;���û�е�¼ ֻ��ʾ��Ʒ����Ȼ����ת����1


;����Ѿ���¼
NEXT9:   MOV  SI , -1
NEXT10:  INC  SI
         MOV  DL , GA1[SI]
         CMP  DL , IN_GOODS[SI+2]
         JE   NEXT10
         JMP  NEXT11

NEXT11:  MOV  AL , 0DH
         CMP  SI , 3                  ;ƥ�� Bag
         JE   NEXT12_A
         JMP  NEXT12_B
NEXT12_A: CMP  AL , IN_GOODS[SI+2]   ;�����Ƚ��û�����ĵ�4���ַ��ǲ��ǻس�
          JE   NEXT13               ;�̵�1�е�Bagƥ����ȷ,������������ʣ��Լ�ƽ��������

          NEXT12_B:   MOV  SI , -1
          NEXT12_B1:  INC  SI
                      MOV  DL , GA2[SI]
                      CMP  DL , IN_GOODS[SI+2]
                      JE   NEXT12_B1
                      ;JMP  NEXT12_B2

          NEXT12_B2:  MOV  AL , 0DH
                      CMP  SI , 4                  ;ƥ�� BOOK
                      JE   NEXT12_B3
                      JMP  ERROR1
          NEXT12_B3:   CMP  AL , IN_GOODS[SI+2]   ;�����Ƚ��û�����ĵ�5���ַ��ǲ��ǻس�
                      JE   NEXT14               ;�̵�1�е�BOOKƥ����ȷ,������������ʣ��Լ�ƽ��������


ERROR1:   LEA    DX , BUF6   ;��Ʒ��������� ��ʾ�û���������
          MOV    AH , 9
          INT    21H
          JMP    FUNC3    ;�ص�����3













NEXT13: ;����Ϊ��Bag �Ĵ���

      MOV     AL , 1     ;�жϵ�¼״̬
      CMP     AL , AUTH
      JNE      SHOW6      ;���û�е�¼ ֻ��ʾ��Ʒ����Ȼ����ת����1

      MOV  AX , 0 ;��ʼ��ʱ
      CALL TIMER

LOOP1:


      MOV  AX , WORD PTR GA1+10
      IMUL AX , WORD PTR GA1+14
      MOV  JINJIA , AX    ;����SHOP1 Bag �ܵĽ���
      MOV  AX , WORD PTR GA1+12
      IMUL AX , WORD PTR GA1+16
      MOV  SHOUJIA , AX    ;����SHOP1 Bag �ܵ��ۼ�

      SUB  AX , JINJIA    ;����SHOP1 Bag �ܵ��ۼ�-�ܵĽ���
      MOV  LIRUN ,  AX    ;��������
      MOV  CX , 100
      IMUL CX        ;�������100 Ϊ�˺�������������׼��


      IDIV  JINJIA   ;�������100  �����ܵĽ���
      MOV   WORD PTR GA1+18 , AX ;����������


      MOV  AX , WORD PTR GB1+10
      IMUL AX , WORD PTR GB1+14
      MOV  JINJIA+1 , AX    ;����SHOP2 Bag �ܵĽ���
      MOV  AX , WORD PTR GB1+12
      IMUL AX , WORD PTR GB1+16
      MOV  SHOUJIA+1 , AX    ;����SHOP2 Bag �ܵ��ۼ�

      SUB  AX , JINJIA+1    ;����SHOP2 Bag �ܵ��ۼ�-�ܵĽ���
      MOV  LIRUN+1 ,  AX    ;��������
      MOV  CX , 100
      IMUL CX              ;�������100 Ϊ�˺�������������׼��

    ;  CWD
      IDIV  JINJIA+1       ;�������100  �����ܵĽ���
      MOV   WORD PTR GB1+18 , AX ;����������




      ADD   AX , WORD PTR GA1+18  ;����Bag ��������֮��
      CWD
      MOV   CX , 2
      IDIV  CX          ;������������� ����2  �õ�ƽ��ֵ
      MOV   PINGJUN , AX     ;����ƽ��ֵ

      MOV  SI , OFFSET GAN+10
      MOV  CX , N
      DEC  CX
      DEC  CX

USELESS:
      MOV  AL , [SI]   ;ȡ����һ����Ʒ�Ľ���
      CBW              ;��չ��16λ
      MOV  BL , [SI+2] ;ȡ����������
      MOV  BH , 0      ;�൱�ڷ�����չ ��Ϊ��ʼ�����8λװ����
      IMUL  AX , BX    ;�ܵĽ�����
      MOV   JINJIAN , AX  ;����


      MOV  AL , [SI+1]   ;ȡ����һ����Ʒ���ۼ�
      CBW               ;��չ��16λ
      MOV  BL , [SI+3]  ;ȡ���۳�����
      MOV  BH , 0       ;�൱�ڷ�����չ ��Ϊ��ʼ�����8λװ����
      IMUL  AX , BX     ;�ܵ��ۼ�
      MOV   SHOUJIAN , AX  ;����

      MOV   BX , JINJIAN  ;ȡ���ܵĽ���
      SUB   AX , BX       ;�ܵ��ۼۼ�ȥ����
      MOV   DX ,100
      IMUL  DX        ;���������100
      IDIV  JINJIAN        ;�ܵ������100�����Խ���
      MOV   LIRUNN , AX    ;�����������



      MOV  AL , [SI+5]   ;ȡ����2����Ʒ�Ľ���
      CBW              ;��չ��16λ
      MOV  BL , [SI+7] ;ȡ����������
      MOV  BH , 0      ;�൱�ڷ�����չ ��Ϊ��ʼ�����8λװ����
      IMUL  AX , BX    ;�ܵĽ�����
      MOV   JINJIAN +2, AX  ;����


      MOV  AL , [SI+6]   ;ȡ����2����Ʒ���ۼ�
      CBW               ;��չ��16λ
      MOV  BL , [SI+8]  ;ȡ���۳�����
      MOV  BH , 0       ;�൱�ڷ�����չ ��Ϊ��ʼ�����8λװ����
      IMUL  AX , BX     ;�ܵ��ۼ�
      MOV   SHOUJIAN+2 , AX  ;����

      MOV   BX , JINJIAN+2 ;ȡ���ܵĽ���
      SUB   AX , BX       ;�ܵ��ۼۼ�ȥ����
      MOV   DX ,100
      IMUL  DX        ;���������100
      IDIV  JINJIAN+2        ;�ܵ������100�����Խ���
      MOV   LIRUNN+2 , AX    ;�����������

      MOV   BX , LIRUNN      ;ȡ����һ����Ʒ��������
      ADD   AX , BX          ;���������
      MOV   DI , 2
      IDIV  DI
    ;  SAR   AX , 1           ;�����ʳ���2

      MOV   [SI+4] , AX      ;����ƽ��������
      MOV   [SI+9] , AX      ;����ƽ��������

      MOV   AX , 20
      ADD   SI , AX          ;ƫ�Ƶ�ַ��20


      DEC  CX
      CMP  CX , 0
      JNE  USELESS      ;ѭ��ˢ����Ʒ��ƽ��������






      MOV  DX ,  WORD PTR GA1+16  ;�������1
      INC  DX
      MOV  WORD PTR GA1+16 , DX

      CMP  DX , 1000 ;
      JNE  LOOP1

      MOV  DX,1
      MOV  WORD PTR GA1+16,DX ;�����������ٴ���1

      MOV   AX , 1
      CALL  TIMER  ;������ʱ ��ʾʱ��

      JMP   BIJIAO

 NEXT14:
    ;�����Ƕ�book�� �������Լ�ƽ�������ʵļ���

      MOV     AL , 1     ;�жϵ�¼״̬
      CMP     AL , AUTH
      JNE      SHOW6      ;���û�е�¼ ֻ��ʾ��Ʒ����Ȼ����ת����1



       MOV  AX , 0 ;��ʼ��ʱ
       CALL TIMER

LOOP2:
      MOV  AX , WORD PTR GA2+10
      IMUL AX , WORD PTR GA2+14
      MOV  JINJIA , AX    ;����SHOP1 BOOK �ܵĽ���
      MOV  AX , WORD PTR GA2+12
      IMUL AX , WORD PTR GA2+16
      MOV  SHOUJIA , AX    ;����SHOP1 BOOK �ܵ��ۼ�

      SUB  AX , JINJIA    ;����SHOP1 BOOK �ܵ��ۼ�-�ܵĽ���
      MOV  LIRUN ,  AX    ;��������
      MOV  CX ,100
      IMUL CX       ;�������10 Ϊ�˺�������������׼��

      ;CWD
      IDIV  JINJIA   ;�������100  �����ܵĽ���
      MOV   WORD PTR GA2+18 , AX ;����������


      MOV  AX , WORD PTR GB2+10
      IMUL AX , WORD PTR GB2+14
      MOV  JINJIA+1 , AX    ;����SHOP2 BOOK �ܵĽ���
      MOV  AX , WORD PTR GB2+12
      IMUL AX , WORD PTR GB2+16
      MOV  SHOUJIA+1 , AX    ;����SHOP2 BOOK �ܵ��ۼ�

      SUB  AX , JINJIA+1    ;����SHOP2 BOOK �ܵ��ۼ�-�ܵĽ���
      MOV  LIRUN+1 ,  AX    ;��������
      MOV   CX , 100
      IMUL  CX       ;�������10 Ϊ�˺�������������׼��

      ;CWD
      IDIV  JINJIA+1   ;�������100  �����ܵĽ���
      MOV   WORD PTR GB2+18 , AX ;����������




      ADD   AX , WORD PTR GA2+18  ;����BOOK ��������֮��
      CWD
      MOV   CX , 2
      IDIV  CX          ;������������� ����2  �õ�ƽ��ֵ
      MOV   PINGJUN+1 , AX     ;����ƽ��ֵ

      MOV  DX , WORD PTR GA2+16   ;��������1
      INC  DX
      MOV  WORD PTR GA2+16,DX

      CMP  DX , 1000
      JNE  LOOP2

      MOV  DX , WORD PTR GA2+16   ;���������±�Ϊ1
      MOV  DX , 1
      MOV  WORD PTR GA2+16,DX


      MOV   AX , 1
      CALL  TIMER  ;������ʱ ��ʾʱ��


      JMP   BIJIAO







BIJIAO:;�����ж�
     CMP   AX , 90
     JG    SHOW1
     JE    SHOW1

     CMP   AX , 50
     JG    SHOW2
     JE    SHOW2

     CMP   AX , 20
     JG    SHOW3
     JE    SHOW3


     CMP   AX , 0
     JG    SHOW4
     JE    SHOW4

     JMP   SHOW5  ;���϶�������  ��ʾF






SHOW1:   MOV  DL , 'A'  ;��ʾƽ�������ʵĵȼ�
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;����
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;�ص�����1


SHOW2:   MOV  DL , 'B'  ;��ʾƽ�������ʵĵȼ�
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;����
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;�ص�����1


 SHOW3:   MOV  DL , 'C'  ;��ʾƽ�������ʵĵȼ�
          MOV  AH , 2
          INT  21H

          LEA  DX , BUF7  ;����
          MOV  AH , 9
          INT  21H
          JMP FUNC1      ;�ص�����1


SHOW4:   MOV  DL , 'D'  ;��ʾƽ�������ʵĵȼ�
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;����
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;�ص�����1


SHOW5:   MOV  DL , 'F'  ;��ʾƽ�������ʵĵȼ�
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;����
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;�ص�����1


SHOW6:  LEA   DX , IN_GOODS+2  ;�û�û�е�¼ �� ����ʾ����Ļ���
        MOV  AH , 9
        INT  21H

        LEA  DX , BUF7  ;����
        MOV  AH , 9
        INT  21H
        JMP FUNC1      ;�ص�����1


TIMER	PROC
        	PUSH  DX
        	PUSH  CX
        	PUSH  BX
        	MOV   BX, AX
        	MOV   AH, 2CH
        	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
        	MOV   AL, DH
        	MOV   AH, 0
        	IMUL  AX,AX,1000
        	MOV   DH, 0
        	IMUL  DX,DX,10
        	ADD   AX, DX
        	CMP   BX, 0
        	JNZ   _T1
        	MOV   CS:_TS, AX
        _T0:	POP   BX
        	POP   CX
        	POP   DX
        	RET
        _T1:	SUB   AX, CS:_TS
        	JNC   _T2
        	ADD   AX, 60000
        _T2:	MOV   CX, 0
        	MOV   BX, 10
        _T3:	MOV   DX, 0
        	DIV   BX
        	PUSH  DX
        	INC   CX
        	CMP   AX, 0
        	JNZ   _T3
        	MOV   BX, 0
        _T4:	POP   AX
        	ADD   AL, '0'
        	MOV   CS:_TMSG[BX], AL
        	INC   BX
        	LOOP  _T4
        	PUSH  DS
        	MOV   CS:_TMSG[BX+0], 0AH
        	MOV   CS:_TMSG[BX+1], 0DH
        	MOV   CS:_TMSG[BX+2], '$'
        	LEA   DX, _TS+2
        	PUSH  CS
        	POP   DS
        	MOV   AH, 9
        	INT   21H
        	POP   DS
        	JMP   _T0
        _TS	DW    ?
         	DB    'Time elapsed in ms is '
        _TMSG	DB    12 DUP(0)
        TIMER   ENDP






OVER: MOV   AH , 4CH  ;����
      INT   21H
CODE  ENDS
      END  START