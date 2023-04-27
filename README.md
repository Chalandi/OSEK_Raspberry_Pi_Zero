OSEK_Raspberry_Pi_Zero
==================

This repository implements an OSEK-like, bare-metal
operating system for Raspberry Pi Zero (ARM1176JZF-S).

Features include:
  - bare-metal startup using the RPI's standard `kernel.img` file on SD card.
  - power and port initialization,
  - 1ms timebase derived from the low 32-bit `clo` register of the BCM's 64-bit timer.
  - blinky LED at 1/2 Hz on the user LED,
  - implementation in C99 with absolute minimal use of assembly.

A clear and easy-to-understand build system based on GNUmake
completes this fun and educational project.

This repository provides keen insight on starting writing
a _bare_ _metal_ operating system from scratch on a modern
microcontroller.

## Details on the Application

Following low-level chip initialization, the program jumps
to the `main()` subroutine in [Appli/main.c](./Appli/main.c).
Here the single functional line in `main()`
starts the operatng system via call to `OS_StartOS()`.

An idle task and one single extended task animate the user LED,
providing a simple blinky LED show at 1/2 Hz.

## Building the Application

Build on `*nix*` is easy using an installed `gcc-arm-none-eabi`

```sh
cd OSEK_Raspberry_Pi_Zero
./Build.sh
```

The build results including ELF-file, HEX-mask, MAP-file
and the `kernel.img` file are created in the `Output` directory.

If `gcc-arm-none-eabi` is not installed, it can easily
be installed with

```sh
sudo apt install gcc-arm-none-eabi
```

## Continuous Integration

CI runs on pushes and pull-requests with a simple
build and result verification on `ubuntu-latest`
using GutHub Actions.

## References
Further information on open standard OSEK can be found in ISO 17356 and in the link below:
* https://en.wikipedia.org/wiki/OSEK
