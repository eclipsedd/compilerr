enum E { 
    X, 
    Y=5 
};

int fact(int n){ 
    if(n<=1) 
        return 1; 
    return n*fact(n-1); 
}   

int ***ppp = malloc(sizeof(int**)*2);                       // pointer + malloc

FILE *f = fopen("out.txt","w");                             // file tokens, string literal
