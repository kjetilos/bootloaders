#include <stdint.h>

unsigned char in(unsigned short _port)
{
  // "=a" (result) means: put AL register in variable result when finished
  // "d" (_port) means: load EDX with _port
  unsigned char result;
  asm  ("in %%dx, %%al" : "=a" (result) : "d" (_port));
  return result;
}

void out(unsigned short _port, unsigned char _data)
{
  // "a" (_data) means: load EAX with _data
  // "d" (_port) means: load EDX with _port
  asm ("out %%al, %%dx" : :"a" (_data), "d" (_port));
}

/* This is how linux does it */
void outb(uint8_t v, uint16_t port)
{
  asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
}
