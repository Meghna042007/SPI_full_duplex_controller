# SPI Full-Duplex Controller

A Verilog-based SPI (Serial Peripheral Interface) Full-Duplex Communication System implementing both Master and Slave modules. The design supports simultaneous transmission and reception of 8-bit data using SPI Mode 0 communication.

---

## Features

- SPI Mode 0 (CPOL = 0, CPHA = 0)
- Full-Duplex Communication
- 8-bit Data Transfer
- Master TX and RX
- Slave TX and RX
- FSM-Based Control
- Clock Divider for SPI Clock Generation
- Chip Select (CS) Control
- Top-Level Integration
- Functional Verification in Vivado

---

## System Specifications

| Parameter | Value |
|-----------|-------|
| System Clock | 100 MHz |
| SPI Clock (SCLK) | 10 MHz |
| Data Width | 8 Bits |
| SPI Mode | Mode 0 |
| CPOL | 0 |
| CPHA | 0 |
| Communication Type | Full Duplex |

---

## SPI Timing

SPI Mode 0 Operation:

- SCLK remains LOW during idle.
- Data is shifted on the falling edge of SCLK.
- Data is sampled on the rising edge of SCLK.
- CS remains HIGH when no transaction is active.

---

## Project Architecture

```text
                +----------------+
                |   SPI Master   |
                |                |
                | TX Shift Reg   |
                | RX Shift Reg   |
                +--------+-------+
                         |
                    MOSI |
                         v
                +--------+-------+
                |    SPI Slave   |
                |                |
                | RX Shift Reg   |
                | TX Shift Reg   |
                +--------+-------+
                         ^
                    MISO |
                         |
                +--------+-------+
                |   SPI Master   |
                +----------------+
```

---

## Modules

### Master SPI (`master_spi.v`)

Responsibilities:

- Generates SPI Clock (SCLK)
- Controls Chip Select (CS)
- Transmits data through MOSI
- Receives data through MISO
- Performs clock division from 100 MHz to 10 MHz
- Controls SPI transaction using FSM
- Generates transfer completion signal (`done`)

#### FSM States

| State | Description |
|---------|-------------|
| IDLE | Waits for start signal |
| LOAD | Initializes SPI transaction |
| TRANSFER | Performs SPI data exchange |
| DONE | Completes transaction |

---

### Slave SPI (`slave_spi.v`)

Responsibilities:

- Receives data through MOSI
- Transmits data through MISO
- Receives SCLK from Master
- Receives CS from Master
- Stores received data
- Generates transfer completion signal (`done`)

#### FSM States

| State | Description |
|---------|-------------|
| IDLE | Loads transmit data |
| TRANSFER | Performs SPI data exchange |
| DONE | Indicates successful transfer |

---

### Top Module (`top_spi.v`)

Integrates:

- SPI Master
- SPI Slave

Internal Connections:

- MOSI
- MISO
- SCLK
- CS

---

### Testbench (`top_spi_tsb.v`)

Functions:

- Generates 100 MHz system clock
- Applies reset
- Starts SPI transaction
- Loads Master and Slave data
- Verifies simultaneous transmission and reception
- Ends simulation automatically

---

## Verification Example

### Input Data

```text
Master TX Data = 8'hB3 = 10110011

Slave TX Data  = 8'hD6 = 11010110
```

### Expected Results

```text
Master RX Data = 8'hD6 = 11010110

Slave RX Data  = 8'hB3 = 10110011
```

### Simulation Results

```text
Master TX : B3
Slave RX  : B3

Slave TX  : D6
Master RX : D6
```

### Result

```text
PASS
```


---

## Concepts Demonstrated

- SPI Protocol
- Full-Duplex Communication
- Finite State Machines (FSM)
- Shift Registers
- Clock Division
- Serial Data Transmission
- Serial Data Reception
- Top-Level Integration
- RTL Design
- Functional Verification

---

## Simulation Environment

- Language: Verilog HDL
- Simulator: Xilinx Vivado
- Timescale: 1ns / 1ps


---

## Author

Developed as part of an RTL Design and FPGA Learning Journey focused on Digital Design, Verilog HDL, Communication Protocols, and Hardware System Development.
