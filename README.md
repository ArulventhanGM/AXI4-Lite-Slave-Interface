# AXI4-Lite-Slave-Interface

# AXI4-Lite Slave Interface (Verilog/SystemVerilog)

## 📘 Project Overview

This project implements a simple AXI4-Lite Slave Interface in SystemVerilog, useful for beginners and intermediate learners who want to get hands-on experience with AMBA AXI4-Lite protocol, commonly used in SoC and FPGA design.

It simulates a basic memory-mapped register interface that supports read and write operations through AXI4-Lite transactions. This type of interface is widely used in industry for peripheral communication, making it highly relevant for placement in companies like Samsung Electronics, Intel, Qualcomm, etc.

---

## 🎯 Features

- AXI4-Lite protocol compliant slave
- 4 memory-mapped 32-bit registers
- Supports:
  - Write Address Channel (`AWADDR`)
  - Write Data Channel (`WDATA`)
  - Write Response (`BRESP`)
  - Read Address Channel (`ARADDR`)
  - Read Data (`RDATA`)
- Fully synthesizable
- Testbench with simulation waveform support

---

## 🛠️ Specifications

| Specification         | Value                         |
|-----------------------|-------------------------------|
| Protocol              | AXI4-Lite                     |
| Address Bus Width     | 32 bits                       |
| Data Bus Width        | 32 bits                       |
| Number of Registers   | 4                             |
| Simulation Tool       | EDA Playground / Icarus       |
| Language              | SystemVerilog (IEEE 1800-2012)|
| Clock                 | 10ns period (100MHz)          |

---

## 📁 File Structure

```plaintext
axi4lite_slave.sv        # AXI4-Lite Slave RTL module
tb_axi4lite_slave.sv     # Testbench for simulation
README.md                # This file
