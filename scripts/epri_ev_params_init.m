% epri_ev_params_init.m
% EPRI EVCharger positive-sequence dynamic model parameters.
% PDF-CALIBRATED version — all values from Appendix A of
%   EVCharger_Model_Specifications_2023-Dana_Robson.pdf
% unless otherwise noted.

project_root = 'D:\AI2SIM\EV_AI\EPRI_EVCharger_PosSeq_Dynamic_R2024b';

%% Simulation
f_nom  = 60;       % EPRI single-bus test: 60 Hz (corrected from prior 50 Hz)
Tstop  = 20.0;     % Fraction A recovery: 4.65+8+5 = 17.65 s → needs Tstop >= 18 s
Ts     = 1e-4;

%% Voltage sag scenario  [PDF p.1-9 / Fig. 5]
% EPRI single-bus test: sag at 4.5 s, 9 cycles @ 60 Hz = 0.15 s
sag_start    = 4.5;
sag_duration = 9 / f_nom;   % 9 cycles @ 60 Hz = 0.150 s
sag_end      = sag_start + sag_duration;   % = 4.65 s
sag_depth    = 0.5;

%% Voltage measurement filter  [PDF Table 1, App A]
Tr = 0.02;    % Voltage measurement time constant (s)

%% Active power washout  [PDF Table 1, App A]
Kvp = 0.20;   % Washout proportional gain
Tvp = 0.02;   % Washout time constant (s)

%% Reactive power washout  [PDF Table 1, App A]
Kvq = 0.16;
Tvq = 0.02;

%% Lead-lag compensator  [PDF Appendix A — overrides Table 1 defaults]
Ta = 0.1;    % Lead time constant (App A); Table 1 default is 0.5
Tb = 0.2;    % Lag time constant  (App A); Table 1 default is 0.1

%% Frequency droop (disabled)  [PDF App A]
kdroop   = 0;
deadband = 0.017;

%% Fraction powers  [PDF p.1-9 explicit statement]
P_total_kW = 21.0;
P_A_kW     = 3.2;    % EV-B type
P_B_kW     = 3.8;    % EV-D type
P_C_kW     = 3.6;    % EV-F type
P_D_kW     = 10.4;   % EV-A/C/E type

%% Fraction fractions  [PDF App A — note: FrB/FrC labels may be swapped vs text]
FrA = P_A_kW / P_total_kW;   % 0.1524
FrB = P_B_kW / P_total_kW;   % 0.1810 (text: B=3.8 kW; App A FrB=0.1714 may label C)
FrC = P_C_kW / P_total_kW;   % 0.1714

%% Voltage exponents (nP) for each fraction  [PDF App A]
nPA = 0;   % constant power
nPB = 1;   % constant current (P = P0 * V^1) — KEY CHANGE from prior model
nPC = 0;   % constant power
nPD = 0;   % constant power

%% Current limits  [PDF App A — note: ±2.0, not Table 1 default of 0/1.0]
ipmax =  2.0;
ipmin = -2.0;
iqmax =  2.0;    % (reactive loop not yet implemented)
iqmin = -2.0;

%% Numerical stability filter  [PDF text: Tnum = 4*delt]
Tnum = 4 * Ts;   % = 4e-4 s

%% ---- Fraction A  (EV-B type)  [PDF App A] ----
vcA      = 0.6;    % UV cease threshold (pu)   — was 0.70 assumed
tcA      = 0.005;  % UV detection delay (s)    — was 0.02 assumed
tdelayA  = 0.005;  % Cease post-detect delay (s) — was 0.0 assumed
vrA      = 0.6;    % Reconnect voltage threshold (pu) — was 0.90 assumed
trA      = 8.0;    % Reconnect time delay (s)  — was 0.30 assumed
trampA   = 5.0;    % Ramp time (s)             — was 0.50 assumed

%% ---- Fraction B  (EV-D type)  [PDF App A FrB record] ----
vcB      = 0.7;    % UV cease threshold (pu)   — was 0.70 assumed (unchanged)
tcB      = 0.12;   % UV detection delay (s)    — was 0.08 assumed
tdelayB  = 0.005;  % Cease post-detect delay   — was 0.0 assumed
vrB      = 0.6;    % Reconnect threshold (pu)  — was 0.90 assumed
trB      = 3.0;    % Reconnect delay (s)       — was 0.15 assumed
trampB   = 3.0;    % Ramp time (s)             — was 0.70 assumed

%% ---- Fraction C  (EV-F type)  [PDF App A FrC record] ----
vcC      = 0.6;    % UV cease threshold (pu)   — was 0.70 assumed
tcC      = 0.01;   % UV detection delay (s)    — was 0.02 assumed
tdelayC  = 0.005;  % Cease post-detect delay   — was 0.0 assumed
vrC      = 0.6;    % Reconnect threshold (pu)  — was 0.90 assumed
trC      = 1.0;    % Reconnect delay (s)       — was 0.50 assumed
trampC   = 1.0;    % Ramp time (s)             — was 1.00 assumed (unchanged)

%% Expected recovery times — EPRI timing: sag_start=4.5 s, sag_end=4.65 s
% These match the PDF Fig. 6-10 description: A zero until ~13 s, full by ~17.5 s
t_rec_start_C = sag_end + trC;              % 4.65+1.0  = 5.65 s
t_rec_done_C  = t_rec_start_C + trampC;     % 5.65+1.0  = 6.65 s
t_rec_start_B = sag_end + trB;              % 4.65+3.0  = 7.65 s
t_rec_done_B  = t_rec_start_B + trampB;     % 7.65+3.0  = 10.65 s
t_rec_start_A = sag_end + trA;              % 4.65+8.0  = 12.65 s  ≈ PDF "~13 s"
t_rec_done_A  = t_rec_start_A + trampA;     % 12.65+5.0 = 17.65 s  ≈ PDF "~17.5 s"

%% Save and assign to base workspace
% Clear any non-serialisable Java objects before saving
% Clear non-serialisable objects before saving
cv_list = {'doc','stripper','txt','rt','em'};
for kc = 1:numel(cv_list)
    if exist(cv_list{kc},'var'), eval(['clear ' cv_list{kc}]); end
end
clear cv_list kc
% Save only numeric/string variables explicitly
save(fullfile(project_root,'data','epri_ev_params.mat'), ...
    'project_root','f_nom','Tstop','Ts', ...
    'sag_start','sag_duration','sag_end','sag_depth', ...
    'Tr','Kvp','Tvp','Kvq','Tvq','Ta','Tb','kdroop','deadband', ...
    'P_total_kW','P_A_kW','P_B_kW','P_C_kW','P_D_kW', ...
    'FrA','FrB','FrC','nPA','nPB','nPC','nPD', ...
    'ipmax','ipmin','iqmax','iqmin','Tnum', ...
    'vcA','tcA','tdelayA','vrA','trA','trampA', ...
    'vcB','tcB','tdelayB','vrB','trB','trampB', ...
    'vcC','tcC','tdelayC','vrC','trC','trampC', ...
    't_rec_start_C','t_rec_done_C','t_rec_start_B','t_rec_done_B', ...
    't_rec_start_A','t_rec_done_A');
varnames = who;
for k = 1:numel(varnames)
    assignin('base', varnames{k}, eval(varnames{k}));
end

fprintf('epri_ev_params_init (PDF-calibrated) done.\n');
fprintf('  Sag: %.1f pu, t=%.2f-%.3f s\n', sag_depth, sag_start, sag_end);
fprintf('  Tstop = %.0f s  (extended for trA=%g s recovery)\n', Tstop, trA);
fprintf('  nPB = %d (constant current for Fraction B — PDF calibrated)\n', nPB);
fprintf('  vrA/B/C = %.1f pu (was 0.90 assumed)\n', vrA);
fprintf('  Expected full recoveries: C=%.2fs, B=%.2fs, A=%.2fs\n', ...
    t_rec_done_C, t_rec_done_B, t_rec_done_A);
