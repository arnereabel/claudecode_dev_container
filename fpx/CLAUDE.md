# CLAUDE.md - FPX Yaskawa Welding Project

## Project Context

This is a **Yaskawa robot welding automation** project for multi-layer X-seam welding on 120mm thick steel plates.

### Domain Knowledge
- **JBI format**: Yaskawa INFORM III robot programming language
- **X-seam**: Double-V groove weld requiring welding from both sides
- **BOVEN/ONDER**: Dutch for "top/bottom" - refers to weld sides
- **User Frame (UF)**: Workpiece-relative coordinate system

## File Conventions

### JBI Structure
```
/JOB
//NAME [job-name]
//POS (position data section)
//INST (instruction section)
```

### Key Yaskawa Commands
| Command | Purpose |
|---------|---------|
| `MOVJ` | Joint interpolated move |
| `MOVL` | Linear interpolated move |
| `ARCON/ARCOF` | Start/stop arc welding |
| `WVON/WVOF` | Start/stop weaving |
| `SFTON/SFTOF` | Enable/disable position shift |
| `CALL JOB:` | Call subroutine job |
| `MACRO1 MJ#()` | Call macro with arguments |

### Variables
- **B000-B999**: Byte registers (counters)
- **D000-D999**: Double word registers (coordinates)
- **P000-P999**: Position variables (6 elements: X,Y,Z,Rx,Ry,Rz)
- **LB/LD/LR**: Local variables

## Build & Test

JBI files are uploaded directly to the Yaskawa controller via:
- USB transfer
- Ethernet (FTP/SFTP)
- YRC1000 programming pendant

## Important Notes

1. **User Frame 15** is the primary workpiece frame
2. **Tool 1** is the welding torch
3. Layer parameters are passed via `ARGF` arguments
4. Counter registers: B096 (BOVEN total), B097 (ONDER total), B098/B099 (current layer)
