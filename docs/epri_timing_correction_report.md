# EPRI EVCharger — Timing Correction Report

**Date:** 2026-06-06  
**Project:** EPRI_EVCharger_PosSeq_Dynamic_R2024b

---

## Summary

The EPRI single-bus test uses a **60 Hz system** with the voltage sag applied at **t = 4.5 s**
for **9 cycles = 0.15 s**. The prior PDF-calibrated model used 50 Hz and sag at t = 1.0 s.
This report documents the correction and confirms the verified baseline was not overwritten.

---

## Parameters Changed

| Parameter | Old value | New value | Reason |
|-----------|-----------|-----------|--------|
| `f_nom` | 50 Hz | **60 Hz** | EPRI single-bus test system is 60 Hz |
| `sag_start` | 1.0 s | **4.5 s** | EPRI Fig. 5: sag begins at 4.5 s |
| `sag_duration` | 9/50 = **0.18 s** | 9/60 = **0.15 s** | 9 cycles at 60 Hz |
| `sag_end` | 1.18 s | **4.65 s** | sag_start + sag_duration |
| `t_rec_start_A` | 1.18 + 8.0 = 9.18 s | **4.65 + 8.0 = 12.65 s** | derived |
| `t_rec_done_A` | 9.18 + 5.0 = 14.18 s | **12.65 + 5.0 = 17.65 s** | derived |
| `t_rec_start_B` | 1.18 + 3.0 = 4.18 s | **4.65 + 3.0 = 7.65 s** | derived |
| `t_rec_done_B` | 4.18 + 3.0 = 7.18 s | **7.65 + 3.0 = 10.65 s** | derived |
| `t_rec_start_C` | 1.18 + 1.0 = 2.18 s | **4.65 + 1.0 = 5.65 s** | derived |
| `t_rec_done_C` | 2.18 + 1.0 = 3.18 s | **5.65 + 1.0 = 6.65 s** | derived |
| `Tstop` | 20 s (unchanged) | 20 s | covers t_rec_done_A = 17.65 s |

---

## Sag Duration: Old vs New

| | Old (incorrect) | New (correct) |
|---|---|---|
| System frequency | 50 Hz | **60 Hz** |
| Sag cycles | 9 | 9 |
| Sag duration | **0.18 s (180 ms)** | **0.15 s (150 ms)** |
| Sag start | 1.0 s | **4.5 s** |
| Sag end | 1.18 s | **4.65 s** |

---

## Figure Label Corrections

| Figure file | Old EPRI label | Corrected EPRI label |
|-------------|---------------|---------------------|
| `epri_voltage_sag.png` | "180 ms sag" | **"150 ms sag / 9 cycles at 60 Hz"** |
| `epri_fraction_A_response.png` | ≈ EPRI Fig. 7 | **EPRI Fig. 6 (EV-B)** |
| `epri_fraction_B_response.png` | ≈ EPRI Fig. 8 | **EPRI Fig. 7 (EV-D)** |
| `epri_fraction_C_response.png` | ≈ EPRI Fig. 9 | **EPRI Fig. 8 (EV-F)** |
| `epri_fraction_D_response.png` | ≈ EPRI Fig. 10 | **EPRI Fig. 9 (EV-A/C/E)** |
| `epri_cumulative_response.png` | ≈ EPRI Fig. 6 | **EPRI Fig. 10** |

---

## Model File Status

| File | Action | Exists? |
|------|--------|---------|
| `model\epri_evcharger_posseq_pdf_calibrated_verified_r2024b.slx` | **NOT modified — verified baseline preserved** | ✓ |
| `model\epri_evcharger_posseq_pdf_calibrated_r2024b.slx` | Rebuilt with corrected timing | ✓ |
| `model\epri_evcharger_posseq_epri_timing_corrected_r2024b.slx` | **New timing-corrected copy** | ✓ |

---

## Unchanged Parameters (Appendix A values retained)

All cessation / reconnect / ramp parameters are unchanged — these come directly from
the EPRI Appendix A single-bus record and remain correct:

| Fraction | vc | tc | tdelay | vr | tr | tramp |
|----------|----|----|--------|----|----|-------|
| A (EV-B) | 0.6 | 0.005 | 0.005 | 0.6 | **8.0** | **5.0** |
| B (EV-D) | 0.7 | 0.12 | 0.005 | 0.6 | **3.0** | **3.0** |
| C (EV-F) | 0.6 | 0.01 | 0.005 | 0.6 | **1.0** | **1.0** |

---

## Final Manual Validation Values

Obtained from `run_epri_evcharger_simulation.m` after timing correction:

| Check | Expected | Measured | Result |
|-------|----------|----------|--------|
| A. `max(tout)` | 20 s | **20.0 s** | PASS |
| B. `Vt_pu` min/max | 0.5 / 1.0 | **0.5 / 1.0** | PASS |
| C. Sag window | 4.50–4.65 s | **4.50–4.650 s** | PASS |
| D. Pre-sag `Pout` | ≈ 21 kW | **21.0000 kW** | PASS |
| E. Min `Pout` | ≈ 10.4 kW (Fraction D) | **10.3946 kW** | PASS |
| F. `PfrA` at t=13 s | ≈ 0 (just started ramping) | **0.2210 kW** | PASS |
| G. `PfrA` at t=17.5 s | ≈ 3.1 kW (≈97% recovered) | **3.1010 kW** | PASS |
| H. B, C recover before A | C: 6.65 s, B: 10.65 s | C < B < A confirmed | PASS |
| I. `PfrD` ≈ constant | ≈ 10.4 kW throughout | **10.4 kW** | PASS |
| J. All figures regenerated | 9 figures | 9 figures confirmed | PASS |

---

## Qualitative Match to EPRI PDF Figures

| PDF Figure | Description | Reproduced? |
|------------|-------------|-------------|
| Fig. 5 | Terminal voltage sag at 4.5 s, 0.5 pu, 0.15 s | ✓ Exact timing |
| Fig. 6 | Fraction A (EV-B): ceases, zero until ~13 s, ramp by ~17.5 s | ✓ 0.22 kW at 13 s, 3.10 kW at 17.5 s |
| Fig. 7 | Fraction B (EV-D): proportional reduction, cease, recovery by ~10.65 s | ✓ |
| Fig. 8 | Fraction C (EV-F): cease, faster recovery by ~6.65 s | ✓ |
| Fig. 9 | Fraction D (EV-A/C/E): constant power ≈ 10.4 kW | ✓ |
| Fig. 10 | Cumulative: drops to ≈10.4 kW, staged recovery C→B→A | ✓ |

---

## Classification

> **PDF-calibrated qualitative reproduction with corrected EPRI timing.**  
> All Appendix A parameters are exact. Timing now matches the EPRI single-bus test  
> (60 Hz, sag at t = 4.5 s, 9 cycles = 0.15 s).  
> Lead-lag compensator and reactive Iq loop are documented but not fully wired.  
> This is **not** a claim of exact official EPRI/PSLF implementation.
