# FPX - Yaskawa Multi-Layer X-Seam Welding

Automated multi-layer welding program for 120mm thick plate X-seam joints using a Yaskawa robot.

## Overview

This project automates the welding of X-seam configurations on heavy plates (120mm thickness, 60mm bevel per side). The program orchestrates multiple weld passes on both the top ("BOVEN") and bottom ("ONDER") sections of the joint.

## Architecture

```
MASTER-START-ML
    ├── MULTILAYER-TESTAFLOOP-BOVEN (Top welding)
    ├── VAN-BOVEN-NAAR-ONDER (Transition)
    ├── MULTILAYER-TESTAFLOOP-ONDER (Bottom welding)
    ├── VAN-ONDER-NAAR-BOVEN (Transition)
    └── (Repeat cycle for multi-pass)
```

## File Structure

```
fpx/
├── job/
│   ├── MASTER-START-ML.JBI        # Main orchestrator
│   ├── MULTILAYER-TESTAFLOOP-BOVEN.JBI  # Top section welding (12 layers)
│   ├── MULTILAYER-TESTAFLOOP-ONDER.JBI  # Bottom section welding (19 layers)
│   ├── VAN-BOVEN-NAAR-ONDER.JBI   # Top→Bottom transition
│   ├── VAN-ONDER-NAAR-BOVEN.JBI   # Bottom→Top transition
│   └── TESTUF-ARNE.JBI            # User frame setup
└── macro/
    ├── ESAB1JOB.JBI               # ESAB welding job selection
    ├── SHIFT-R1.JBI               # Position shift macro
    └── WEAVING.JBI                # Weave pattern parameters
```

## Key Components

### Master Control (`MASTER-START-ML.JBI`)
Orchestrates the complete welding sequence:
- Initializes layer counters (B096-B099)
- Alternates between top/bottom sections
- Passes layer count arguments (ARGF1, ARGF3, ARGF5, ARGF7)

### Welding Jobs
| Job | Section | Layers | Features |
|-----|---------|--------|----------|
| `MULTILAYER-TESTAFLOOP-BOVEN` | Top | 12 | ARCON/ARCOF, weaving, dynamic P001/P002 |
| `MULTILAYER-TESTAFLOOP-ONDER` | Bottom | 19 | Same + 150mm Z-offset for underside |

### Macros
| Macro | Purpose |
|-------|---------|
| `ESAB1JOB` | Selects ESAB weld job via MREG#(188), error handling |
| `SHIFT-R1` | Applies XYZ + RxRyRz shift using P[111] and UF#(15) |
| `WEAVING` | Sets weave amplitude (D080), frequency (D081), angle (D082) |

### User Frame (`TESTUF-ARNE.JBI`)
- Captures weld start/end points (P001, P002)
- Creates User Frame #15 via `MFRAME`
- Uses two taught points for frame definition

## Technical Details

### Position Variables
- **P001**: Weld start point (set by TESTUF-ARNE)
- **P002**: Weld end point (set by TESTUF-ARNE)
- **P003/P004**: Dynamically constructed for ONDER (with Z-offset)

### Welding Parameters
- Arc welding: `ARCON` / `ARCOF`
- Weaving: `WVON AMP=D080 FREQ=D081 ANGL=D082` / `WVOF`
- Weld speed: 5.0 - 5.8 mm/s
- Transition speed: VJ=50.00 - 100.00

### Layer Offsets (ONDER)
- Z-offset: -150mm from base position
- Orientation preserved from taught C00003/C00004 points

## Usage

1. Run `TESTUF-ARNE` to calibrate user frame
2. Execute `MASTER-START-ML` for complete welding cycle
3. Monitor layer progression via B096-B099 registers

## License

Proprietary - Internal use only
