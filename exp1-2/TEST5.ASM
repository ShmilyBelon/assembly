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


BNAME  DB  'CHENGUOX',0,0  ;老板姓名（必须是自己名字的拼音）
BPASS  DB  'test',0,0    ;；密码
N      EQU   30
S1     DB  'SHOP1',0           ;网店名称，用0结束
GA1    DB   'PEN', 7 DUP(0)  ; 商品名称
       DW   35,56,70,25,?  ;利润率还未计算  进货价(字类型)，销售价（字类型），进货总数（字类型），已售数量（字类型）
GA2    DB    'BOOK', 6 DUP(0) ; 商品名称
       DW   12,30,25,5,?   ;利润率还未计算
GAN    DB   N-2 DUP( 'Temp-Value',15,0,20,0,30,0,2,0,?,?) ;除了2个已经具体定义了商品信息以外，其他商品信息暂时假定为一样的。
S2     DB  'SHOP2',0           ;网店名称，用0结束
GB1    DB    'PEN', 7 DUP(0)  ; 商品名称
       DW   35,50,30,24,?  ;利润率还未计算

GB2    DB  'BOOK', 6 DUP(0) ; 商品名称
       DW   12,28,20,15,?   ;利润率还未计算


JINJIA    DW  0 , 0
SHOUJIA   DW  0 , 0
LIRUN     DW  0 , 0
PINGJUN   DW  0 , 0



DATA ENDS

STACK SEGMENT USE16 STACK
      DB  200  DUP(0)
STACK ENDS

CODE   SEGMENT  USE16
       ASSUME  CS: CODE , DS: DATA , SS: STACK

START: MOV    AX , DATA
       MOV    DS , AX
FUNC1: LEA    DX , BUF1   ;提示用户输入用户名
       MOV    AH , 9
       INT    21H

       LEA   DX , IN_NAME  ;读入用户输入的用户名
       MOV   AH , 10
       INT   21H

       LEA    DX , BUF2   ;提示用户输入密码
       MOV    AH , 9
       INT    21H

       LEA   DX , IN_PWD  ;读入用户输入的密码
       MOV   AH , 10
       INT   21H

       MOV   DL , 0DH    ;比较用户输入的用户名的第一个字符是不是'\n'
       CMP   DL , IN_NAME+2
       JE    NEXT1       ;如果是\n AUTH赋值0 直接跳转功能3
       JMP   NEXT2       ;否则检查是不是q
NEXT1: MOV   AUTH , 0
       JMP  FUNC3

NEXT2: MOV   DL , 'q'    ;如果用户名是q
       CMP   DL , IN_NAME+2
       JE    NEXT3
       JMP   FUNC2
NEXT3: MOV   DL , 0DH  ; 检查用户输入的是不是仅仅是q
       CMP   DL , IN_NAME+3
       JE    OVER
       JMP   FUNC2

FUNC2: ;MOV  CX , 8       ;循环比较用户名输入是否正确
       MOV  SI , -1
NEXT4: INC  SI
       MOV  DL , BNAME[SI]
       CMP  DL , IN_NAME[SI+2]
       JE   NEXT4
       JMP  NEXT5

NEXT5: MOV  AL , 0DH         ;用来比较用户输入的第9个字符是不是回车
       CMP  SI , 8
       JE   NEXT5_A
       JMP  NEXT5_B
NEXT5_A: CMP  AL , IN_NAME[SI+2]
         JE   NEXT6_            ;用户名正确

NEXT5_B: LEA    DX , BUF3   ;用户名错误， 提示用户重新输入用户名
       MOV    AH , 9
       INT    21H
       JMP    FUNC1    ;回到功能1


NEXT6_:  MOV  SI , -1  ;循环检查密码是否正确
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
               JE  NEXT8          ;密码正确

      NEXT7_B: LEA    DX , BUF4   ;密码错误， 提示用户重新输入密码
              MOV    AH , 9
              INT    21H
              JMP    FUNC1    ;回到功能1

NEXT8: MOV    AUTH , 1

FUNC3:

        LEA    DX , BUF5  ;输出提示信息，提示用户输入要查询的商品
        MOV    AH , 9
        INT    21H


        LEA   DX , IN_GOODS  ;读入用户输入的要查询的商品名
        MOV   AH , 10
        INT   21H

        LEA  DX , BUF7  ;换行
        MOV  AH , 9
        INT  21H


        MOV   DL , 0DH      ;如果只输入回车，跳转功能1
        CMP   IN_GOODS+2 , DL
        JE    FUNC1

      ;  MOV     AL , 1     ;判断登录状态
      ;  CMP     AL , AUTH
      ;  JE      NEXT9
      ;  JMP     SHOW6    ;如果没有登录 只显示商品名，然后跳转功能1


;如果已经登录
NEXT9:   MOV  SI , -1
NEXT10:  INC  SI
         MOV  DL , GA1[SI]
         CMP  DL , IN_GOODS[SI+2]
         JE   NEXT10
         JMP  NEXT11

NEXT11:  MOV  AL , 0DH
         CMP  SI , 3                  ;匹配 PEN
         JE   NEXT12_A
         JMP  NEXT12_B
NEXT12_A: CMP  AL , IN_GOODS[SI+2]   ;用来比较用户输入的第4个字符是不是回车
          JE   NEXT13               ;商店1中的PEN匹配正确,下面计算利润率，以及平均利润率

          NEXT12_B:   MOV  SI , -1
          NEXT12_B1:  INC  SI
                      MOV  DL , GA2[SI]
                      CMP  DL , IN_GOODS[SI+2]
                      JE   NEXT12_B1
                      ;JMP  NEXT12_B2

          NEXT12_B2:  MOV  AL , 0DH
                      CMP  SI , 4                  ;匹配 BOOK
                      JE   NEXT12_B3
                      JMP  ERROR1
          NEXT12_B3:   CMP  AL , IN_GOODS[SI+2]   ;用来比较用户输入的第5个字符是不是回车
                      JE   NEXT14               ;商店1中的BOOK匹配正确,下面计算利润率，以及平均利润率


ERROR1:   LEA    DX , BUF6   ;商品名输入错误， 提示用户重新输入
          MOV    AH , 9
          INT    21H
          JMP    FUNC3    ;回到功能3













NEXT13: ;以下为对PEN 的处理

      MOV     AL , 1     ;判断登录状态
      CMP     AL , AUTH
      JNE      SHOW6      ;如果没有登录 只显示商品名，然后跳转功能1






      MOV  AX , WORD PTR GA1+10
      IMUL AX , WORD PTR GA1+14
      MOV  JINJIA , AX    ;计算SHOP1 PEN 总的进价
      MOV  AX , WORD PTR GA1+12
      IMUL AX , WORD PTR GA1+16
      MOV  SHOUJIA , AX    ;计算SHOP1 PEN 总的售价

      SUB  AX , JINJIA    ;计算SHOP1 PEN 总的售价-总的进价
      MOV  LIRUN ,  AX    ;保存利润
      MOV  CX , 100
      IMUL CX        ;利润乘以100 为了后面算利润率做准备


      IDIV  JINJIA   ;利润乘以100  除以总的进价
      MOV   WORD PTR GA1+18 , AX ;保存利润率


      MOV  AX , WORD PTR GB1+10
      IMUL AX , WORD PTR GB1+14
      MOV  JINJIA+1 , AX    ;计算SHOP2 PEN 总的进价
      MOV  AX , WORD PTR GB1+12
      IMUL AX , WORD PTR GB1+16
      MOV  SHOUJIA+1 , AX    ;计算SHOP2 PEN 总的售价

      SUB  AX , JINJIA+1    ;计算SHOP2 PEN 总的售价-总的进价
      MOV  LIRUN+1 ,  AX    ;保存利润
      MOV  CX , 100
      IMUL CX              ;利润乘以100 为了后面算利润率做准备

    ;  CWD
      IDIV  JINJIA+1       ;利润乘以100  除以总的进价
      MOV   WORD PTR GB1+18 , AX ;保存利润率




      ADD   AX , WORD PTR GA1+18  ;两个PEN 的利润率之和
      CWD
      MOV   CX , 2
      IDIV  CX          ;两个利润率相加 除以2  得到平均值
      MOV   PINGJUN , AX     ;保存平均值
      JMP   BIJIAO

 NEXT14:
    ;以下是对book的 利润率以及平均利润率的计算

      MOV     AL , 1     ;判断登录状态
      CMP     AL , AUTH
      JNE      SHOW6      ;如果没有登录 只显示商品名，然后跳转功能1


      MOV  AX , WORD PTR GA2+10
      IMUL AX , WORD PTR GA2+14
      MOV  JINJIA , AX    ;计算SHOP1 BOOK 总的进价
      MOV  AX , WORD PTR GA2+12
      IMUL AX , WORD PTR GA2+16
      MOV  SHOUJIA , AX    ;计算SHOP1 BOOK 总的售价

      SUB  AX , JINJIA    ;计算SHOP1 BOOK 总的售价-总的进价
      MOV  LIRUN ,  AX    ;保存利润
      MOV  CX ,100
      IMUL CX       ;利润乘以10 为了后面算利润率做准备

      ;CWD
      IDIV  JINJIA   ;利润乘以100  除以总的进价
      MOV   WORD PTR GA2+18 , AX ;保存利润率


      MOV  AX , WORD PTR GB2+10
      IMUL AX , WORD PTR GB2+14
      MOV  JINJIA+1 , AX    ;计算SHOP2 BOOK 总的进价
      MOV  AX , WORD PTR GB2+12
      IMUL AX , WORD PTR GB2+16
      MOV  SHOUJIA+1 , AX    ;计算SHOP2 BOOK 总的售价

      SUB  AX , JINJIA+1    ;计算SHOP2 BOOK 总的售价-总的进价
      MOV  LIRUN+1 ,  AX    ;保存利润
      MOV   CX , 100
      IMUL  CX       ;利润乘以10 为了后面算利润率做准备

      ;CWD
      IDIV  JINJIA+1   ;利润乘以100  除以总的进价
      MOV   WORD PTR GB2+18 , AX ;保存利润率




      ADD   AX , WORD PTR GA2+18  ;两个BOOK 的利润率之和
      CWD
      MOV   CX , 2
      IDIV  CX          ;两个利润率相加 除以2  得到平均值
      MOV   PINGJUN+1 , AX     ;保存平均值
      JMP   BIJIAO







BIJIAO:;条件判断
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

     JMP   SHOW5  ;以上都不满足  显示F






SHOW1:   MOV  DL , 'A'  ;显示平均利润率的等级
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;换行
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;回到功能1


SHOW2:   MOV  DL , 'B'  ;显示平均利润率的等级
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;换行
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;回到功能1


 SHOW3:   MOV  DL , 'C'  ;显示平均利润率的等级
          MOV  AH , 2
          INT  21H

          LEA  DX , BUF7  ;换行
          MOV  AH , 9
          INT  21H
          JMP FUNC1      ;回到功能1


SHOW4:   MOV  DL , 'D'  ;显示平均利润率的等级
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;换行
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;回到功能1


SHOW5:   MOV  DL , 'F'  ;显示平均利润率的等级
         MOV  AH , 2
         INT  21H

         LEA  DX , BUF7  ;换行
         MOV  AH , 9
         INT  21H
         JMP FUNC1      ;回到功能1


SHOW6:  LEA   DX , IN_GOODS+2  ;用户没有登录 ， 回显示输入的货物
        MOV  AH , 9
        INT  21H

        LEA  DX , BUF7  ;换行
        MOV  AH , 9
        INT  21H
        JMP FUNC1      ;回到功能1





OVER: MOV   AH , 4CH  ;结束
      INT   21H
CODE  ENDS
      END  START
