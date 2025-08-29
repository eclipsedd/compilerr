typedef int I;

int argc; 
char **argv;

union X{ 
    double d; 
    int i; 
} ux;

I *p, **pp; 
p = &argc; 
pp = &p;

double d = 1.215e-10f, f=1.2E-4F;     

int i = a +++b++;                      

char *unclosed = "BTT              // unterminated string literal test
