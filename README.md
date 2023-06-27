# Bresenham Circle Algorithm Hardware Accelerator

This repository contains a hardware accelerator implementation of the Bresenham Circle Algorithm. The Bresenham Circle Algorithm is a popular algorithm used for drawing circles on a display or in computer graphics.

## Overview

The Bresenham Circle Algorithm is commonly used in graphics applications due to its efficiency and simplicity. This repository provides a hardware implementation of the algorithm, which can be used to accelerate circle drawing operations in systems with hardware acceleration support.

## Features

- Hardware accelerator module for the Bresenham Circle Algorithm.
- Support for efficient circle drawing operations.
- Optimized implementation for improved performance.
- Compatible with systems supporting hardware acceleration.

## Getting Started

To use the Bresenham Circle Algorithm Hardware Accelerator module, Clone this repository to your local machine:
  git clone https://github.com/alirafiqmalik/Bresenham-Circle-Algorithm-Hardware-Accelerator.git


## File Structure

The file structure of this repository is organized as follows:

<pre>
code/
├── Challenge task/
│   ├── testbench.v
│   └── vga_demo.v
├── task2/
│   └── vga_demo.v
├── task3/
│   ├── testbench.v
│   └── task3.v
└── vga_demo.sof
README.md
</pre>



Here is a breakdown of the main directories and files in the repository:

- `code/`: This directory contains the source code files for the hardware accelerator implementation.
    - `Challenge task/`: This directory contains the source code files for the challenge task.
        - `testbench.v`: Verilog testbench file for the challenge task.
        - `vga_demo.v`: Verilog source code file for the VGA demo related to the challenge task.
    - `task2/`: This directory contains the source code files for task 2.
        - `vga_demo.v`: Verilog source code file for the VGA demo related to task 2.
    - `task3/`: This directory contains the source code files for task 3.
        - `testbench.v`: Verilog testbench file for task 3.
        - `task3.v`: Verilog source code file for task 3.
    - `vga_demo.sof`: This is a working SRAM Object File (sof) that can be burned onto the FPGA for task 3.
