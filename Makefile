# -----------------------------------------------------------------------------
#	Brief: Make file for this project. (For UNIX Like ENV)
#
# Usage:
#   make                       → run default TB (top_tb)
#   make TB=tb/counter_tb.sv   → run specific TB
#   make wave                  → open waveform
#   make wave WAVE=sim/foo.vcd → open specific waveform
#   make synth                 → generate netlist using Yosys
#   make show                  → visualize synthesized design
#   make show TOP=counter      → visualize specific module
#   make clean                 → cleanup
# -----------------------------------------------------------------------------

# -----------------------------
# Variables
# -----------------------------
RTL      = rtl/*.sv
OUT      = build/sim.out
LOG      = sim/run.log
NETLIST  = build/netlist.v
TB   ?= tb/top_tb.sv
WAVE ?= sim/top.vcd
TOP  ?= top

# -----------------------------
# Default
# -----------------------------
all: sim

# -----------------------------
# Build (compile only)
# -----------------------------
build:
	@mkdir -p build sim
	@echo "[BUILD] Using TB: $(TB)"
	@iverilog -g2012 -Wall -o $(OUT) $(TB) $(RTL)

# -----------------------------
# Run simulation
# -----------------------------
sim: build
	@echo "[SIM] Running..."
	@vvp $(OUT) | tee $(LOG)

# -----------------------------
# Waveform viewer
# -----------------------------
wave:
	@echo "[WAVE] Opening $(WAVE)"
	@gtkwave $(WAVE) &

# -----------------------------
# Synthesis (Yosys)
# -----------------------------
synth:
	@mkdir -p build
	@echo "[SYNTH] Top = $(TOP)"
	@yosys -p "read_verilog -sv rtl/*.sv; prep -top $(TOP); synth; write_verilog $(NETLIST)"

# -----------------------------
# Visualize synthesized circuit
# -----------------------------
show:
	@echo "[SHOW] Top = $(TOP)"
	@yosys -p "read_verilog -sv rtl/*.sv; prep -top $(TOP); select -module $(TOP); show"

# -----------------------------
# Clean
# -----------------------------
clean:
	@echo "[CLEAN]"
	@echo "- sim/*.vcd"
	@echo "- sim/*.log"
	@echo "- build/"
	@rm -rf build sim/*.vcd sim/*.log

.PHONY: all build sim wave synth show clean
