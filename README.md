OSEK_Raspberry_Pi_Zero
==================

<p align="center">
    <a href="https://github.com/chalandi/OSEK_Raspberry_Pi_Zero/actions">
        <img src="https://github.com/chalandi/OSEK_Raspberry_Pi_Zero/actions/workflows/OSEK_Raspberry_Pi_Zero.yml/badge.svg" alt="Build Status"></a>
    <a href="https://github.com/chalandi/OSEK_Raspberry_Pi_Zero/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc">
        <img src="https://custom-icon-badges.herokuapp.com/github/issues-raw/chalandi/OSEK_Raspberry_Pi_Zero?logo=github" alt="Issues" /></a>
    <a href="https://github.com/chalandi/OSEK_Raspberry_Pi_Zero/blob/master/LICENSE_1_0.txt">
        <img src="https://img.shields.io/badge/license-BSL%201.0-blue.svg" alt="Boost Software License 1.0"></a>
    <a href="https://github.com/chalandi/OSEK_Raspberry_Pi_Zero">
        <img src="https://img.shields.io/github/languages/code-size/chalandi/OSEK_Raspberry_Pi_Zero" alt="GitHub code size in bytes" /></a>
</p>

This repository implements an OSEK-like, bare-metal
operating system for Raspberry Pi Zero (ARM1176JZF-S).

Features include:
  - OSEK-like OS implementation with support of most common features.
  - Sample application featuring tasks and events interacting to produce blinky at 1/2 Hz on the user LED.
  - Bare-metal startup using the RPI's standard `kernel.img` file on SD card.
  - Power and port initialization.
  - 1ms timebase derived from the low 32-bit `clo` register of the BCM's 64-bit timer.
  - Implementation in C99 with absolute minimal use of assembly.

A clear and easy-to-understand build system based on GNUmake
completes this fun and educational project.

This repository provides keen insight on writing your own
_bare_ _metal_ operating system from scratch on a modern
microcontroller using entirely free tools and open standards.

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
