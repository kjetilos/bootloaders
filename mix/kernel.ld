/* kernel.ld - linker script for kernel */

ENTRY(main) 
SECTIONS
{

  .text 0x1000 : {
    *(.text)
  }

  .rodata : {
    *(.rodata)
  }

  .data : {
    *(.data)
  }

  .bss : {
    bss = .;
    *(.bss)
  }

  /DISCARD/ : {
    *(*)
  }
}
