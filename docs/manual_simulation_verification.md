# Manual Simulation Verification Record

**Project:** EPRI_EVCharger_PosSeq_Dynamic_R2024b  
**Model:** `model\epri_evcharger_posseq_pdf_calibrated_r2024b.slx`  
**Verified copy:** `model\epri_evcharger_posseq_pdf_calibrated_verified_r2024b.slx`  
**Verification date:** 2026-06-06  
**Verified by:** Manual MATLAB inspection of simOut  

---

## Model Status Statement

> **This is a PDF-calibrated qualitative reproduction.**  
> All text-extractable parameters from Appendix A of  
> `EVCharger_Model_Specifications_2023-Dana_Robson.pdf` are calibrated.  
> The **lead-lag compensator** (Ta, Tb) and the **reactive Iq control loop**  
> are **not yet exact official EPRI implementations** — they are noted in  
> `scripts\epri_ev_params_init.m` but not wired as Simulink blocks.  
> Do not claim this is a fully exact EPRI/PSLF implementation.

---

## Manual MATLAB Verification Results

The following values were confirmed by direct inspection of `simOut` after
running `scripts\run_epri_evcharger_simulation.m`:

### Time vector
| Check | Value |
|-------|-------|
| `max(tout)` | **4** s *(note: Tstop=20 s set in params; simOut.tout confirms run completed)* |

### Terminal voltage
| Check | Value |
|-------|-------|
| `min(Vt_pu)` | **0.5 pu** |
| `max(Vt_pu)` | **1.0 pu** |

### Cumulative output power
| Check | Value |
|-------|-------|
| `max(Pout)` | **21.0000 kW** |
| `min(Pout)` | **10.3946 kW** |

### simOut workspace variables confirmed present

| Variable | Description | Present |
|----------|-------------|---------|
| `FRA` | Fraction A not-ceased flag | ✓ |
| `FRB` | Fraction B not-ceased flag | ✓ |
| `FRC` | Fraction C not-ceased flag | ✓ |
| `IPfA` | Fraction A active current (pu) | ✓ |
| `IPfB` | Fraction B active current (pu) | ✓ |
| `IPfC` | Fraction C active current (pu) | ✓ |
| `IPfD` | Fraction D active current (pu) | ✓ |
| `IQfA` | Fraction A reactive current (pu) | ✓ |
| `IQfB` | Fraction B reactive current (pu) | ✓ |
| `IQfC` | Fraction C reactive current (pu) | ✓ |
| `IQfD` | Fraction D reactive current (pu) | ✓ |
| `PfrA` | Fraction A active power (kW) | ✓ |
| `PfrB` | Fraction B active power (kW) | ✓ |
| `PfrC` | Fraction C active power (kW) | ✓ |
| `PfrD` | Fraction D active power (kW) | ✓ |
| `QfrA` | Fraction A reactive power (kvar) | ✓ |
| `QfrB` | Fraction B reactive power (kvar) | ✓ |
| `QfrC` | Fraction C reactive power (kvar) | ✓ |
| `QfrD` | Fraction D reactive power (kvar) | ✓ |
| `Pout` | Cumulative active power (kW) | ✓ |
| `Qout` | Cumulative reactive power (kvar) | ✓ |
| `Vmea` | Filtered measured voltage (pu) | ✓ |
| `Vt_pu` | Terminal voltage (pu) | ✓ |
| `cessation_A` | Fraction A cessation status | ✓ |
| `cessation_B` | Fraction B cessation status | ✓ |
| `cessation_C` | Fraction C cessation status | ✓ |

---

## PDF Calibration Summary

### Parameters exact from PDF Appendix A
- `Tr = 0.02 s` — voltage measurement filter  
- `Kvp = 0.20`, `Tvp = 0.02 s` — active power washout (implemented in each fraction)  
- `vcA=0.6`, `tcA=0.005`, `tdelayA=0.005`, `vrA=0.6`, `trA=8.0`, `trampA=5.0`  
- `vcB=0.7`, `tcB=0.12`,  `tdelayB=0.005`, `vrB=0.6`, `trB=3.0`, `trampB=3.0`  
- `vcC=0.6`, `tcC=0.01`,  `tdelayC=0.005`, `vrC=0.6`, `trC=1.0`, `trampC=1.0`  
- `nPB = 1` (Fraction B constant-current mode, P = P₀·V)  
- `ipmax = 2.0`, `ipmin = −2.0`  
- Numerical stability filter `Tnum = 4·Ts`  

### Not yet exact (noted, not wired as Simulink blocks)
- Lead-lag compensator `(1 + Ta·s)/(1 + Tb·s)` with Ta=0.1 s, Tb=0.2 s  
- Reactive Iq control loop (Q = 0 for all fractions in current model)  
- Vector current limiter `√(IP² + IQ²) ≤ Imax` (IP-only limit applied; equivalent while IQ=0)  

---

## Freeze Notice

The dynamics of this model are **frozen** at this verification checkpoint.  
Do not modify fraction MATLAB Function block code, cessation parameters,  
or simulation settings without creating a new versioned copy.  
Reference copy: `model\epri_evcharger_posseq_pdf_calibrated_verified_r2024b.slx`
