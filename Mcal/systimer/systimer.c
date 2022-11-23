


/*******************************************************************************************************************
** Includes
*******************************************************************************************************************/
#include"systimer.h"
#include"mcu.h"
/*******************************************************************************************************************
** Defines
*******************************************************************************************************************/


/*******************************************************************************************************************
** Globals 
*******************************************************************************************************************/


/*******************************************************************************************************************
** Static functions
*******************************************************************************************************************/


/*******************************************************************************************************************
** Function:    
** Description: 
** Parameter:   
** Return:      
*******************************************************************************************************************/
void SysTickTimer_Init(void)
{
  /* the clock is already configured by the GPU (BCM2835) */
}



/*******************************************************************************************************************
** Function:    
** Description: 
** Parameter:   
** Return:      
*******************************************************************************************************************/
void SysTickTimer_Start(void)
{
  /* map the system timer 1 to the FIQ interrupt */
  FIQ_CONTROL->bit.FIQSrc = INTERRUPT_TIMER1;

  SYSTEM_TIMER_C1 = SYSTEM_TIMER_CLO + SYSTEM_TIMER_PERIODIC_SEC(1);

  FIQ_CONTROL->bit.FIQEn  = ENABLE_FIQ_GENERATION;
}

/*******************************************************************************************************************
** Function:    
** Description: 
** Parameter:   
** Return:      
*******************************************************************************************************************/
boolean SysTickTimer_FIQCheckAndUpdate(void)
{
  if(SYSTEM_TIMER_CS->bit.M1 == 1)
  {
    SYSTEM_TIMER_C1 = SYSTEM_TIMER_CLO + SYSTEM_TIMER_PERIODIC_SEC(1);
    SYSTEM_TIMER_CS->bit.M1 = 1;
    return(TRUE);
  }
  else
  {
    return(FALSE);
  }
}

/*******************************************************************************************************************
** Function:    
** Description: 
** Parameter:   
** Return:      
*******************************************************************************************************************/
void SysTickTimer_Delay(uint32 delay)
{
  uint32 timeout = SYSTEM_TIMER_CLO + delay;

  while(timeout > SYSTEM_TIMER_CLO);
}
