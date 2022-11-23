

/*******************************************************************************************************************
** Includes
*******************************************************************************************************************/
#include"TCB.h"
#include"OsAPIs.h"
#include"gpio.h"


//===============================================================================================================================
// OS TASK : T1
//===============================================================================================================================
TASK(T1)
{
  uint32 cpt = 0;
  OsEventMaskType OsWaitEventMask = EVT_WAKE_UP;
  OsEventMaskType Events = 0;
  (void)OS_SetRelAlarm(ALARM_WAKE_UP,0,1000);

  for(;;)
  {
    if(E_OK == OS_WaitEvent(OsWaitEventMask))
    {
      (void)OS_GetEvent((OsTaskType)T1, &Events);
      if((Events & EVT_WAKE_UP) == EVT_WAKE_UP)
      {
        OS_ClearEvent(EVT_WAKE_UP);

        if(cpt % 2 == 0)
        {
          gpio_SetPin(GPIO_PIN21_H40);
        }
        else
        {
          gpio_ClrPin(GPIO_PIN21_H40);
        }
        cpt++;
      }
    }
    else
    {
      OS_TerminateTask(); /* In case of error we switch off the task */
    }
  }
}

//===============================================================================================================================
// OS TASK : Idle
//===============================================================================================================================
TASK(Idle)
{
  uint32 cpt = 0;
  OsEventMaskType OsWaitEventMask = EVT_BLINK_GREEN_LED;
  OsEventMaskType Events = 0;
  (void)OS_SetRelAlarm(ALARM_GREEN_LED,0,1000);

  for(;;)
  {
    if(E_OK == OS_WaitEvent(OsWaitEventMask))
    {
      (void)OS_GetEvent((OsTaskType)Idle, &Events);
      if((Events & EVT_BLINK_GREEN_LED) == EVT_BLINK_GREEN_LED)
      {
        OS_ClearEvent(EVT_BLINK_GREEN_LED);

        if(cpt % 2 == 0)
        {
          gpio_ClrPin(GPIO_STATUS_LED);
        }
        else
        {
          gpio_SetPin(GPIO_STATUS_LED);
        }
        cpt++;
      }
    }
    else
    {
      OS_TerminateTask(); /* In case of error we switch off the task */
    }
  }
}

