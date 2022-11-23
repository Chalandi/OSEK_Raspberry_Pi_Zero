/******************************************************************************************
  Filename    : Memory_Map.ld
  
  Core        : ARM1176JZF-S
  
  Author      : Chalandi Amine
 
  Owner       : Chalandi Amine
  
  Date        : 11.03.2020
  
  Description : Linker description file for ARM1176JZF-S(ARMv6)
  
******************************************************************************************/

/******************************************************************************************
 ELF Entrypoint
******************************************************************************************/
ENTRY(reset)

/******************************************************************************************
 Globals
******************************************************************************************/
__SYS_STACK_SIZE = 4K;
__SVC_STACK_SIZE = 4K;
__ABT_STACK_SIZE = 4K;
__UND_STACK_SIZE = 4K;
__IRQ_STACK_SIZE = 4K;
__FIQ_STACK_SIZE = 4K;

/******************************************************************************************
 Internal flash configuration
******************************************************************************************/

MEMORY
{
  ROM(rwx) : ORIGIN = 0x00008000, LENGTH = 100M
  RAM(rwx) : ORIGIN = 0x06408000, LENGTH = 10M
}

/******************************************************************************************
 Sections definition
******************************************************************************************/
SECTIONS
{
  /* Interrupt vector table */
  .intvect :
  {
    PROVIDE(__INTVECT_BASE_ADDRESS = .) ;
    *(.intvect)
    . = ALIGN(4);
    KEEP(*(.intvect))
  } > ROM

  /* Program code (text) */
  .text :
  {
    *(.text)
    . = ALIGN(4);
  } > ROM

  /* Read-only data (.rodata) */
  .rodata :
  {
    *(.rodata)
    . = ALIGN(4);
  } > ROM

 /* Section for constructors */
  .ctors :
  {
    __CTOR_LIST__ = . ;
    LONG((__CTOR_END__ - __CTOR_LIST__) / 4 - 2);
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    LONG(0) ;
    __CTOR_END__ = . ;
    . = ALIGN(8);
  }  > ROM


  /* Section for destructors */
  .dtors :
  {
    __DTOR_LIST__ = . ;
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array))
    LONG(0) ;
    __DTOR_END__ = . ;
    . = ALIGN(8);
  } > ROM

  /* Runtime clear table */
  .clear_sec :
  {
    . = ALIGN(8);
    PROVIDE(__RUNTIME_CLEAR_TABLE = .) ;
    LONG(0 + ADDR(.bss));   LONG(SIZEOF(.bss));
    LONG(0 + ADDR(.sbss));  LONG(SIZEOF(.sbss));
    LONG(0 + ADDR(.zbss));  LONG(SIZEOF(.zbss));
    LONG(0 + ADDR(.bbss));  LONG(SIZEOF(.bbss));
    LONG(-1);                 LONG(-1);
  } > ROM

  /* Runtime copy table */	
  .copy_sec :
  {
    . = ALIGN(8);
    PROVIDE(__RUNTIME_COPY_TABLE = .) ;
    LONG(LOADADDR(.data));  LONG(0 + ADDR(.data));  LONG(SIZEOF(.data));
    LONG(LOADADDR(.sdata)); LONG(0 + ADDR(.sdata)); LONG(SIZEOF(.sdata));
    LONG(LOADADDR(.zdata)); LONG(0 + ADDR(.zdata)); LONG(SIZEOF(.zdata));
    LONG(LOADADDR(.bdata)); LONG(0 + ADDR(.bdata)); LONG(SIZEOF(.bdata));
    LONG(-1);                 LONG(-1);                  LONG(-1);
  } > ROM 

  /* The ROM-to-RAM initialized data section */
  .data :
  {
    *(.data)
    . = ALIGN(4);
  } > RAM  AT>ROM

  /* The uninitialized (zero-cleared) bss section */
  .bss :
  {
    *(.bss)
    . = ALIGN(4);
  } > RAM

  /* The ROM-to-RAM initialized sdata section */
  .sdata :
  {
    *(.sdata)
    . = ALIGN(4);
  } > RAM  AT>ROM

  /* The uninitialized (zero-cleared) sbss section */
  .sbss :
  {
    *(.sbss)
    . = ALIGN(4);
  } > RAM

  /* The ROM-to-RAM initialized zdata section */
  .zdata :
  {
    *(.zdata)
    . = ALIGN(4);
  } > RAM  AT>ROM

  /* The uninitialized (zero-cleared) zbss section */
  .zbss :
  {
    *(.zbss)
    . = ALIGN(4);
  } > RAM

  /* The ROM-to-RAM initialized bdata section */
  .bdata :
  {
    *(.bdata)
    . = ALIGN(4);
  } > RAM  AT>ROM

  /* The uninitialized (zero-cleared) bbss section */
  .bbss :
  {
    *(.sbss)
    . = ALIGN(4);
  } > RAM

  /* user-system mode stack definition */
  .stack_sys :
  {
    . = ALIGN(MAX(__SYS_STACK_SIZE , .), 8);
    PROVIDE(__SYS_STACK_TOP = .) ;
  } > RAM

  /* Supervisor mode stack definition */
  .stack_svc :
  {
    . = ALIGN(MAX(__SVC_STACK_SIZE , .), 8);
    PROVIDE(__SVC_STACK_TOP = .) ;
  } > RAM

  /* Abort mode stack definition */
  .stack_abt :
  {
    . = ALIGN(MAX(__ABT_STACK_SIZE , .), 8);
    PROVIDE(__ABT_STACK_TOP = .) ;
  } > RAM

  /* Undefined mode stack definition */
  .stack_und :
  {
    . = ALIGN(MAX(__UND_STACK_SIZE , .), 8);
    PROVIDE(__UND_STACK_TOP = .) ;
  } > RAM

  /* Interrupt mode stack definition */
  .stack_irq :
  {
    . = ALIGN(MAX(__IRQ_STACK_SIZE , .), 8);
    PROVIDE(__IRQ_STACK_TOP = .) ;
  } > RAM

  /* Fast interrupt mode stack definition */
  .stack_fiq :
  {
    . = ALIGN(MAX(__FIQ_STACK_SIZE , .), 8);
    PROVIDE(__FIQ_STACK_TOP = .) ;
  } > RAM

}
