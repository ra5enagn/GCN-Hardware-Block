# GCN Harware Block – ASIC Implementation

## Overview
This repository contains a hardware-oriented implementation of a Graph Convolutional Network (GCN) core developed in SystemVerilog and targeted for ASIC acceleration. The design performs sparse feature aggregation, feature transformation, and argmax-based node classification. The project follows a complete RTL-to-post-layout flow, including synthesis, place-and-route, timing verification, and power analysis, with an emphasis on low power consumption and sub-100 ns end-to-end latency.

---

## Design Description
The GCN core is designed for node classification on graph-structured data using a sparse adjacency representation. A Coordinate (COO) format is employed to efficiently decode graph connectivity and perform aggregation without full dense matrix multiplication. The computation consists of three main stages:

1. Feature Aggregation  
   Sparse accumulation of neighboring node features based on COO adjacency input.

2. Feature Transformation  
   Fixed-point matrix multiplication between aggregated features and a learned weight matrix.

3. Classification  
   Argmax operation to determine the output class index for each node.

The architecture uses FSM-based control logic and counter-driven scheduling. Fixed-point arithmetic is employed throughout the datapath, and all primary inputs and outputs are registered at the module boundary to ensure clean timing closure and support pipelining.

---

## Top-Level Module
The core functionality is implemented in a parameterized GCN module with the following characteristics:
- Number of nodes: 6  
- Feature vector length: 96  
- Feature and weight precision: 5-bit unsigned fixed-point  
- Weight matrix size: 96 × 3  
- Output: 3-bit class index per node  

The module interfaces with external memory through read address and enable signals, accepts a start signal to initiate computation, and asserts a done signal upon completion of classification.

---

## Verification Methodology
Functional correctness is verified using a SystemVerilog testbench and a golden output file. The same testbench infrastructure is reused across multiple design stages to ensure consistency:

- Behavioral (RTL) simulation to validate functionality
- Post-synthesis simulation using the synthesized gate-level netlist
- Post-place-and-route simulation using the Innovus-generated netlist

All simulations confirm correct classification results and design robustness.

---

## ASIC Implementation Flow
The project follows a standard ASIC design methodology:

- RTL design and verification in SystemVerilog
- Logic synthesis using Synopsys Design Compiler
- Automatic place and route using Cadence Innovus
- Clock tree synthesis and timing closure
- Post-layout power analysis using switching activity from simulation

The final design is DRC- and LVS-clean, with positive setup and hold slack.

---

## Generated Design Artifacts
The repository includes the following implementation outputs:

- Behavioral Verilog netlist
- Synthesized Verilog gate-level netlist
- Post-place-and-route Innovus netlist
- Timing reports including setup and hold summaries
- Clock tree synthesis report
- DRC and LVS reports and screenshots
- Innovus layout screenshots
- Post-layout power reports
- Post-APR simulation logs

These artifacts collectively demonstrate a complete and verifiable ASIC implementation flow.

---

## Performance Targets
- End-to-end latency: less than 100 ns  
- Timing: positive setup and hold slack after place and route  
- Power: evaluated post-layout using Innovus  

---
<img width="834" height="830" alt="GCN_Innovus_Layout" src="https://github.com/user-attachments/assets/abdbf523-2f68-4927-9c9b-715273b15d0e" />
---


## Scope and Intent
This project is intended as a hardware reference design for sparse GCN inference and demonstrates hardware-aware architectural choices for graph neural networks. It is not a software training framework, but a fixed-function, inference-oriented hardware block suitable for ASIC integration.

---
