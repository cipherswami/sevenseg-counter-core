# Seven-Segment Counter Core

Seven-Segment LED Counter core written in System-Verilog just for fun, designed to be used for both FPGA and ASIC flows.

## Status

- RTL Design: complete
- RTL Verification: complete
- Synthesis: verified
- FPGA validation: pending

## RTL Design

- **clock_divider.sv**: Generates a slower enable signal for human-visible counting.

- **sevenseg_decoder.sv**: Converts BCD input to seven-segment outputs.

- **counter.sv**: Modulo 10 counter (0 → 9).

- **top.sv**: Top-level module integrating all components.

## RTL Verification

### Simulation

Run top level test bench:

```bash
make all
```

Run specific test bench:

```bash
make TB=tb/clock_divider_tb.sv
make TB=tb/sevenseg_decoder_tb.sv
make TB=tb/counter_tb.sv
```

### Waveform

View top level wave form:

```bash
make wave
```

View specific wave form:

```bash
make wave WAVE=sim/clock_divider.vcd
make wave WAVE=sim/sevenseg_decoder.vcd
make wave WAVE=sim/counter.vcd
```

## Synthesis

Synthesize RTL using Yosys:

```bash
make synth
```

Visualize top level module:

```bash
make show
```

Visualize specific module:

```bash
make show TOP=clock_divider
make show TOP=sevenseg_decoder
make show TOP=counter
```

<!-- ## Segment Mapping -->
<!---->
<!-- ```id="segmap1" -->
<!--     a -->
<!--   f   b -->
<!--     g -->
<!--   e   c -->
<!--     d -->
<!-- ``` -->
<!---->
<!-- ```id="segmap2" -->
<!-- seg[6:0] = { a, b, c, d, e, f, g } -->
<!-- ``` -->

## License

This project is licensed under the CERN Open Hardware Licence Version 2 – Weakly Reciprocal (CERN-OHL-W-2.0).

See the [LICENSE](./LICENSE) file for full terms.
