# Simulation models for GOWIN FPGA primitives

## DPB - BSRAM Dual Port Memory

**Current Limittations**
 - BIT_WIDTH_1 must be the same as BIT_WIDTH_0
 - RESET_MODE must be SYNC
 - READ_MODE0 must be 0 (bypass)
 - READ_MODE1 must be 0 (bypass)
 - WRITE_MODE0 must be 0 (normal)
 - WRITE_MODE1 must be 0 (normal)
 - Pre-initialization not implemnted
