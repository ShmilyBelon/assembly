
NAME   PART2
EXTRN  S1:BYTE, GA1:BYTE ,GA2:BYTE,GA3:BYTE,S2:BYTE,GB1:BYTE,GB2:BYTE,GB3:BYTE,F2T10:FAR,RADIX:FAR,BUF:BYTE
PUBLIC FUNC3_4,FUNC3_5,FUNC3_6


.386
DATA SEGMENT USE16 PARA  PUBLIC
N = 3

BUF7    DB  0AH,0DH,0AH,0DH,'$'
BUF8    DB  0AH,0DH,'$'
BUF9    DB  '  ','$'


JINJIA    DW  0 , 0
SHOUJIA   DW  0 , 0
LIRUN     DW  0 , 0
PINGJUN   DW  0 , 0

JINJIAN    DW  0 , 0
SHOUJIAN   DW   0 , 0
LIRUNN     DW   0 , 0
PINGJUNN   DW   0 , 0

COUNT      DW   N
MAX        DW   -120

DATA ENDS

STACK SEGMENT USE16   PARA STACK 'STACK'
      DB  200  DUP(0)
STACK ENDS

CODE   SEGMENT  USE16 PARA PUBLIC 'CODE'
       ASSUME  CS: CODE , DS: DATA , SS: STACK

;��ڲ����ͳ��ڲ�������
;ʵ�ֹ��ܣ�����ÿ����Ʒ��ƽ��������
FUNC3_4  PROC  FAR

              PUSHA   ;�ֳ�������8��16λ�Ĵ���˳����ջ
              LEA  SI  , GA1
              LEA  DI  ,  GB1


        _F41:
              MOV  AX , [SI+10]
              XOR  AX , 'u'
              IMUL AX , [SI+14]
              MOV  JINJIA , AX    ;����SHOP1 ��Ʒi �ܵĽ���
              MOV  AX , [SI+12]
              IMUL AX , [SI+16]
              MOV  SHOUJIA , AX    ;����SHOP1 ��Ʒi �ܵ��ۼ�

              SUB  AX , JINJIA    ;����SHOP1 ��Ʒi �ܵ��ۼ�-�ܵĽ���
              MOV  LIRUN ,  AX    ;��������
              MOV  CX , 100
              IMUL CX        ;�������100 Ϊ�˺�������������׼��


              IDIV  JINJIA   ;�������100  �����ܵĽ���
              MOV   [SI+18] , AX ;����������


              MOV  AX , [DI+10]
              XOR  AX , 'u'
              IMUL AX , [DI+14]
              MOV  JINJIA+1 , AX    ;����SHOP2 ��Ʒi �ܵĽ���
              MOV  AX , [DI+12]
              IMUL AX , [DI+16]
              MOV  SHOUJIA+1 , AX    ;����SHOP2 ��Ʒi �ܵ��ۼ�

              SUB  AX , JINJIA+1    ;����SHOP2 ��Ʒi �ܵ��ۼ�-�ܵĽ���
              MOV  LIRUN+1 ,  AX    ;��������
              MOV  CX , 100
              IMUL CX              ;�������100 Ϊ�˺�������������׼��

            ;  CWD
              IDIV  JINJIA+1       ;�������100  �����ܵĽ���
            ;  MOV   [DI+18] , AX ;����������




              ADD   AX , [SI+18]  ;������Ʒi ��������֮��
              CWD
              MOV   CX , 2
              IDIV  CX          ;������������� ����2  �õ�ƽ��ֵ
              MOV   [SI+18] , AX     ;����ƽ��ֵ

              ADD   SI , 20    ;Ϊ�˼���shop1��һ����Ʒ��������
              ADD   DI , 20    ;Ϊ�˼���shop2��һ����Ʒ��������

              MOV  CX , COUNT  ; ����������1
              DEC  CX
              MOV  COUNT , CX
              CMP  CX , 0
              JNE  _F41        ;������0 ��������ʣ����Ʒ��������

              MOV  CX , 3
              MOV  COUNT , CX  ;�ָ�COUNT
              POPA   ;�ָ��ֳ�
              RET
  FUNC3_4   ENDP



  ;��ڲ����ͳ��ڲ�������
  ;ʵ�ֹ��ܣ�ÿ����Ʒ����ƽ������������
FUNC3_5  PROC  FAR
          PUSHA   ;�ֳ�������8��16λ�Ĵ���˳����ջ
          MOV  CX , N
          MOV  COUNT , CX  ;�����Ĵ�ѭ��������COUNT��ʼ��ΪN

          MOV  DX , 1  ;����˳��

     _BLOOP:   ;�����Ĵ�ѭ����ѭ��N��
          LEA  SI , GA1
          LEA  DI , GB1

          MOV  CX , N  ; Ѱ�ҵ�ǰ���ѭ���ļ�����
       ;;����ΪѰ�ҵ�ǰ���ֵ��ѭ����
       _F51:
          MOV  BX , [DI+18]
          CMP  BX , 0           ;�жϸ���Ʒ�Ƿ��Ѿ������˱��
          JNE   _F52            ;�Ѿ������˱��������

          MOV  AX , [SI+18]
          CMP  AX , MAX
          JLE  _F52             ;����Ʒ��ƽ�������ʵ������ֵ ������
          MOV  MAX , AX   ;����������ֵ
       _F52:
          ADD  SI , 20    ; �ж���һ����Ʒ
          ADD  DI , 20
          DEC  CX
          CMP  CX , 0
          JNE  _F51
        ;;����ΪѰ�ҵ�ǰ���ֵ��ѭ����ѭ��N��


       ;�����Ƿ����ŵ�ʵ��
          LEA  SI  , GA1
          LEA  DI  , GB1
          MOV  CX , N  ;������

     ;;�����Ƿ����ŵ�ѭ����
      _F53:
         MOV  AX , [SI+18]
         CMP  AX , MAX      ;�Ƚϵ�ǰ����Ʒ�Ƿ�Ϊ��ǰ�����ֵ
         JNE  _F54           ;������������
         MOV  [DI+18] , DX   ;������������
         INC  DX            ;�������

      _F54:
         ADD  SI , 20    ; �ж���һ����Ʒ
         ADD  DI , 20
         DEC  CX
         CMP  CX , 0
         JNE  _F53
     ;;�����Ƿ����ŵ�ѭ����


         MOV  CX , -120   ;�ٴν���ǰ�����ֵ��ʼ��Ϊ��С
         MOV  MAX , CX

         MOV  CX , COUNT   ;_BLOOP��ѭ���ļ�����
         DEC  CX
         MOV  COUNT , CX
         CMP  CX , 0
         JNE  _BLOOP
        ;;�����Ǵ�ѭ��_BLOOP��ѭ����


         MOV  CX , N     ;ѭ������֮�󣬻ָ�COUNT Ĭ��ֵ
         MOV  COUNT , CX


POPA   ;�ָ��ֳ�
RET

FUNC3_5   ENDP


;��ڲ����ͳ��ڲ�������
;ʵ�ֹ��ܣ���ʾ������Ʒ��Ϣ
FUNC3_6   PROC   FAR
        PUSHA ;�����ֳ�
      ;  LEA  BX  , S1
        LEA  SI ,  GA1
        LEA  DI  , GB1

        LEA  DX , S1 ;��ʾ�̵���
        MOV  AH , 9
        INT 21H


        MOV  CX , N
 _LP1:   ;�������������1��������Ʒ��Ϣ��ѭ��
        LEA  DX , BUF8  ;�س�
        MOV  AH , 9
        INT 21H

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H



        MOV  DX , SI  ;��ʾ��Ʒ��
        MOV  AH , 9
        INT 21H

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

       ;�������������(������)�����ۼۣ������ͣ������������������ͣ������������������ͣ����������Լ�����
        MOV  AX , [SI+10]
        XOR  AX , 'u'    ;����
        MOV  DX , 16
        CALL  F2T10

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

        MOV  AX , [SI+12]
        MOV  DX , 16
        CALL  F2T10

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

        MOV  AX , [SI+14]
        MOV  DX , 16
        CALL  F2T10

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

        MOV  AX , [SI+16]
        MOV  DX , 16
        CALL  F2T10

        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

        MOV  AX , [SI+18]  ;�����ǰ��Ʒ��������
        MOV  DX , 16
        CALL  F2T10


        MOV   DL ,'%'  ;��ʾ�ٷֺ�
        MOV   AH , 2
        INT 21H


        LEA  DX , BUF9  ;�ո�
        MOV  AH , 9
        INT 21H

        MOV  AX , [DI+18]  ;�����ǰ��Ʒ������������
        MOV  DX , 16
        CALL  F2T10

        LEA  DX , BUF8  ;�س�
        MOV  AH , 9
        INT 21H


        ADD  SI , 20    ;����1����һ����Ʒ
        ADD  DI , 20
        DEC  CX
        CMP  CX , 0
        JNE  _LP1

        ;�������������1��������Ʒ��Ϣ��ѭ��


        LEA  DX , BUF7  ;�����س�
        MOV  AH , 9
        INT 21H

        MOV  CX, N
        LEA  SI , GA1
        LEA  DI , GB1

        LEA  DX , S2   ;��ʾ�̵���
        MOV  AH , 9
        INT 21H


        _LP2:   ;�������������2��������Ʒ��Ϣ��ѭ��
               LEA  DX , BUF8  ;�س�
               MOV  AH , 9
               INT 21H

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H



               MOV  DX , DI  ;��ʾ��Ʒ��
               MOV  AH , 9
               INT 21H

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

              ;�������������(������)�����ۼۣ������ͣ������������������ͣ������������������ͣ����������Լ�����
               MOV  AX , [DI+10]
               XOR  AX , 'u'    ;����
               MOV  DX , 16
               CALL  F2T10

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

               MOV  AX , [DI+12]
               MOV  DX , 16
               CALL  F2T10

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

               MOV  AX , [DI+14]
               MOV  DX , 16
               CALL  F2T10

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

               MOV  AX , [DI+16]
               MOV  DX , 16
               CALL  F2T10

               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

               MOV  AX , [SI+18]  ;�����ǰ��Ʒ��������
               MOV  DX , 16
               CALL  F2T10


               MOV   DL ,'%'  ;��ʾ�ٷֺ�
               MOV   AH , 2
               INT 21H


               LEA  DX , BUF9  ;�ո�
               MOV  AH , 9
               INT 21H

               MOV  AX , [DI+18]  ;�����ǰ��Ʒ������������
               MOV  DX , 16
               CALL  F2T10

               LEA  DX , BUF8  ;�س�
               MOV  AH , 9
               INT 21H


               ADD  SI , 20    ;����1����һ����Ʒ
               ADD  DI , 20
               DEC  CX
               CMP  CX , 0
               JNE  _LP2

               ;�������������2��������Ʒ��Ϣ��ѭ��

               LEA  DX , BUF8  ;�س�
               MOV  AH , 9
               INT 21H


               POPA
               RET

FUNC3_6 ENDP

CODE  ENDS
      END