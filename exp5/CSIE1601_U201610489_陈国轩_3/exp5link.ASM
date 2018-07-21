
NAME   PART2
;EXTRN  S1:BYTE, GA1:BYTE ,GA2:BYTE,GA3:BYTE,S2:BYTE,GB1:BYTE,GB2:BYTE,GB3:BYTE,F2T10:FAR,RADIX:FAR,BUF:BYTE
PUBLIC _FUNC3_4,_FUNC3_5

.model small,c
.386
.DATA
N = 3

;BUF7    DB  0AH,0DH,0AH,0DH,'$'
;BUF8    DB  0AH,0DH,'$'
;BUF9    DB  '  ','$'


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

.DATA?

.STACK 200
;      DB  200  DUP(0)
;STACK ENDS

.CODE
    ;   ASSUME  CS: CODE , DS: DATA , SS: STACK

;入口参数和出口参数：无
;实现功能：计算每种商品的平均利润率
_FUNC3_4  PROC NEAR ; GA1:DWORD , GB1:DWORD

              PUSHA   ;现场保护，8个16位寄存器顺序入栈】
              PUSH BP;
              MOV  BP,SP



              MOV  SI  , [BP+20]
              MOV  DI  ,  [BP+22]


        _F41:
              MOV  AX , [SI+10]
              IMUL AX , [SI+14]
              MOV  JINJIA , AX    ;计算SHOP1 商品i 总的进价
              MOV  AX , [SI+12]
              IMUL AX , [SI+16]
              MOV  SHOUJIA , AX    ;计算SHOP1 商品i 总的售价

              SUB  AX , JINJIA    ;计算SHOP1 商品i 总的售价-总的进价
              MOV  LIRUN ,  AX    ;保存利润
              MOV  CX , 100
              IMUL CX        ;利润乘以100 为了后面算利润率做准备


              IDIV  JINJIA   ;利润乘以100  除以总的进价
              MOV   [SI+18] , AX ;保存利润率


              MOV  AX , [DI+10]
              IMUL AX , [DI+14]
              MOV  JINJIA+1 , AX    ;计算SHOP2 商品i 总的进价
              MOV  AX , [DI+12]
              IMUL AX , [DI+16]
              MOV  SHOUJIA+1 , AX    ;计算SHOP2 商品i 总的售价

              SUB  AX , JINJIA+1    ;计算SHOP2 商品i 总的售价-总的进价
              MOV  LIRUN+1 ,  AX    ;保存利润
              MOV  CX , 100
              IMUL CX              ;利润乘以100 为了后面算利润率做准备

            ;  CWD
              IDIV  JINJIA+1       ;利润乘以100  除以总的进价
            ;  MOV   [DI+18] , AX ;保存利润率




              ADD   AX , [SI+18]  ;两个商品i 的利润率之和
              CWD
              MOV   CX , 2
              IDIV  CX          ;两个利润率相加 除以2  得到平均值
              MOV   [SI+18] , AX     ;保存平均值

              ADD   SI , 20    ;为了计算shop1下一个商品的利润率
              ADD   DI , 20    ;为了计算shop2下一个商品的利润率

              MOV  CX , COUNT  ; 计数器减少1
              DEC  CX
              MOV  COUNT , CX
              CMP  CX , 0
              JNE  _F41        ;不等于0 继续计算剩余商品的利润率

              MOV  CX , 3
              MOV  COUNT , CX  ;恢复COUNT

            ;  ADD SP ,2
              POP BP;

              POPA   ;恢复现场
              RET
  _FUNC3_4   ENDP



  ;入口参数和出口参数：无
  ;实现功能：每种商品按照平均利润率排名
_FUNC3_5  PROC  GA1:WORD , GB1:WORD



          PUSHA   ;现场保护，8个16位寄存器顺序入栈

          MOV  SI , GA1
          MOV  DI , GB1

          MOV  CX , N
          MOV  COUNT , CX  ;最外层的大循环计数器COUNT初始化为N

          MOV  DX , 1  ;排序顺序

     _BLOOP:   ;最外层的大循环，循环N次
          MOV  SI , GA1
          MOV  DI , GB1

          MOV  CX , N  ; 寻找当前最大循环的计数器
       ;;以下为寻找当前最大值的循环体
       _F51:
          MOV  BX , [DI+18]
          CMP  BX , 0           ;判断该商品是否已经分配了编号
          JNE   _F52            ;已经分配了标号则跳过

          MOV  AX , [SI+18]
          CMP  AX , MAX
          JLE  _F52             ;该商品的平均利润率低于最大值 则跳过
          MOV  MAX , AX   ;否则更新最大值
       _F52:
          ADD  SI , 20    ; 判断下一个商品
          ADD  DI , 20
          DEC  CX
          CMP  CX , 0
          JNE  _F51
        ;;以上为寻找当前最大值的循环，循环N次


       ;以下是分配标号的实现
          MOV  SI  , GA1
          MOV  DI  , GB1
          MOV  CX , N  ;计数器

     ;;以下是分配标号的循环体
      _F53:
         MOV  AX , [SI+18]
         CMP  AX , MAX      ;比较当前的商品是否为当前的最大值
         JNE  _F54           ;若不是则跳过
         MOV  [DI+18] , DX   ;如果是则分配标号
         INC  DX            ;标号自增

      _F54:
         ADD  SI , 20    ; 判断下一个商品
         ADD  DI , 20
         DEC  CX
         CMP  CX , 0
         JNE  _F53
     ;;以上是分配标号的循环体


         MOV  CX , -120   ;再次将当前的最大值初始化为最小
         MOV  MAX , CX

         MOV  CX , COUNT   ;_BLOOP大循环的计数器
         DEC  CX
         MOV  COUNT , CX
         CMP  CX , 0
         JNE  _BLOOP
        ;;以上是大循环_BLOOP的循环体


         MOV  CX , N     ;循环结束之后，恢复COUNT 默认值
         MOV  COUNT , CX


        POPA   ;恢复现场
        RET

_FUNC3_5   ENDP
END
