# ******************************************************************************************
#   Filename    : Makefile
#
#   Author      : Chalandi Amine
#
#   Owner       : Chalandi Amine
#
#   Date        : 22.11.2022
#
#   Description : Build system
#
# ******************************************************************************************

############################################################################################
# Defines
############################################################################################

HW_TARGET  = Raspberry_Pi_Zero
PRJ_NAME   = Osek_$(HW_TARGET)
OUTPUT_DIR = $(CURDIR)/Output
OBJ_DIR    = $(CURDIR)/Tmp/Obj

SRC_DIR    = $(CURDIR)

LD_SCRIPT  = $(SRC_DIR)/startup/Memory_Map.ld

############################################################################################
# Toolchain
############################################################################################

AS      = arm-none-eabi-g++
CC      = arm-none-eabi-g++
CPP     = arm-none-eabi-g++
LD      = arm-none-eabi-g++
OBJDUMP = arm-none-eabi-objdump
OBJCOPY = arm-none-eabi-objcopy
READELF = arm-none-eabi-readelf

############################################################################################
# GCC Compiler verbose flags
############################################################################################

VERBOSE_GCC = -frecord-gcc-switches -fverbose-asm

############################################################################################
# C Compiler flags
############################################################################################

OPS_BASE     = -Wall                                          \
               -Wextra                                        \
               -std=c99                                       \
               -O2                                            \
               -marm                                          \
               -march=armv6zk                                 \
               -mtune=arm1176jzf-s                            \
               -mfpu=vfpv2                                    \
               -mfloat-abi=hard                               \
               -gdwarf-2

COPS         = -x c                                           \
               $(OPS_BASE)

############################################################################################
# C++ Compiler flags
############################################################################################

CPPOPS       = -x c++                                         \
               $(OPS_BASE)                                    \
               -std=c++14                                     \
               -fomit-frame-pointer                           \
               -fno-exceptions                                \
               -fno-rtti                                      \
               -fno-use-cxa-atexit                            \
               -fno-nonansi-builtins                          \
               -fno-threadsafe-statics                        \
               -fno-enforce-eh-specs                          \
               -ftemplate-depth=128                           \
               -Wzero-as-null-pointer-constant

############################################################################################
# Assembler flags
############################################################################################

ASOPS        = -x assembler                                   \
               $(OPS_BASE)

############################################################################################
# Linker flags
############################################################################################

LOPS         = -x none                                        \
               -nostartfiles                                  \
               -nostdlib                                      \
               $(OPS_BASE)                                    \
               -e Startup_Init                                \
               -Wl,-Map,$(OUTPUT_DIR)/$(PRJ_NAME).map         \
               -T $(LD_SCRIPT)


############################################################################################
# Source Files
############################################################################################

SRC_FILES :=  $(SRC_DIR)/Appli/main                                    \
              $(SRC_DIR)/Appli/tasks                                   \
              $(SRC_DIR)/Mcal/gpio/gpio                                \
              $(SRC_DIR)/Mcal/gpt/gpt                                  \
              $(SRC_DIR)/Mcal/mcu/mcu                                  \
              $(SRC_DIR)/Mcal/pwr/pwr                                  \
              $(SRC_DIR)/Mcal/systimer/systimer                        \
              $(SRC_DIR)/Osek/OS                                       \
              $(SRC_DIR)/Osek/OsAlarm                                  \
              $(SRC_DIR)/Osek/OsEvt                                    \
              $(SRC_DIR)/Osek/OsTask                                   \
              $(SRC_DIR)/Osek/TCB                                      \
              $(SRC_DIR)/Osek/HwPlatform/ARM11/OsAsm                   \
              $(SRC_DIR)/Startup/Exceptions                            \
              $(SRC_DIR)/Startup/IntVectTable                          \
              $(SRC_DIR)/Startup/Startup                               \

############################################################################################
# Include Paths
############################################################################################
INC_FILES :=  $(SRC_DIR)/Osek                                          \
              $(SRC_DIR)/Osek/HwPlatform/ARM11                         \
              $(SRC_DIR)/mcal/gpio                                     \
              $(SRC_DIR)/mcal/gpt                                      \
              $(SRC_DIR)/mcal/mcu                                      \
              $(SRC_DIR)/Std                                           \
              $(SRC_DIR)

############################################################################################
# Rules
############################################################################################

VPATH := $(subst \,/,$(sort $(dir $(SRC_FILES)) $(OBJ_DIR)))

FILES_O := $(addprefix $(OBJ_DIR)/, $(notdir $(addsuffix .o, $(SRC_FILES))))


ifeq ($(MAKECMDGOALS),build)
-include $(subst .o,.d,$(FILES_O))
endif

build : clean $(OUTPUT_DIR)/$(PRJ_NAME).elf

all : clean $(OUTPUT_DIR)/$(PRJ_NAME).elf


.PHONY : clean
clean :
	@-rm -rf $(OBJ_DIR) *.o       2>/dev/null || true
	@-rm -rf $(OBJ_DIR) *.err     2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.hex  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.elf  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.list 2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.map  2>/dev/null || true
	@-rm -rf $(OUTPUT_DIR) *.txt  2>/dev/null || true
	@-mkdir -p $(OBJ_DIR)
	@-mkdir -p $(OUTPUT_DIR)

$(OBJ_DIR)/%.o : %.c
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@-$(CC) $(COPS) $(addprefix -I, $(INC_FILES)) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err
	@-cat $(OBJ_DIR)/$(basename $(@F)).err

$(OBJ_DIR)/%.o : %.s
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@$(AS) $(ASOPS) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err >$(OBJ_DIR)/$(basename $(@F)).lst
	@-cat $(OBJ_DIR)/$(basename $(@F)).err

$(OBJ_DIR)/%.o : %.cpp
	@-echo +++ compile: $(subst \,/,$<) to $(subst \,/,$@)
	@$(CPP) $(CPPOPS) $(addprefix -I, $(INC_FILES)) -c $< -o $(OBJ_DIR)/$(basename $(@F)).o 2> $(OBJ_DIR)/$(basename $(@F)).err
	@-cat $(OBJ_DIR)/$(basename $(@F)).err

$(OUTPUT_DIR)/$(PRJ_NAME).elf : $(FILES_O)
	@$(LD) $(LOPS) $(FILES_O) -o $(OUTPUT_DIR)/$(PRJ_NAME).elf
	@$(OBJDUMP) -D $(OUTPUT_DIR)/$(PRJ_NAME).elf > $(OUTPUT_DIR)/$(PRJ_NAME).list
	@$(OBJCOPY) $(OUTPUT_DIR)/$(PRJ_NAME).elf -O ihex $(OUTPUT_DIR)/$(PRJ_NAME).hex
	$(OBJCOPY) $(OUTPUT_DIR)/$(PRJ_NAME).elf -O binary $(OUTPUT_DIR)/kernel.img
