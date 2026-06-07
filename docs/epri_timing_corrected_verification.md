# EPRI EVCharger — Timing-Corrected Verified Model

**Frozen copy:** `model\epri_evcharger_posseq_epri_timing_corrected_verified_r2024b.slx`  
**Source model:** `model\epri_evcharger_posseq_epri_timing_corrected_r2024b.slx`  
**Source PDF:** `EVCharger_Model_Specifications_2023-Dana_Robson.pdf`  
**Date frozen:** 2026-06-06

---

## Simulation Settings

| Parameter | Value |
|-----------|-------|
| Tstop | 20 s |
| f_nom | 60 Hz |
| Ts | 1×10⁻⁴ s |

## Voltage Sag

| Parameter | Value |
|-----------|-------|
| Sag start | 4.5 s |
| Sag end | 4.65 s |
| Sag duration | 0.15 s |
| Sag description | 150 ms / 9 cycles at 60 Hz |
| Vt_pu during sag | 0.5 pu |
| Vt_pu normal | 1.0 pu |
| Vt_pu min / max | 0.5 / 1.0 |

## Nominal Fraction Powers

| Fraction | Type | P (kW) |
|----------|------|--------|
| A | EV-B | 3.2 |
| B | EV-D | 3.8 |
| C | EV-F | 3.6 |
| D | EV-A/C/E | 10.4 |
| **Total** | | **21.0** |

## Qualitative Behavior

| Fraction | Behavior |
|----------|----------|
| Fraction A (EV-B) | Ceases at sag onset. Slow recovery — ramp begins ≈12.65 s, returns to nominal ≈17.65 s |
| Fraction B (EV-D) | Proportional current reduction during sag, ceases after 0.125 s. Medium recovery ≈10.65 s |
| Fraction C (EV-F) | Ceases at sag onset. Fast recovery — returns to nominal ≈6.65 s |
| Fraction D (EV-A/C/E) | Remains approximately constant power ≈10.4 kW throughout |
| Pout | Drops from 21 kW to ≈10.4 kW at sag; recovers in stages C→B→A; returns to 21 kW by ≈17.65 s |

## Generated Figures

| File | EPRI Figure |
|------|-------------|
| `figures\epri_voltage_sag.png` | Fig. 5 |
| `figures\epri_fraction_A_response.png` | Fig. 6 (EV-B) |
| `figures\epri_fraction_B_response.png` | Fig. 7 (EV-D) |
| `figures\epri_fraction_C_response.png` | Fig. 8 (EV-F) |
| `figures\epri_fraction_D_response.png` | Fig. 9 (EV-A/C/E) |
| `figures\epri_cumulative_response.png` | Fig. 10 |
| `figures\epri_after_fault_recovery.png` | Recovery ramps |
| `figures\epri_fraction_overlay_summary.png` | Overlay summary |
| `figures\epri_dashboard.png` | Dashboard |

## Exactness Status

> **PDF-calibrated qualitative reproduction with corrected EPRI timing.**

All Appendix A text-extractable parameters are calibrated. Timing matches the
EPRI single-bus test (60 Hz, sag at t = 4.5 s, 9 cycles = 0.15 s).

**This is not an exact official EPRI/PSLF implementation.**

### Directly reproduced from PDF Appendix A
- All cessation thresholds vcA/B/C and detection delays tcA/B/C
- All reconnect thresholds vrA/B/C and reconnect delays trA/B/C
- All ramp times trampA/B/C
- nPB = 1 (Fraction B constant current)
- ipmax = 2.0, ipmin = −2.0
- Washout Kvp = 0.20, Tvp = 0.02 s
- Numerical stability filter Tnum = 4·Ts

## Limitations

- **Lead-lag compensator** (Ta = 0.1 s, Tb = 0.2 s): parameters recorded in
  `scripts\epri_ev_params_init.m` but not wired as a Simulink block.
  Figure 2 in the PDF is a raster image — exact signal routing cannot be confirmed.
- **Reactive Iq control loop**: Q = 0 for all fractions. Figure 3 in the PDF is a
  raster image — topology cannot be confirmed. Structural code exists in the
  experimental model but is inactive with Q₀ = 0.
- **Vector current limiter** √(IP² + IQ²) ≤ Imax: IP-only limit applied
  (equivalent while IQ = 0).
- **Network feedback**: Vt is externally imposed; not computed from a power
  system network equation.

## Freeze Notice

The dynamics of this model are **frozen** at this verification checkpoint.  
Reference frozen copy: `model\epri_evcharger_posseq_epri_timing_corrected_verified_r2024b.slx`  
Do not modify fraction MATLAB Function block code or simulation settings without
creating a new versioned copy.
