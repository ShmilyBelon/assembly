#include<stdio.h>
#include<string.h>
#define N 3
#define shopN  2
#define maxn 81
typedef struct goods //��Ʒ�ṹ
{
    char name[10];   //��Ʒ����
    short d[5];      //��Ʒ�����ݣ�ǰ4���ֱַ��ǽ��ۡ��ۼۡ����������۳���
}GOODS;              //��SHOP1�е�5������������ͬ����Ʒ��ƽ�������ʣ�SHOP2����ƽ������������

typedef struct Shop//���̽ṹ
{
    char name[6];//��������
    GOODS ga[N];//ÿ��������N����Ʒ
}SHOP;

SHOP shop[shopN];//����shopN������ shopN����2

char in_name[maxn];  //���ڱ����û�������û���
char in_pwd[maxn];   //���ڱ����û����������
const char* bname = "CHENGUOX\n"; //��ȷ���û���
const char* bpass = "test";       //��ȷ������
const char* s[] ={"SHOP1","SHOP2"}; //������
const char* ga_name[] = {"BAG","BOOK","PEN"};//��Ʒ��
int op=1; //�û������û�����Ĺ��ܱ��

//��������
void query(void);//��ѯ����
void modify(void);//�޸Ĺ���
void print(void);//������е���Ʒ��Ϣ
void PrintCus(void);//�����Ʒ��
void rankclear(void);//���ԭ�е�������Ϣ
extern "C" void FUNC3_4(void* , void*);//���Ի���ļ�������ƽ��������
extern "C" void FUNC3_5(void* , void*);//���Ի���ļ�����ÿ����Ʒ����ƽ������������

//��ʼ���̵������е���Ʒ��Ϣ
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
                shop[i].ga[j].d[k]=10;//���ۡ��ۼ۵���Ϣ����ʼ��Ϊ10
            }
        }
    }

    return;

}
//���֮ǰ�����е�������Ϣ
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
    if(in_name[0]=='\n')//�û�����س�ֻ���οͷ���
        goto Flag;
    else if(!strcmp(in_name,bname))
        goto Flag1;
    else if(in_name[0]=='q') //�û�����qֱ���˳�
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



    while(op!=6)//ִ���û�����Ĺ���
    {
	 // system("cls");
      printf("\n1.Query product info            2.Modify product info   3.Calculate average profit margin\n");
      printf("4.Calculate profit margin rank  5.Print product info    6.Exit\n\n\n");
      printf("==>");
      scanf("%d",&op);

      switch(op)
      {
          case 1 : query();break;//��ѯ��Ʒ��Ϣ
          case 2 : modify();break;//�޸���Ʒ��Ϣ
		  case 3 : FUNC3_4( (char*)( &(shop[0].ga[0].name[0]) ) , (char*)( &(shop[1].ga[0].name[0]) ) );break;//����ƽ��������
		  case 4 : rankclear(); FUNC3_5(  (char*)( &(shop[0].ga[0].name[0]) ) , (char*)( &(shop[1].ga[0].name[0]) ) ); break;//��ƽ������������
          case 5 : print();break;//���������Ʒ��Ϣ
          case 6 : return 0;
      }
    }

Flag:
    PrintCus();//����ο��ܷ��ʵ���Ϣ


    return 0;

}

void query(void)
{
   char gs[maxn];
 _F1 :
   printf("Please input the goods you wanna query\n: ");
   scanf("%s",gs);//������Ʒ��
   int i=0,find=-1;
   for(i=0;i<N;i++)//ѭ������
   {
      if(!strcmp(gs,ga_name[i]))
      {
          find=i;
      }
   }
   if(find<0)//û�ҵ�
   {
       printf("The goods not exist Input Again!\n");
       goto _F1;
   }
   else//�ҵ������
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
   scanf("%s",sn);//����Ҫ�޸ĵĵ���
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
   scanf("%s",gs);//����Ҫ�޸ĵ���Ʒ
   int i=0;
   int find2=-1;
   for(i=0;i<N;i++)//ѭ������
   {
      if(!strcmp(gs,ga_name[i]))
      {
          find2=i;
          break;
      }
   }
   if(find2<0)//û�ҵ�
   {
       printf("The goods does not exist Input Again!\n");
       goto _F2;
   }
   else//�ҵ������
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
  for(i=0;i<shopN;i++)//�������е���
  {
      printf("%s\n",shop[i].name);//�����������

      int j=0;
      if(!i)
        for(j=0;j<N;j++)//ѭ��������е���Ʒ��Ϣ
        {
            printf("  %8s  %8hd%8hd%8hd%8hd%8hd%%%8hd\n",shop[i].ga[j].name,  shop[i].ga[j].d[0], shop[i].ga[j].d[1], shop[i].ga[j].d[2], shop[i].ga[j].d[3], shop[i].ga[j].d[4], shop[i+1].ga[j].d[4]);
        }
     else
        for(j=0;j<N;j++)//ѭ�����������Ϣ
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
    for(;i<N;i++)//�����Ʒ��
    {
        printf("%d.%s  ",i+1,ga_name[i]);

    }
    printf("\n");
    getchar();
}


