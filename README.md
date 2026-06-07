# EPRI EVCharger Positive-Sequence Dynamic Model (R2024b)

MATLAB/Simulink implementation of the EPRI aggregated EV charger positive-sequence dynamic model, based on the EPRI specification by Dana Robson (2023). Built in MATLAB R2024b.

This is a **work in progress**. The Simulink model files are not included in this repository.

---

## What this model is

The EPRI EVCharger model represents the aggregate voltage-ride-through (VRT) behaviour of a mixed EV charger fleet connected at a single bus. It is a phasor/RMS-domain load model suitable for power system stability studies — not a three-phase EMT model, not a feeder model.

The model divides the total load (21 kW) into four behavioural fractions:

| Fraction | EV type | Power | Behaviour during voltage sag |
|----------|---------|-------|------------------------------|
| A | EV-B | 3.2 kW | Ceases immediately, long hold-off, slow ramp back |
| B | EV-D | 3.8 kW | Proportional current reduction, then cessation, ramp back |
| C | EV-F | 3.6 kW | Ceases immediately, medium hold-off, medium ramp back |
| D | EV-A/C/E | 10.4 kW | Approximately constant power, stays connected |

Test scenario: 0.5 pu voltage sag for 9 cycles at 60 Hz (0.150 s), starting at t = 4.5 s.

---

## Repository contents

```
scripts/    MATLAB scripts for building the model, running simulations, and plotting results
data/       Parameter file (epri_ev_params.mat) and simulation results (epri_simulation_results.mat)
docs/       Parameter tables, interpretation notes, verification reports, exactness audit
figures/    Output plots from the simulation
```

---

## How to run

1. Open MATLAB R2024b
2. Set the working directory to the repo root
3. Run `scripts/epri_ev_params_init.m` to load parameters into the workspace
4. Run `scripts/run_epri_evcharger_simulation.m` to run the simulation
5. Run `scripts/analyze_epri_evcharger_results.m` to generate plots

The Simulink model (`.slx`) is not included. `scripts/build_epri_evcharger_posseq_model.m` rebuilds it programmatically from scratch — run this first if the model file is missing.

---

## Parameters

All Appendix A parameters are taken directly from the EPRI PDF:

- Cessation thresholds: `vcA = 0.60`, `vcB = 0.70`, `vcC = 0.60` pu
- Detection delays: `tcA = 0.005`, `tcB = 0.120`, `tcC = 0.010` s
- Reconnect thresholds: `vrA = vrB = vrC = 0.6` pu
- Reconnect delays: `trA = 8.0`, `trB = 3.0`, `trC = 1.0` s
- Ramp times: `trampA = 5.0`, `trampB = 3.0`, `trampC = 1.0` s
- Fraction B: constant current (`nPB = 1`)
- Current limits: `ipmax = 2.0`, `ipmin = -2.0` pu
- Washout: `Kvp = 0.20`, `Tvp = 0.02` s

---

## What is not implemented

- **Reactive current (Iq) control loop** — Q = 0 for all fractions
- **Vector current limiter** — only IP is limited; the `sqrt(IP² + IQ²) ≤ Imax` constraint is not applied
- **Voltage support (reactive injection during sag)** — not implemented
- **Lead-lag block** (Ta = 0.1, Tb = 0.2) — noted in parameters, not added as a block
- **Network feedback** — terminal voltage is an imposed playback, not computed from network equations

See `docs/epri_exactness_audit.md` for the full audit.

---

## Status

PDF-calibrated qualitative reproduction. All cessation/reconnect/ramp parameters match Appendix A. Reactive power loop and vector current limiter are still missing. Simulation results pass all sanity checks (pre-sag Pout = 21 kW, staged recovery, full recovery after fault).

---

## Reference

Dana Robson, *EVCharger Model Specifications*, EPRI, 2023.
