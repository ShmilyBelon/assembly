#include<stdio.h>
#include<string.h>
#define N 3
#define shopN  2
#define maxn 81
typedef struct goods //商品结构
{
    char name[10];   //商品名称
    short d[5];      //商品的数据，前4个字分别是进价、售价、进货数、售出数
}GOODS;              //在SHOP1中第5个字是两个店同种商品的平均利润率，SHOP2中是平均利润率排名

typedef struct Shop//店铺结构
{
    char name[6];//店铺名称
    GOODS ga[N];//每个店铺有N个商品
}SHOP;

SHOP shop[shopN];//声明shopN个店铺 shopN等与2

char in_name[maxn];  //用于保存用户输入的用户名
char in_pwd[maxn];   //用于保存用户输入的密码
const char* bname = "CHENGUOX\n"; //正确的用户名
const char* bpass = "test";       //正确的密码
const char* s[] ={"SHOP1","SHOP2"}; //店铺名
const char* ga_name[] = {"BAG","BOOK","PEN"};//商品名
int op=1; //用户读入用户读入的功能编号

//函数声明
void query(void);//查询功能
void modify(void);//修改功能
void print(void);//输出所有的商品信息
void PrintCus(void);//输出商品名
void rankclear(void);//清除原有的排名信息
extern "C" void FUNC3_4(void* , void*);//来自汇编文件，计算平均利润率
extern "C" void FUNC3_5(void* , void*);//来自汇编文件，给每种商品按照平均利润率排名

//初始化商店中所有的商品信息
void init(void)
{
    int i=0;
    for(i=0;i<shopN;i++)
    {
        strcpy(shop[i].name,s[i]);
        int j=0;
        for(j=0;j<N;j++)
        {
            strcpy(shop[i].ga[j].name,ga_name[j]);
            int k=0;
            for(k=0;k<4;k++)
            {
                shop[i].ga[j].d[k]=10;//进价、售价等信息都初始化为10
            }
        }
    }

    return;

}
//清除之前的已有的排名信息
void rankclear(void)
{
    int i=0;
    for(;i<N;i++)
    {
        shop[1].ga[i].d[4]=0;
    }
    return ;

}



int main(void)
{
    init();
Start:
   // printf("esi: %p  edi: %p",&(shop[0].ga[0].name[0]),&(shop[1].ga[0].name[0]));
    printf("Please input your username\n: ");
    fgets(in_name,maxn-1,stdin);
    fflush(stdin);
    if(in_name[0]=='\n')//用户输出回车只能游客访问
        goto Flag;
    else if(!strcmp(in_name,bname))
        goto Flag1;
    else if(in_name[0]=='q') //用户名是q直接退出
        return 0;

    else
    {
        printf("Wrong UserName!!  Please input again!\n");
        goto Start;
    }

Flag1:

    printf("Please input your password!\n");
    scanf("%s",in_pwd);
    if(!strcmp(in_pwd,bpass))
            goto Flag2;
    else
    {
      printf("Wrong PassWord!!  Please input again!\n");
      goto Flag1;
    }

Flag2:



    while(op!=6)//执行用户输入的功能
    {
	 // system("cls");
      printf("\n1.Query product info            2.Modify product info   3.Calculate average profit margin\n");
      printf("4.Calculate profit margin rank  5.Print product info    6.Exit\n\n\n");
      printf("==>");
      scanf("%d",&op);

      switch(op)
      {
          case 1 : query();break;//查询商品信息
          case 2 : modify();break;//修改商品信息
		  case 3 : FUNC3_4( (char*)( &(shop[0].ga[0].name[0]) ) , (char*)( &(shop[1].ga[0].name[0]) ) );break;//计算平均利润率
		  case 4 : rankclear(); FUNC3_5(  (char*)( &(shop[0].ga[0].name[0]) ) , (char*)( &(shop[1].ga[0].name[0]) ) ); break;//按平均利润率排名
          case 5 : print();break;//输出所有商品信息
          case 6 : return 0;
      }
    }

Flag:
    PrintCus();//输出游客能访问的信息


    return 0;

}

void query(void)
{
   char gs[maxn];
 _F1 :
   printf("Please input the goods you wanna query\n: ");
   scanf("%s",gs);//读入商品名
   int i=0,find=-1;
   for(i=0;i<N;i++)//循环查找
   {
      if(!strcmp(gs,ga_name[i]))
      {
          find=i;
      }
   }
   if(find<0)//没找到
   {
       printf("The goods not exist Input Again!\n");
       goto _F1;
   }
   else//找到则输出
   {
       int j=0;
       for(j=0;j<shopN;j++)
       {
         printf("%s  %s  %hd  %hd  %hd\n",shop[j].name, shop[j].ga[find].name, shop[j].ga[find].d[1], shop[j].ga[find].d[2], shop[j].ga[find].d[3]);
       }
   }
   getchar();

   return;
}
void modify(void)
{

   int find1=-1;
   char sn[81];

_L1:
   printf("Please input the shop name\n: ");
   scanf("%s",sn);//读入要修改的店铺
   int k=0;
   for(k=0;k<shopN;k++)
     if(!strcmp(sn,s[k]))
     {
         find1=k;
         break;
     }

   if(find1<0)
   {
       printf("The shop does not exist Input Again!\n");
       goto _L1;
   }




   char gs[maxn];
 _F2 :
   printf("Please input the goods name you wanna modify\n: ");
   scanf("%s",gs);//读入要修改的商品
   int i=0;
   int find2=-1;
   for(i=0;i<N;i++)//循环查找
   {
      if(!strcmp(gs,ga_name[i]))
      {
          find2=i;
          break;
      }
   }
   if(find2<0)//没找到
   {
       printf("The goods does not exist Input Again!\n");
       goto _F2;
   }
   else//找到则输出
   {
       printf("%hd=>",shop[find1].ga[find2].d[0]);
       scanf("%hd",&shop[find1].ga[find2].d[0]);


       printf("%hd=>",shop[find1].ga[find2].d[1]);
       scanf("%hd",&shop[find1].ga[find2].d[1]);

       printf("%hd=>",shop[find1].ga[find2].d[2]);
       scanf("%hd",&shop[find1].ga[find2].d[2]);



   }


}

void print(void)
{
  int i=0;
  for(i=0;i<shopN;i++)//遍历所有店铺
  {
      printf("%s\n",shop[i].name);//输出店铺名称

      int j=0;
      if(!i)
        for(j=0;j<N;j++)//循环输出所有的商品信息
        {
            printf("  %8s  %8hd%8hd%8hd%8hd%8hd%%%8hd\n",shop[i].ga[j].name,  shop[i].ga[j].d[0], shop[i].ga[j].d[1], shop[i].ga[j].d[2], shop[i].ga[j].d[3], shop[i].ga[j].d[4], shop[i+1].ga[j].d[4]);
        }
     else
        for(j=0;j<N;j++)//循环输出所有信息
        {
            printf("  %8s  %8hd%8hd%8hd%8hd%8hd%%%8hd\n",shop[i].ga[j].name,  shop[i].ga[j].d[0], shop[i].ga[j].d[1], shop[i].ga[j].d[2], shop[i].ga[j].d[3],  shop[i-1].ga[j].d[4] ,shop[i].ga[j].d[4]);
        }
      printf("\n");

  }
  getchar();

}


void PrintCus(void)
{
    int i=0;
    for(;i<N;i++)//输出商品名
    {
        printf("%d.%s  ",i+1,ga_name[i]);

    }
    printf("\n");
    getchar();
}


