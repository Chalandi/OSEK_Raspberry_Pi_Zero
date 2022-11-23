// ***************************************************************************************
// Filename    : Startup.c
//
// Author      : Chalandi Amine
//
// Owner       : Chalandi Amine
// 
// Date        : 11.03.2020
// 
// Description : C/C++ Runtime Setup (Crt0)
// 
// ***************************************************************************************
//=========================================================================================
// types definitions
//=========================================================================================
typedef struct {

    unsigned long  sourceAddr;  /* Source Address (section in ROM memory) */
    unsigned long  targetAddr;  /* Target Address (section in RAM memory) */
    unsigned long  size;        /* length of section (bytes) */

} runtimeCopyTable_t;

typedef struct {

    unsigned long  Addr;  /* source Address (section in RAM memory) */
    unsigned long  size;  /* length of section (bytes) */

} runtimeClearTable_t;

//=========================================================================================
// linker variables
//=========================================================================================
extern const runtimeCopyTable_t __RUNTIME_COPY_TABLE[];
extern const runtimeClearTable_t __RUNTIME_CLEAR_TABLE[];
extern unsigned long __CTOR_LIST__[];

//=========================================================================================
// defines
//=========================================================================================
#define __STARTUP_RUNTIME_COPYTABLE   (runtimeCopyTable_t*)(&__RUNTIME_COPY_TABLE[0])
#define __STARTUP_RUNTIME_CLEARTABLE  (runtimeClearTable_t*)(&__RUNTIME_CLEAR_TABLE[0])
#define __STARTUP_RUNTIME_CTORS       (unsigned long*)(&__CTOR_LIST__[0])

//=========================================================================================
// function prototype
//=========================================================================================
void Startup_Init(void);
static void Startup_InitRam(void);
static void Startup_InitCtors(void);
static void Startup_RunApplication(void);
static void Startup_Unexpected_Exit(void);
static void Startup_InitSystemClock(void);

//=========================================================================================
// extern function prototype
//=========================================================================================
 int main(void) __attribute__((weak));

//=========================================================================================
// macros
//=========================================================================================
#define ENABLE_FIQ()  __asm("CPSIE f")
#define DISABLE_FIQ() __asm("CPSID f")
#define ENABLE_IRQ()  __asm("CPSIE i")
#define DISABLE_IRQ() __asm("CPSID i")

//-----------------------------------------------------------------------------------------
/// \brief  Startup_Init function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
void Startup_Init(void)
{
  /* Configure the system clock */
  Startup_InitSystemClock();

  /* Initialize the RAM memory */
  Startup_InitRam();

  /* Initialize the non-local C++ objects */
  Startup_InitCtors();

  /* start the application */
  Startup_RunApplication();
}


//-----------------------------------------------------------------------------------------
/// \brief  Startup_InitRam function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
static void Startup_InitRam(void)
{
  unsigned long index = 0;

  /* Clear Table */
  while((__STARTUP_RUNTIME_CLEARTABLE)[index].Addr != (unsigned long)-1 && (__STARTUP_RUNTIME_CLEARTABLE)[index].size != (unsigned long)-1)
  {
    for(unsigned int cpt = 0; cpt < (__STARTUP_RUNTIME_CLEARTABLE)[index].size; cpt++)
    {
      *(volatile unsigned char*)((unsigned long)((__STARTUP_RUNTIME_CLEARTABLE)[index].Addr) + cpt) = 0;
    }
    index++;
  }

  /* Copy Table */
  index = 0;
  while((__STARTUP_RUNTIME_COPYTABLE)[index].sourceAddr != (unsigned long)-1 &&
        (__STARTUP_RUNTIME_COPYTABLE)[index].targetAddr != (unsigned long)-1 &&
        (__STARTUP_RUNTIME_COPYTABLE)[index].size       != (unsigned long)-1
       )
  {
    for(unsigned int cpt = 0; cpt < (__STARTUP_RUNTIME_COPYTABLE)[index].size; cpt++)
    {
      *(volatile unsigned char*)((unsigned long)((__STARTUP_RUNTIME_COPYTABLE)[index].targetAddr) + cpt) = 
               *(volatile unsigned char*)((unsigned long)((__STARTUP_RUNTIME_COPYTABLE)[index].sourceAddr) + cpt);
    }
    index++;
  }
}

//-----------------------------------------------------------------------------------------
/// \brief Startup_InitCtors function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
static void Startup_InitCtors(void)
{
  for(unsigned long entry = 1; entry <= (__STARTUP_RUNTIME_CTORS)[0]; entry++)
  {
    ((void (*)(void))((__STARTUP_RUNTIME_CTORS)[entry]))();
  }
}

//-----------------------------------------------------------------------------------------
/// \brief  Startup_RunApplication function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
static void Startup_RunApplication(void)
{
  /* check the weak function */
  if((unsigned int) main != 0)
  {
    /* Call the main function */
    (void)main();
  }

  /* Catch unexpected exit from main or if main does not exist */
  Startup_Unexpected_Exit(); 
}

//-----------------------------------------------------------------------------------------
/// \brief  Startup_Unexpected_Exit function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
static void Startup_Unexpected_Exit(void)
{
  for(;;);
}
//-----------------------------------------------------------------------------------------
/// \brief  Startup_InitSystemClock function
///
/// \param  void
///
/// \return void
//-----------------------------------------------------------------------------------------
static void Startup_InitSystemClock(void)
{

}
