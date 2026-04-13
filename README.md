\# 32-bit Barrel Shifter — RTL Design \& UVM Verification



\*\*Designer:\*\* Divya Gupta | EE-VLSI | JIIT Noida (23118049)

\*\*Simulator:\*\* Cadence Xcelium 25.03 | UVM 1.2

\*\*EDA Playground:\*\* https://www.edaplayground.com/x/aYTT



\---



\## Project Overview



A 32-bit combinational barrel shifter with complete UVM-based functional verification. Supports logical left and right shift operations (0 to 31 positions) with coverage-driven methodology and SystemVerilog assertions.



\---



\## DUT Specifications



| Parameter | Value |

|-----------|-------|

| Data width | 32 bits |

| Shift amount | 5 bits (0 to 31) |

| Direction | Left (0) / Right (1) |

| Design type | Combinational MUX tree |

| Language | SystemVerilog |



\---



\## UVM Testbench Architecture



!\[TB Architecture](sim/tb\_arch.png)



The testbench follows standard UVM layered architecture:



\- \*\*Test\*\* — top level controller, launches sequences

\- \*\*Environment\*\* — integrates agent and scoreboard

\- \*\*Write Agent (ACTIVE)\*\* — driver + monitor + sequencer

\- \*\*Scoreboard\*\* — reference model and functional checker

\- \*\*Coverage\*\* — covergroups with cross coverage



\---



\## Verification Strategy



\### Sequences



\*\*seq\_random\*\* — 50 constrained random transactions covering broad input space



\*\*seq\_corner\*\* — directed corner cases:

\- shift = 0 (no shift)

\- shift = 31 (maximum shift)

\- data\_in = 0x00000000

\- data\_in = 0xFFFFFFFF

\- Both left and right directions



\### Coverage Groups



\*\*cg\_input\*\* — input side coverage:

\- SHIFT\_VAL — bins: NO\_SHIFT, LOW\_SHIFT, MID\_SHIFT, HI\_SHIFT, MAX\_SHIFT

\- DIR\_VAL — bins: LEFT, RIGHT

\- SHIFT\_DIR\_CROSS — cross coverage of shift x direction



\### SystemVerilog Assertions



\- \*\*shift\_zero\_check\*\* — when shift\_amt=0, data\_out must equal data\_in

\- \*\*max\_left\_shift\_check\*\* — shift=31 left shift correctness verified

\- \*\*no\_x\_output\*\* — data\_out never unknown when inputs are valid



\---



\## Simulation Results



| Metric | Result |

|--------|--------|

| Total transactions | 54 |

| PASS | 54 |

| FAIL | 0 |

| UVM\_ERROR | 0 |

| UVM\_FATAL | 0 |

| Functional Coverage | 100% |

| Simulator | Cadence Xcelium 25.03 |



\---



\## Waveform



!\[Waveform](sim/waveform.png)



\---



\## Repository Structure



&#x20;   barrel-shifter-32bit-uvm/

&#x20;   ├── rtl/

&#x20;   │   └── barrel\_shifter.sv

&#x20;   ├── tb/

&#x20;   │   ├── bsr\_if.sv

&#x20;   │   ├── write\_xtn.sv

&#x20;   │   ├── bsr\_pkg.sv

&#x20;   │   ├── wr\_config.sv

&#x20;   │   ├── env\_config.sv

&#x20;   │   ├── wr\_driver.sv

&#x20;   │   ├── wr\_monitor.sv

&#x20;   │   ├── wr\_sequencer.sv

&#x20;   │   ├── wr\_agent.sv

&#x20;   │   ├── wr\_sequence.sv

&#x20;   │   ├── scoreboard.sv

&#x20;   │   ├── environment.sv

&#x20;   │   ├── test.sv

&#x20;   │   └── top.sv

&#x20;   └── sim/

&#x20;       └── run.do



\---



\## Tools Used



| Tool | Purpose |

|------|---------|

| Cadence Xcelium 25.03 | UVM Simulation |

| EDA Playground | Cloud simulation platform |

| Intel ModelSim 20.1 | Local simulation |

| GitHub | Version control |



\---



\## Key Concepts



\*\*Why combinational design?\*\* Barrel shifter is a pure MUX tree — 5 layers of multiplexers for 32-bit. No sequential state, no feedback. Clock would only add latency with no functional benefit.



\*\*Why UVM\_ACTIVE write agent?\*\* Input side generates stimulus — driver needed. Output side is passive — only monitor required.



\*\*Why cross coverage?\*\* Individual coverpoints only confirm that shift=31 was tested and RIGHT direction was tested separately. Cross coverage confirms they were tested together — which is the critical corner case.



\*\*Why 100% coverage does not mean bug-free?\*\* Coverage confirms scenarios were exercised. Bugs are caught by scoreboard comparison and assertions — these work together for complete verification.

