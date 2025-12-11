# i281 CPU — 8-bit Microarchitecture Design

A complete hardware design and simulation of an **8-bit CPU microarchitecture** built with Verilog, tested via ModelSim, and prepared for FPGA development.

This project includes:
- CPU datapath and control logic
- ALU design
- Opcode decoding
- Testbench and simulation outputs
- Project documentation

---

## 📌 Project Overview

The i281 CPU is an educational implementation of a simple 8-bit processor, designed as part of the Digital Systems/Computer Architecture coursework. It includes key components such as:

- ALU (Arithmetic Logic Unit)
- Register file
- Program counter & update logic
- Opcode decoding logic
- Memory interface

All modules were written in **Verilog** and verified with simulation.

---

## 📁 Repository Structure

📁 db/ — Simulation database & compiled simulation files
📁 work/ — ModelSim working directory
📄 alu.v — ALU module
📄 control.v — Control logic
📄 opcode_decoder.v — Opcode decoder
📄 pc.v — Program counter
📄 pcupdatelogic.v — PC update logic
📄 registerfile.v — Register file
📄 i281_cpu.v — Top-level CPU module
📄 i281_cpu_tb.v — Testbench for CPU
📄 dmem.v / dmem.mem — Data memory + contents
📄 Project_Report.pdf — Project report & documentation

---

## 🛠️ Tools & Technologies

- **Verilog HDL** — for hardware design  
- **ModelSim** — for RTL simulation  
- **Quartus Prime** (optional) — for FPGA synthesis  
- **Windows / Git** — development environment

---

## 🧠 Key Features

- Modular Verilog design suitable for teaching and experimentation  
- Functional testbench with simulation waveform support  
- Clear separation of datapath and control logic  
- Demonstrates CPU basics (fetch-decode-execute cycle)

---

## 🚀 How to Run the Design

1. Open the project in **ModelSim** or any HDL simulator  
2. Compile all `.v` files  
3. Run the testbench (`i281_cpu_tb.v`)  
4. View waves to verify correct CPU behavior

Example ModelSim commands:

```bash
vsim work.i281_cpu_tb
run -all
