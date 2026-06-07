# Block Diagram Experimental Notes

**Project:** EPRI_EVCharger_PosSeq_Dynamic_R2024b  
**Experimental model:** `model\epri_evcharger_posseq_blockdiagram_experimental_r2024b.slx`  
**Date:** 2026-06-06  
**Based on:** `model\epri_evcharger_posseq_pdf_calibrated_verified_r2024b.slx`

---

## PDF Figure Inspection Result

Both block diagram figures were inspected by page-by-page PDF text extraction:

| PDF Page | Content | Readable? |
|----------|---------|-----------|
| Page 14 | `"1-4   Figure 2 Active power control loo"` (46 chars total) | **NO — raster image only** |
| Page 15 | `"1-5   Figure 3 Reactive power control loo"` (45 chars total) | **NO — raster image only** |

**Conclusion:** Figures 2 and 3 are embedded raster images. No block-level topology, signal routing, gain values, or summing junction signs are readable via text extraction. Every implementation below is derived exclusively from the **text description** on Page 13 and **parameter tables** from Pages 16–18 and Appendix A.

---

## What Can Be Determined From Text Alone

### Active power control loop (Figure 2) — text-reconstructed topology

From the numbered description on PDF page 13 (section "Model description"), the signal flow is:

```
Vt  →  [Tr filter]  →  Vmea
                         |
                    [Washout: Kvp·Tvp·s/(Tvp·s+1)]  →  ΔP_washout
                         |
                    [Freq droop: kdroop] (disabled: kdroop=0)
                         |
                    [Lead-lag: (1+Ta·s)/(1+Tb·s)]  →  V_ll
                         |
              ┌──────────┼──────────┬──────────┐
          [FrA]       [FrB]      [FrC]      [FrD]
          nPA=0       nPB=1      nPC=0      nPD=0
           |            |          |          |
         P·V^0        P·V^1      P·V^0      P·V^0
           |            |          |          |
         [I=P/V]     [I=const]  [I=P/V]    [I=P/V]
           |            |          |          |
         [ipmax]     [ipmax]    [ipmax]    [ipmax]
           |            |          |          |
         [Cessation A][Cess B]  [Cess C]  [no cess]
           |            |          |          |
         PfrA         PfrB       PfrC       PfrD
```

**Confidence:** The block sequence (washout → lead-lag → fractions) is stated explicitly in items 1–4 of the text. The fraction split after lead-lag is explicitly stated in item 4.

**Cannot determine from text:**
- Whether ΔP_washout is added before or after the lead-lag (assumed: before, into the effective V command)
- Exact summing junction signs at the washout–lead-lag connection
- Whether lead-lag input is V or (V + washout_output)

### Reactive power control loop (Figure 3) — text-reconstructed topology

From PDF page 13: *"The structures of the active and reactive power response paths are similar. The only difference being the inclusion of an optional frequency-based droop for active power output."*

Reconstructed reactive path:

```
Vt  →  [Tr filter]  →  Vmea
                         |
                    [Washout: Kvq·Tvq·s/(Tvq·s+1)]  →  ΔQ_washout
                         |
                    [No frequency droop on Q]
                         |
                    [Lead-lag: (1+Ta·s)/(1+Tb·s)]  →  V_ll_q
                         |
              ┌──────────┼──────────┬──────────┐
          [FrA]       [FrB]      [FrC]      [FrD]
          nQA=0       nQB=1      nQC=0      nQD=0
           |            |          |          |
         Q·V^0        Q·V^1      Q·V^0      Q·V^0
           |            |          |          |
         [IQ=Q/V]    [IQ=const] [IQ=Q/V]   [IQ=Q/V]
           |            |          |          |
         [iqmax]     [iqmax]    [iqmax]    [iqmax]
           |            |          |          |
         QfrA         QfrB       QfrC       QfrD
```

**Confidence:** Reasonable — derived from "similar structure" statement and parameter names.

**Cannot determine from text:**
- Whether cessation logic applies to Q (active cessation assumed to also gate Q — uncertain)
- Exact position of Q0 initialization in the PSLF model
- Whether IQ provides voltage support (positive Q injection during undervoltage)
- Cross-coupling between IP and IQ (vector current limit `sqrt(IP²+IQ²)`)

---

## Lead-Lag Compensator

### Transfer function
`H(s) = (1 + Ta·s) / (1 + Tb·s)`  
with **Ta = 0.1 s, Tb = 0.2 s** from Appendix A.

Since Tb > Ta, this is a **first-order lag compensator**:
- DC gain = 1.0
- High-frequency gain = Ta/Tb = 0.5
- Attenuates fast transients; steady-state P unchanged

### Discretisation (Tustin bilinear, Ts = 1×10⁻⁴ s)

```
A = 2·Ta/Ts = 2000
B = 2·Tb/Ts = 4000

y[k] = (A+1)/(B+1) · x[k]  +  (1-A)/(B+1) · x[k-1]  +  (B-1)/(B+1) · y[k-1]
     = 2001/4001 · x[k]  -  1999/4001 · x[k-1]  +  3999/4001 · y[k-1]
```

where `x = Vmea` and `y = Vll` (lead-lag filtered voltage).

**Implementation location:** Inside each fraction's MATLAB Function block as a 3-persistent-variable IIR filter. Applied to `Vmea` before the `IP_raw` power calculation. Cessation detection retains raw `Vmea`.

**Confidence in this block: HIGH** — transfer function form and parameters are unambiguous from text + Appendix A.

---

## Reactive Iq Loop

### What is implemented

For each fraction `X` with power exponent `nQX`:
```
IQ_raw_X = Q0_fr_X · Vll^(nQX - 1)    (analogous to IP = P0 · V^(nP-1))
IQ_X     = clamp(IQ_raw_X · Iramp_X, iqmin, iqmax)
Q_fr_X   = Vll · IQ_X · P_rated_X
```

Reactive washout (parallel to active):
```
Wout_q[k] = (Tvq/(Tvq+Ts))·Wout_q[k-1] + Kvq·(Vmea[k] - Vmea[k-1])
```

with **Kvq = 0.16, Tvq = 0.02 s** from Appendix A.

### Critical limitation

**Q0_fr = 0 for all fractions** (initial reactive power from power flow is not available in this implementation). Therefore `IQ = 0` and `Q = 0` for all fractions numerically, identical to the verified model. The structural code is present and correct for non-zero Q0.

To activate the reactive loop:
1. Provide Q0 from a power flow solution (Q0_A, Q0_B, Q0_C, Q0_D in kvar)
2. Set `Q0_fr` inside each fraction's MATLAB Function block
3. The nQ exponent scaling and IQ limits will then be active

### What is NOT implemented (image-only in PDF)

| Feature | Reason not implemented |
|---------|----------------------|
| Whether cessation gates IQ (same as IP) | Figure 3 is image-only — cannot confirm |
| Vector current limiter `sqrt(IP²+IQ²) ≤ Imax` | Figure 2/3 image-only; IP-only limit retained |
| Exact washout–lead-lag summing junction | Figure 2 image-only |
| Voltage support mode (IQ injected during sag) | Not mentioned in text; Figure 3 image-only |

---

## Changes from Verified Model

| Change | Before (verified) | After (experimental) |
|--------|-------------------|----------------------|
| Lead-lag on Vmea | Not applied | Applied: `Vll = (Ta,Tb) filter of Vmea`; used for IP/IQ power calc |
| IQ_pu | Always 0 | Structural Q loop: `IQ = Q0·V^(nQ-1)·Iramp`; still 0 with Q0=0 |
| Reactive washout | Not applied | Structural: `Wout_q = Kvq·Tvq·s/(Tvq·s+1)·Vmea`; inactive with Q0=0 |
| Cessation detection | Uses raw Vmea | Unchanged — still uses raw Vmea |
| Numerical behaviour | Unchanged | Lead-lag slightly smooths power transients at sag boundaries |

---

## Unchanged from Verified Model (not touched)

- All cessation parameters (vcX, tcX, tdelayX, vrX, trX, trampX)
- Fraction powers (P_A=3.2, P_B=3.8, P_C=3.6, P_D=10.4 kW)
- nP exponents (nPA=0, nPB=1, nPC=0, nPD=0)
- ipmax/ipmin (±2.0 pu)
- Washout on active side (Kvp=0.20, Tvp=0.02 s)
- Numerical filter (Tnum = 4·Ts)
- Simulation settings (Ts=1e-4, Tstop=20 s, sag scenario)
- All output variable names

---

## Status

> **This experimental model is NOT a validated model.**  
> The lead-lag is implemented with high confidence (text-derived, Appendix A parameters).  
> The reactive Iq loop structure is present but numerically inactive (Q0=0).  
> Both additions are consistent with the text description but cannot be verified against Figure 2/3 imagery.  
> Do not promote this to a verified or production model without reviewing the actual figures.
