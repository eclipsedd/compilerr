int x=5; int &r = x;                 // reference token (& as ref vs bitwise)

union U { 
  int i; 
  char s[8]; 
} u1;    

for(int i=0;i<4;i++){
  switch(i){ 
    case 1: continue; 
    case 2: break; 
    default: goto L; }
}

L: ;
