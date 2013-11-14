const char *tutorial3;

void foo(void);

void main()
{
  unsigned char *vidmem = (unsigned char *)0xB8000;
  vidmem[0] = 0x1;
  vidmem[1] = 0x1b;
  int i=0;
  for (i=0; i<80*25; i++)
  {
    vidmem[i*2]   = 0x1;
    vidmem[i*2+1] = 0x1b;
  }

  foo();
  clrscr();
  print(tutorial3);

//  for (i=0; i<80*25; i++)
//  {
//    vidmem[i*2]   = 0x1;
//    vidmem[i*2+1] = 0x2b;
//  }

  foo();

  for(;;);
}

void foo(void)
{
  int a = 2 + 4;

//  unsigned char *vidmem = (unsigned char *)0xB8000;
//  vidmem[0] = 0x2;
//  vidmem[1] = 0x07;  
//  for (;;);
}


const char *tutorial3 = "MuOS Tutorial 3";
