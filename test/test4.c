int a=5,b=3,c;

c = (a+b)*(a-b)/b%a + ++a - --b; 

c = c << 2; c >>= 1;       

c = (c & 7) | (c ^ 1);

c = !c && (a>=b || a<=b) || (a==b);