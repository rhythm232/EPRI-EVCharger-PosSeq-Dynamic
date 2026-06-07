# EPRI EVCharger Model — Exactness Audit

**Project:** EPRI_EVCharger_PosSeq_Dynamic_R2024b
**Audit date:** 2026-06-06
**PDF status:** EVCharger_Model_Specifications_2023-Dana_Robson.pdf — NOT available on disk.

> **Overall statement:**
> This is a **qualitative reproduction** of the EPRI EVCharger dynamic behavior,
> **not** an exact parameter-identical implementation.
> No parameter value can be verified against the PDF until the document is provided.

---

## 1. Parameters — Source Classification

### Taken from user specification (traceable to EPRI single-bus test description)

| Parameter | Value | Notes |
|-----------|-------|-------|
| P_total_kW | 21.0 kW | User-specified EPRI test value |
| P_A_kW | 3.2 kW | User-specified |
| P_B_kW | 3.8 kW | User-specified |
| P_C_kW | 3.6 kW | User-specified |
| P_D_kW | 10.4 kW | User-specified |
| sag_depth | 0.5 pu | User-specified |
| sag_duration | 9 / 50 = 0.18 s | User-specified (9 cycles at 50 Hz) |
| sag_start | 1.0 s | User-specified |
| ipmin / ipmax | 0 / 1.0 pu | User-specified |
| iqmin / iqmax | 0 / 0.66 pu | User-specified |
| f_nom | 50 Hz | User-specified |
| Tstop | 4.0 s | User-specified |
| Ts | 1×10⁻⁴ s | User-specified |

### Assumed (not from PDF — WECC/EPRI convention or engineering judgement)

| Parameter | Assumed value | Reason / basis |
|-----------|--------------|----------------|
| Tv | 0.02 s | Standard WECC voltage measurement filter constant |
| UV_A, UV_B, UV_C | 0.70 pu | Typical WECC under-voltage trip threshold |
| UV_delay_A | 0.02 s | Typical fast-trip UV delay |
| UV_delay_B | 0.08 s | Longer delay for EV-D proportional droop phase |
| UV_delay_C | 0.02 s | Same as A (EV-F assumed similar trip speed) |
| cessation_time_A | 0.30 s | Recovery hold-off, EV-B type |
| cessation_time_B | 0.15 s | Shorter hold-off, EV-D type |
| cessation_time_C | 0.50 s | Longer hold-off, EV-F type |
| ramp_time_A | 0.50 s | Slow ramp, EV-B type |
| ramp_time_B | 0.70 s | Medium ramp, EV-D type |
| ramp_time_C | 1.00 s | Slowest ramp, EV-F type |
| dip_D | 0.05 (5%) | Small constant-power dip, EV-A/C/E type |
| recovery_D | 0.20 s | Dip recovery time constant, EV-A/C/E type |
| V_recover | 0.90 pu | Voltage recovery threshold for all fractions |
| V_cease_D | 0.40 pu | Extreme UV threshold for Fraction D |

---

## 2. Figures — Exactness Assessment

| Figure | Qualitative match | What is matched | What differs |
|--------|------------------|-----------------|--------------|
| `epri_voltage_sag.png` | ✓ Good | Step sag 1.0→0.5→1.0, Vmea filter shape | Filter time constant Tv is assumed |
| `epri_fraction_A_response.png` | ✓ Qualitative | Step to zero, delayed ramp recovery | Exact UV thresh, delay, ramp time not from PDF |
| `epri_fraction_B_response.png` | ✓ Qualitative | Proportional droop, cease after timeout, ramp | Droop slope, timeout, ramp not from PDF |
| `epri_fraction_C_response.png` | ✓ Qualitative | Step to zero, long hold-off, slow ramp | All timing assumed |
| `epri_fraction_D_response.png` | ✓ After fix | Near-constant power, tiny dip | Exact dip magnitude and tau assumed |
| `epri_cumulative_response.png` | ✓ Qualitative | Staged recovery C→B→A shape | Timing of each stage assumed |
| `epri_after_fault_recovery.png` | ✓ Qualitative | Three recovery ramp rates visible | Exact ramp rates assumed |
| `epri_dashboard.png` | ✓ Qualitative | All key signals present | Parameter accuracy limited |

---

## 3. Behavior Present vs Missing

### Present in current model

| Behavior | Implementation |
|----------|---------------|
| Fraction A — step cessation on UV, hold-off, linear ramp | State machine in MATLAB Function block |
| Fraction B — proportional current reduction during sag, timeout → cease, ramp | State machine with droop |
| Fraction C — step cessation on UV, longer hold-off, slower ramp | State machine |
| Fraction D — approximately constant power, tiny voltage-dependent dip | First-order filter on IP |
| Vmea voltage measurement filter | Discrete IIR: Vmea[k] = (1-α)·Vmea[k-1] + α·Vt[k] |
| Cessation flags FRA, FRB, FRC | Output from each state machine |
| Cumulative Pout, Qout | Sum of four fractions |

### Missing or simplified relative to the EPRI PDF

| Feature | Status | Notes |
|---------|--------|-------|
| **Reactive power (Iq) control loop** | **NOT IMPLEMENTED** | Q = 0 for all fractions. EPRI model includes a reactive current control with gains and deadband. |
| **Active power PI/proportional control loop** | **SIMPLIFIED** | Current model uses direct IP scale (0 or ramp), not a closed-loop PI on active current. EPRI may use a proportional gain Kp on IP error. |
| **IP/IQ current limiter** | **NOT IMPLEMENTED** | EPRI includes a vector current limit: √(IP²+IQ²) ≤ Imax. Current model only limits IP to [0,1] and IQ=0. |
| **Voltage support (reactive injection during sag)** | **NOT IMPLEMENTED** | EPRI EV-D model may inject reactive current during under-voltage to support the bus. |
| **Fraction-level power factor** | **NOT IMPLEMENTED** | All fractions run at unity PF. EPRI model may assign different base PF per fraction. |
| **Exact cessation UV thresholds from PDF** | **NOT VERIFIED** | UV_A/B/C = 0.70 pu is assumed. |
| **Exact ramp rates from PDF** | **NOT VERIFIED** | All ramp times are engineering assumptions. |
| **Two-stage UV trip (high/low thresholds)** | **NOT IMPLEMENTED** | EPRI may use two UV levels (e.g. instantaneous trip below 0.45 pu, delayed trip below 0.88 pu). |
| **Recovery enable based on time-at-rated-V** | **PARTIAL** | Current model requires Vmea ≥ 0.90 pu for hold-off timer; EPRI may use a hysteresis band. |
| **Network feedback (Vt computed not imposed)** | **NOT IMPLEMENTED** | Vt is an externally imposed playback. EPRI model connects to a power system network. |

---

## 4. Reactive Power / IQ Loop

**Status: NOT IMPLEMENTED.**

The EPRI PDF specifies a reactive current control loop. The current model sets IQ = 0
for all fractions (unity power factor). The control loop from the PDF would include:
- Reactive current command IQ_cmd (from power factor setting or voltage support)
- Dead-band around V = 1.0 pu
- Gain Kq (voltage support slope)
- Limits: IQ ∈ [iqmin, iqmax] = [0, 0.66] pu

This loop is documented here for future implementation.

---

## 5. Active Power Control Loop

**Status: SIMPLIFIED (not closed-loop PI).**

The EPRI model's active power loop likely uses:
```
IP_cmd = P_rated / Vt          (constant-power mode: Ip = P/V)
IP_actual = IP_cmd * cessation_flag
```

The current model implements this as:
```
IP_scale ∈ {0, ramping, 1.0}    (state machine)
P_fr = P_rated_kW * IP_scale    (direct power scaling)
```

This reproduces the shape of the response but does **not** implement a closed-loop
current regulator. The EPRI model may include a rate limiter, low-pass filter, or
proportional gain on the IP error.

---

## 6. Current Limiting Before Cessation

**Status: NOT IMPLEMENTED as a separate block.**

The EPRI model may apply a vector current limit (IP² + IQ² ≤ Imax²) before
the cessation logic, so that during a fault the charger first reduces current
to within limits before deciding to cease. The current model does not have this
priority structure — cessation is triggered purely by voltage threshold.

---

## 7. Recovery Ramp — Applied to Current or Power?

**Current implementation:** Ramp is applied to `IP_scale` (0 → 1), and power is
computed as `P_fr = P_rated * IP_scale`. So the ramp is effectively on the
current command magnitude.

**EPRI model:** The ramp is expected to apply to the **active current command IP**,
not directly to power. Since P = Vt · IP, this means:
- If Vt = 1.0 pu during recovery: P ramp ≡ IP ramp (correct)
- If Vt < 1.0 pu during recovery: P ramp ≠ IP ramp (slight discrepancy)

For the test scenario (Vt recovers to 1.0 pu before ramp begins), the current
implementation is equivalent to the EPRI model.

---

## 8. Summary Table

| Aspect | EPRI PDF | This model | Exactness |
|--------|----------|------------|-----------|
| Fraction powers A/B/C/D | From PDF/user spec | Used exactly | ✓ Reproduced |
| Voltage sag scenario | From user spec | Used exactly | ✓ Reproduced |
| Vmea filter | Tv from PDF | Tv = 0.02 s assumed | ~ Approximated |
| UV cessation thresholds | From PDF | 0.70 pu assumed | ~ Approximated |
| UV delays | From PDF | 0.02/0.08/0.02 s assumed | ~ Approximated |
| Cessation hold-offs | From PDF | 0.30/0.15/0.50 s assumed | ~ Approximated |
| Ramp rates | From PDF | 0.50/0.70/1.00 s assumed | ~ Approximated |
| Fraction D dip | From PDF | 5% dip, τ=0.20 s assumed | ~ Approximated |
| Reactive Iq loop | Specified in PDF | Q = 0 (not implemented) | ✗ Missing |
| Active IP closed loop | Likely in PDF | Direct scaling (simplified) | ~ Approximated |
| Vector current limiter | Likely in PDF | Not implemented | ✗ Missing |
| Voltage support (Iq) | Likely in PDF | Not implemented | ✗ Missing |
| Two-stage UV trip | Possibly in PDF | Single threshold assumed | ~ Approximated |
