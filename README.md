# 4-Digit BCD Counter (Verilog)

## Overview

This project implements a **4-digit BCD (Binary-Coded Decimal) counter** in Verilog.

The counter counts from:

```
0000 → 0001 → 0002 → ... → 9999 → 0000
```

Each decimal digit is represented using **4 bits (BCD encoding)**.
The design uses **cascaded decade counters**, where each higher digit increments when the lower digit overflows from **9 → 0**.

This project demonstrates:

* Multi-digit counter design
* BCD number representation
* Cascaded enable logic
* RTL design in Verilog
* Digital simulation using **Icarus Verilog** and **GTKWave**

---

# Counter Architecture

The counter consists of **four BCD digits**:

| Bits       | Digit     |
| ---------- | --------- |
| `q[3:0]`   | Ones      |
| `q[7:4]`   | Tens      |
| `q[11:8]`  | Hundreds  |
| `q[15:12]` | Thousands |

Each digit counts **0–9**.

When a digit reaches **9**, it resets to **0** and generates an **enable signal** to increment the next digit.

---

# Enable Signals

The design produces enable signals for upper digits:

| Signal   | Description                 |
| -------- | --------------------------- |
| `ena[1]` | Enables **tens digit**      |
| `ena[2]` | Enables **hundreds digit**  |
| `ena[3]` | Enables **thousands digit** |

Enable logic:

```
ena[1] = ones == 9
ena[2] = ones == 9 AND tens == 9
ena[3] = ones == 9 AND tens == 9 AND hundreds == 9
```

This cascading structure allows higher digits to increment only when required.

---

# Module Interface

| Signal  | Direction | Width | Description                      |
| ------- | --------- | ----- | -------------------------------- |
| `clk`   | Input     | 1     | Clock input                      |
| `reset` | Input     | 1     | Synchronous reset                |
| `ena`   | Output    | 3     | Enable signals for higher digits |
| `q`     | Output    | 16    | 4-digit BCD output               |

---

# Verilog Implementation

```verilog
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output reg [15:0] q
);

assign ena[1] = (q[3:0] == 4'd9);
assign ena[2] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
assign ena[3] = (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);

always @(posedge clk) begin
    if (reset)
        q <= 16'd0;
    else begin
        // Ones digit
        if (q[3:0] == 4'd9)
            q[3:0] <= 4'd0;
        else
            q[3:0] <= q[3:0] + 1;

        // Tens digit
        if (ena[1]) begin
            if (q[7:4] == 4'd9)
                q[7:4] <= 4'd0;
            else
                q[7:4] <= q[7:4] + 1;
        end

        // Hundreds digit
        if (ena[2]) begin
            if (q[11:8] == 4'd9)
                q[11:8] <= 4'd0;
            else
                q[11:8] <= q[11:8] + 1;
        end

        // Thousands digit
        if (ena[3]) begin
            if (q[15:12] == 4'd9)
                q[15:12] <= 4'd0;
            else
                q[15:12] <= q[15:12] + 1;
        end
    end
end

endmodule
```

---

# Counter Example

| Decimal | BCD Output          |
| ------- | ------------------- |
| 0       | 0000 0000 0000 0000 |
| 1       | 0000 0000 0000 0001 |
| 9       | 0000 0000 0000 1001 |
| 10      | 0000 0000 0001 0000 |
| 99      | 0000 0000 1001 1001 |
| 100     | 0000 0001 0000 0000 |
| 9999    | 1001 1001 1001 1001 |

After **9999**, the counter returns to **0000**.

---

# Simulation

## Required Tools

* **Icarus Verilog**
* **GTKWave**

Install (Ubuntu):

```
sudo apt install iverilog gtkwave
```

---

# Run Simulation

Compile the design and testbench:

```
iverilog -o sim.out top_module.v tb_top_module.v
```

Run simulation:

```
vvp sim.out
```

View waveform:

```
gtkwave wave.vcd
```

---

# Project Structure

```
4-digit-bcd-counter/
│
├── top_module.v
├── tb_top_module.v
├── wave.vcd
└── README.md
```

---

# Concepts Demonstrated

* BCD number system
* Cascaded counters
* Synchronous digital design
* RTL modeling in Verilog
* Hardware simulation and waveform analysis

---

# Author

**Arkaprava Paul**
