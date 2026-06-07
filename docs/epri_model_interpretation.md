# EPRI EVCharger Positive-Sequence Dynamic Model — Interpretation Notes

**Source:** EVCharger_Model_Specifications_2023 — Dana Robson (EPRI)
**Status:** PDF not available on disk. All interpretations below are based on
(a) the model specification text provided by the user, and
(b) publicly known EPRI EV charger modelling conventions (EPRI 3002026919, WECC LVRT taxonomy).

---

## 1. What the EPRI EVCharger Positive-Sequence Model Represents

The EPRI EVCharger model is a **positive-sequence, aggregated, load-side dynamic model**
for electric vehicle (EV) charger stations. It captures the aggregate voltage-ride-through (VRT)
behaviour of a mixed EV charger fleet at a single bus in a transmission or distribution system.

It is **not** a three-phase unbalanced feeder model. It is **not** a switching-level EMT model.
It is a phasor/RMS-domain load model suitable for stability studies (PSLF, PSS/E, OpenDSS dynamic).

---

## 2. Active Power Control Loop

The model uses an **active current (Ip) command** rather than direct power command:

    P_output = Vt * Ip

where Vt is the terminal voltage magnitude (pu) and Ip is the active current injection (pu).

Each fraction computes its own Ip_fraction based on:
- Pre-disturbance Ip command (set by rated fraction power)
- Cessation logic (Ip → 0 when UV condition is met)
- Ramp-back logic (Ip ramps from 0 → rated after recovery delay)

Current limits:
    ipmin = 0     (no reverse active current)
    ipmax = 1.0   (pu of rated current)

---

## 3. Reactive Power Control Loop

The EPRI model includes a reactive current (Iq) loop. In this first implementation:
- Iq = 0 (unity power factor assumed for all fractions)
- iqmin = 0, iqmax = 0.66 (from user spec, to be used when Iq loop is added)

**Assumption:** Q = 0 for this first version. The user specification states exact Iq
control parameters are not yet available from the PDF.

---

## 4. Fraction A, B, C, D Behaviour

### Fraction D — EV-A / EV-C / EV-E type (≈ Constant Power, 10.4 kW)
- Chargers that maintain approximately constant active power throughout the disturbance.
- Small transient dip (≈5%) during deep voltage sag, recovering within ~0.2 s.
- No cessation state machine. No ramp hold-off.
- Represents: Level-2 AC chargers with robust active front-end control.

### Fraction A — EV-B type (Cease + Long Hold-off + Slow Ramp, 3.2 kW)
- Ceases charging when Vmea < UV_A (0.70 pu) for longer than UV_delay_A (0.02 s).
- Stays ceased until voltage recovers AND a hold-off timer (cessation_time_A = 0.30 s) expires.
- Ramps back to rated power over ramp_time_A = 0.50 s.
- FRA = 1 when fraction is in normal charging state; cessation_A = 1 when ceased.

### Fraction B — EV-D type (Voltage-Dependent Reduction → Cease → Ramp, 3.8 kW)
- During voltage sag: active current proportionally reduced (Ip ∝ Vmea / UV_B).
- After timeout UV_delay_B = 0.08 s at reduced voltage: ceases completely.
- After voltage recovery AND hold-off timer cessation_time_B = 0.15 s: ramp back.
- Ramp time ramp_time_B = 0.70 s.
- FRB = 1 when in normal charging.

### Fraction C — EV-F type (Cease + Short Hold-off + Slow Ramp, 3.6 kW)
- Ceases when Vmea < UV_C (0.70 pu) for longer than UV_delay_C (0.02 s).
- Hold-off after voltage recovery: cessation_time_C = 0.50 s (longer than A).
- Ramp time: ramp_time_C = 1.00 s (slower than A).
- FRC = 1 when charging normally.

---

## 5. Voltage Sag Test Setup

- Single-bus test: terminal voltage Vt steps from 1.0 pu → sag_depth → 1.0 pu.
- sag_depth  = 0.5 pu (50% retained voltage)
- sag_start  = 1.0 s
- sag_duration = 9 cycles at 50 Hz = 9/50 = 0.18 s
- sag_end    = 1.18 s
- Measured voltage Vmea is filtered: dVmea/dt = (Vt - Vmea) / Tv
  **Assumption:** Tv = 0.02 s (not extracted from PDF — standard WECC/EPRI value).

---

## 6. Output Variables

| Variable    | Description |
|-------------|-------------|
| Vt_pu       | Terminal voltage magnitude (pu) |
| Vmea        | Filtered/measured voltage (pu) |
| PfrA..D     | Active power of each fraction (kW) |
| QfrA..D     | Reactive power of each fraction (kvar) |
| IPfA..D     | Active current component per fraction (pu) |
| IQfA..D     | Reactive current per fraction (pu) |
| FRA/FRB/FRC | Not-ceased flag (1=charging, 0=ceased) per fraction |
| cessation_A/B/C | Cessation status (1=ceased or recovering) |
| Pout        | Total aggregate active power (kW) |
| Qout        | Total aggregate reactive power (kvar) |

---

## 7. Parameters — Source and Assumptions

| Parameter | Value | Source |
|-----------|-------|--------|
| P_total_kW | 21.0 | User specification (EPRI single-bus test) |
| P_A_kW | 3.2 | User specification |
| P_B_kW | 3.8 | User specification |
| P_C_kW | 3.6 | User specification |
| P_D_kW | 10.4 | User specification |
| sag_depth | 0.5 pu | User specification |
| sag_duration | 9 cycles / 50 Hz | User specification |
| Tv | 0.02 s | **ASSUMPTION** — standard WECC value |
| UV_A, UV_B, UV_C | 0.70 pu | **ASSUMPTION** — typical WECC LVRT threshold |
| UV_delay_A, UV_C | 0.02 s | **ASSUMPTION** |
| UV_delay_B | 0.08 s | **ASSUMPTION** |
| cessation_time_A | 0.30 s | **ASSUMPTION** |
| cessation_time_B | 0.15 s | **ASSUMPTION** |
| cessation_time_C | 0.50 s | **ASSUMPTION** |
| ramp_time_A | 0.50 s | **ASSUMPTION** |
| ramp_time_B | 0.70 s | **ASSUMPTION** |
| ramp_time_C | 1.00 s | **ASSUMPTION** |
| dip_D | 0.05 (5%) | **ASSUMPTION** |
| recovery_D | 0.20 s | **ASSUMPTION** |
| ipmin/ipmax | 0 / 1.0 | User specification |
| iqmin/iqmax | 0 / 0.66 | User specification |

## 8. Parameters Not Extractable

The following require the actual EPRI PDF Appendix A / Table 1:
- Exact UV trip thresholds per fraction
- Exact cessation hold-off timing
- Exact ramp rates
- Reactive current control gains (Kq, deadband)
- IP/IQ coupling logic

If the PDF becomes available, replace all **ASSUMPTION** values above with exact EPRI values.
