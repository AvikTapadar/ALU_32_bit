# 32-bit ALU (Brent-Kung Architecture) (v0.1)

## Project Overview
This repository contains a Synthesizable **32-bit Arithmetic Logic Unit (ALU)** designed for a Single-Cycle RISC-V Processor. 

Unlike standard behavioral implementations that rely on the synthesis tool's default adder (typically Ripple Carry), this design explicitly implements a **Brent-Kung Parallel Prefix Adder**. This architecture is chosen to optimize the **critical path delay**, achieving logarithmic logic depth ($O(\log_2 N)$), making it suitable for high-frequency VLSI designs.

## Key Features
* **Architecture:** 32-bit RISC-V ISA compliant ALU.
* **Adder Topology:** Brent-Kung (Sparse Parallel Prefix Tree) for reduced wiring complexity compared to Kogge-Stone.
* **Operations:** Full support for RV32I arithmetic and logic instructions.
* **Verification:** Self-checking testbench with **C-based Golden Model** comparison and randomized vector generation.

---

## Architecture: The Brent-Kung Adder

The critical path of any ALU is dominated by the carry propagation chain. The Brent-Kung adder breaks the dependency chain using a parallel prefix tree structure.

### The 3-Stage Pipeline:
1.  **Pre-Processing (Bitwise Generate/Propagate):**
    * Computes local generate ($g_i = A_i \cdot B_i$) and propagate ($p_i = A_i \oplus B_i$) signals.
2.  **Prefix Tree (The Network):**
    * Computes carry signals in parallel using "Black Cell" and "Gray Cell" logic.
    * **Advantage:** Offers a good balance between logic depth and wiring fan-out/area compared to other trees like Kogge-Stone.
3.  **Post-Processing (Sum Logic):**
    * Computes final sum bits: $S_i = P_i \oplus C_{i-1}$.

---

## Supported Operations

The ALU is controlled via a 4-bit `alu_ctrl` signal, mapping to standard RISC-V operations:

| `alu_ctrl` | Binary | Operation         | Description                                      |
| ---------: | ------ | ----------------- | ------------------------------------------------ |
|      **0** | `0000` | **ADD**           | Addition (default, load/store, R-type ADD)       |
|      **1** | `0001` | **SUB**           | SUB for R-type, also used for BEQ/BNE comparison |
|      **2** | `0010` | **AND**           | Bitwise AND                                      |
|      **3** | `0011` | **OR**            | Bitwise OR                                       |
|      **4** | `0100` | **XOR**           | Bitwise XOR                                      |
|      **8** | `1000` | **SLL**           | Shift Left Logical                               |
|      **9** | `1001` | **SRL**           | Shift Right Logical                              |
|     **10** | `1010` | **SRA**           | Shift Right Arithmetic                           |
|     **11** | `1011` | **SLT**           | Set Less Than (signed)                           |
|     **12** | `1100` | **SLTU**          | Set Less Than (unsigned)                         |

---

## Repository Structure

```
Alu_32_BIT/
    hw/
        rtl/
            add_32.v
            alu_32.v
            alu_ctrl.v
            prefix_adder_32.v
        tb/
            add_tb.v
    outputs/
        ALU_adder_results.png
        alu_ctrl_signals.png
        Brent_kung_diagram.png
        RISC-V_alu_ctrl_instructions.png
        waveform_adder.png
    README.md
```

## Simulation & Verification
The design is verified using **Icarus Verilog**.
### Prerequisites: 
- Icarus Verilog (`iverilog`)
- vvp
- GTKWave (for waveform viewing)

### How to run with steps:
- Step 1: Go to the file directory of this project
- step 2: In the terminal type - cd hw/rtl
- step 3: You will get the output in the terminal and as a waveform

The code given works with **linux only**:
```
cd hw/rtl
iverilog -o out add_32.v ../tb/add_tb.v prefix_adder_32.v
vvp out
gtkwave tb_add.vcd
```

### Author 
Avik Tapadar