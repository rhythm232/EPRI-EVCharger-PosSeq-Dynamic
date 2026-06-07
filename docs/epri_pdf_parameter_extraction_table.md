# EPRI EVCharger PDF — Parameter Extraction Table

**Source:** EVCharger_Model_Specifications_2023-Dana_Robson.pdf  
**Extraction date:** 2026-06-06  
**Extraction method:** PDFBox text extraction via MATLAB Java bridge  
**Status:** PDF successfully read. All Appendix A values extracted.

> **Values used are from Appendix A** (single-bus test record `epcmod … "EV_Chrg.p"`),
> which directly corresponds to the PDF Figs 5-10 simulation.
> Table 1 gives *suggested defaults* which differ in some cases.

---

## Parameter Table

| Parameter | PDF Description | Appendix A Value | Table 1 Default | Prev. Assumed | After Update | Source Location | Exact? |
|-----------|----------------|-----------------|-----------------|---------------|--------------|-----------------|--------|
| Tr | Voltage meas. filter (s) | 0.02 | 0.02 | 0.02 | 0.02 | Table 1, App A | **Exact** |
| Kvp | Active washout prop. gain | 0.20 | 0.20 | — (not impl.) | 0.20 | Table 1, App A | **Exact** |
| Tvp | Active washout time const. (s) | 0.02 | 0.02 | — | 0.02 | Table 1, App A | **Exact** |
| Kvq | Reactive washout prop. gain | 0.16 | 0.16 | — | 0.16 (noted) | Table 1, App A | **Exact** |
| Tvq | Reactive washout time const. (s) | 0.02 | 0.02 | — | 0.02 (noted) | Table 1, App A | **Exact** |
| Ta | Lead time constant (s) | 0.1 | 0.5 | — | 0.1 (noted) | App A | **Exact** |
| Tb | Lag time constant (s) | 0.2 | 0.1 | — | 0.2 (noted) | App A | **Exact** |
| kdroop | Freq. droop gain | 0 | 0 | — | 0 (disabled) | Table 1, App A | **Exact** |
| deadband | Freq. droop deadband | 0.017 | 999 | — | 0.017 (noted) | App A | **Exact** |
| FrA | Fraction A portion | 0.1524 | 0.2 | N/A | 3.2/21=0.1524 | App A | **Exact** |
| FrB | Fraction B portion | 0.1714 | 0.2 | N/A | 3.8/21=0.1810* | App A | *See note* |
| FrC | Fraction C portion | 0.1810 | 0.2 | N/A | 3.6/21=0.1714* | App A | *See note* |
| nPA | P exponent Fraction A | 0.0 | 0 | 0 (assumed) | 0.0 | App A | **Exact** |
| nPB | P exponent Fraction B | 1.0 | 0 | 0 (assumed) | **1.0** | App A | **Exact** |
| nPC | P exponent Fraction C | 0.0 | 0 | 0 (assumed) | 0.0 | App A | **Exact** |
| nPD | P exponent Fraction D | 0.0 | 0 | 0 (assumed) | 0.0 | App A | **Exact** |
| nQA..D | Q exponents | 0.0 all | 1 (default) | — | 0.0 (noted) | App A | **Exact** |
| vcA | UV cease thresh. A (pu) | 0.6 | 0.5 | 0.70 | **0.6** | App A | **Exact** |
| tcA | UV cease delay A (s) | 0.005 | 0.01 | 0.02 | **0.005** | App A | **Exact** |
| tdelayA | Cease post-detect delay A (s) | 0.005 | 0.0 | 0.0 | **0.005** | App A | **Exact** |
| vrA | Reconnect thresh. A (pu) | 0.6 | 0.6 | 0.90 | **0.6** | App A | **Exact** |
| trA | Reconnect delay A (s) | 8.0 | 0.05 | 0.30 | **8.0** | App A | **Exact** |
| trampA | Ramp time A (s) | 5.0 | 1.0 | 0.50 | **5.0** | App A | **Exact** |
| vcB | UV cease thresh. B (pu) | 0.7 | 0.5 | 0.70 | **0.7** | App A | **Exact** |
| tcB | UV cease delay B (s) | 0.12 | 0.01 | 0.08 | **0.12** | App A | **Exact** |
| tdelayB | Cease post-detect delay B (s) | 0.005 | 0.0 | 0.0 | **0.005** | App A | **Exact** |
| vrB | Reconnect thresh. B (pu) | 0.6 | 0.6 | 0.90 | **0.6** | App A | **Exact** |
| trB | Reconnect delay B (s) | 3.0 | 0.05 | 0.15 | **3.0** | App A | **Exact** |
| trampB | Ramp time B (s) | 3.0 | 1.0 | 0.70 | **3.0** | App A | **Exact** |
| vcC | UV cease thresh. C (pu) | 0.6 | 0.5 | 0.70 | **0.6** | App A | **Exact** |
| tcC | UV cease delay C (s) | 0.01 | 0.01 | 0.02 | **0.01** | App A | **Exact** |
| tdelayC | Cease post-detect delay C (s) | 0.005 | 0.0 | 0.0 | **0.005** | App A | **Exact** |
| vrC | Reconnect thresh. C (pu) | 0.6 | 0.6 | 0.90 | **0.6** | App A | **Exact** |
| trC | Reconnect delay C (s) | 1.0 | 0.05 | 0.50 | **1.0** | App A | **Exact** |
| trampC | Ramp time C (s) | 1.0 | 1.0 | 1.00 | **1.0** | App A | **Exact** |
| ipmax | Max active current (pu) | 2.0 | 1.0 | 1.0 | **2.0** | App A | **Exact** |
| ipmin | Min active current (pu) | -2.0 | 0 | 0 | **-2.0** | App A | **Exact** |
| iqmax | Max reactive current (pu) | 2.0 | 0.66 | 0.66 | 2.0 (noted) | App A | **Exact** |
| iqmin | Min reactive current (pu) | -2.0 | 0 | 0 | -2.0 (noted) | App A | **Exact** |
| Tnum | Numerical filter const. (s) | 4×Ts | N/A | — | 4×1e-4=4e-4 | PDF text | **Exact** |
| Tstop | Simulation stop time (s) | ≥15 s (see note) | N/A | 4.0 | **20.0** | PDF Figs 6-10 | Inferred |
| P_total | Total EV power | 21 kW | N/A | 21 kW | 21 kW | PDF p.1-9 | **Exact** |
| P_A | Fraction A power | 3.2 kW | N/A | 3.2 kW | 3.2 kW | PDF p.1-9 | **Exact** |
| P_B | Fraction B power | 3.8 kW | N/A | 3.8 kW | 3.8 kW | PDF p.1-9 | **Exact** |
| P_C | Fraction C power | 3.6 kW | N/A | 3.6 kW | 3.6 kW | PDF p.1-9 | **Exact** |
| P_D | Fraction D power | 10.4 kW | N/A | 10.4 kW | 10.4 kW | PDF p.1-9 | **Exact** |
| sag_depth | Voltage sag depth (pu) | 0.5 | N/A | 0.5 | 0.5 | PDF p.1-9 | **Exact** |
| sag_cycles | Sag duration (cycles) | 9 cycles | N/A | 9 | 9 | PDF p.1-9 | **Exact** |

*FrB/FrC note: The Appendix A record shows FrB=0.1714 (≈3.6 kW) and FrC=0.1810 (≈3.8 kW),
which is the reverse of the text statement "B=3.8 kW, C=3.6 kW". The cessation parameters for
Appendix FrB (nPB=1, EV-D constant-current behavior) correspond to our Fraction B (EV-D).
The Appendix FrC (nPC=0, EV-F cease behavior) corresponds to our Fraction C (EV-F).
The power swap appears to be a labeling inconsistency in the PDF Appendix. We use the text-
defined powers (B=3.8 kW, C=3.6 kW) with the behavior-matched cessation parameters.*

---

## Count of Extracted Parameters
- **Exact from Appendix A:** 35 parameters
- **Exact from Table 1 / text:** 7 parameters  
- **Inferred from figures (Tstop):** 1
- **Still assumed / not in PDF:** 0 critical parameters remain assumed

---

## Implementation Location

| Parameter group | Implementation file |
|-----------------|-------------------|
| All scalar parameters | `scripts/epri_ev_params_init.m` |
| Washout (Kvp, Tvp) | Inside each MATLAB Function block code |
| nP exponents | Inside each MATLAB Function block code |
| Cessation logic (vc, tc, vr, tr, tramp) | Inside each MATLAB Function block code |
| Numerical filter (Tnum) | Inside each MATLAB Function block code |
| ipmax/ipmin | Inside each MATLAB Function block code |
| Model rebuild | `scripts/build_epri_evcharger_posseq_model.m` |
| Calibrated model | `model/epri_evcharger_posseq_pdf_calibrated_r2024b.slx` |

---

## Critical Model Behavior Changes from PDF Calibration

| Change | Before | After | Impact |
|--------|--------|-------|--------|
| Fraction B nPB | 0 (const power) | **1 (const current)** | B power reduces during sag (P=P0·V) |
| Recovery thresh vrX | 0.90 pu | **0.6 pu** | Recovery timer starts earlier |
| trA reconnect delay | 0.30 s | **8.0 s** | A stays ceased much longer |
| trB reconnect delay | 0.15 s | **3.0 s** | B stays ceased longer |
| trampA ramp time | 0.50 s | **5.0 s** | A ramps slower |
| trampB ramp time | 0.70 s | **3.0 s** | B ramps similar speed |
| ipmax | 1.0 pu | **2.0 pu** | Constant power at V=0.5 allowed |
| Washout (Kvp·Tvp·s/(Tvp·s+1)) | Not impl. | **Implemented** | Spikes at fault boundaries (Fig. D) |
| Numerical filter 1/(Tnum·s+1) | Not impl. | **Implemented** | Smooths discrete steps |
| Tstop | 4.0 s | **20.0 s** | Full A recovery now visible |
