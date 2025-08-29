static int cnt=0;

struct P{
    int x,
    y;
};

int a[2][3] = {{1,2,3},{4,5,6}};

char name[] = "bob";

struct P *pp = & (struct P){1,2};

if(a[0][1] > 0) 
    printf("ok %d\n", a[0][1]); 
else 
    scanf("%d",&a[0][1]);
