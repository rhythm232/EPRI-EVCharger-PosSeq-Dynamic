% run_epri_evcharger_simulation.m
% EPRI timing-corrected: sag at 4.5 s, 9 cycles @ 60 Hz = 0.15 s

if ~exist('P_A_kW','var')
    run(fullfile(fileparts(mfilename('fullpath')), 'epri_ev_params_init.m'));
end

mdlName = 'epri_evcharger_posseq_dynamic_r2024b';
mdlPath = fullfile(project_root,'model',[mdlName '.slx']);

if ~bdIsLoaded(mdlName), load_system(mdlPath); end

fprintf('Running EPRI simulation: Tstop=%.1f s, Ts=%.2e s ...\n', Tstop, Ts);
fprintf('  Sag: %.2f pu  t=%.2f-%.3f s  (%.0f ms / 9 cycles @ %g Hz)\n', ...
    sag_depth, sag_start, sag_end, sag_duration*1000, f_nom);
simOut = sim(mdlName,'StopTime',num2str(Tstop));

tout = simOut.tout;

% Extract — storage is [1 x 1 x Nt] -> squeeze -> [Nt x 1]
get1 = @(nm) squeeze(simOut.(nm));

Vt_pu       = get1('Vt_pu');
Vmea        = get1('Vmea');
Pout        = get1('Pout');
Qout        = get1('Qout');
PfrA        = get1('PfrA');   QfrA = get1('QfrA');
PfrB        = get1('PfrB');   QfrB = get1('QfrB');
PfrC        = get1('PfrC');   QfrC = get1('QfrC');
PfrD        = get1('PfrD');   QfrD = get1('QfrD');
IPfA        = get1('IPfA');   IQfA = get1('IQfA');
IPfB        = get1('IPfB');   IQfB = get1('IQfB');
IPfC        = get1('IPfC');   IQfC = get1('IQfC');
IPfD        = get1('IPfD');   IQfD = get1('IQfD');
FRA         = get1('FRA');
FRB         = get1('FRB');
FRC         = get1('FRC');
cessation_A = get1('cessation_A');
cessation_B = get1('cessation_B');
cessation_C = get1('cessation_C');

save(fullfile(project_root,'data','epri_simulation_results.mat'), ...
    'tout','Vt_pu','Vmea','Pout','Qout', ...
    'PfrA','QfrA','PfrB','QfrB','PfrC','QfrC','PfrD','QfrD', ...
    'IPfA','IQfA','IPfB','IQfB','IPfC','IQfC','IPfD','IQfD', ...
    'FRA','FRB','FRC','cessation_A','cessation_B','cessation_C');

fprintf('Simulation complete.  Nt = %d\n', numel(tout));
fprintf('  max(tout)         = %.1f s\n', max(tout));
fprintf('  Vt_pu min/max     = %.1f / %.1f\n', min(Vt_pu), max(Vt_pu));
fprintf('  Sag window        = %.2f - %.3f s\n', sag_start, sag_end);
fprintf('  Pre-sag Pout      = %.4f kW\n', mean(Pout(tout < sag_start-0.1)));
fprintf('  During sag Pout   = %.4f kW (mean)\n', ...
    mean(Pout(tout>=sag_start & tout<sag_end)));
fprintf('  Min Pout          = %.4f kW\n', min(Pout(tout > sag_start)));
fprintf('  PfrA at t=13 s    = %.4f kW\n', PfrA(find(tout>=13.0,1)));
fprintf('  PfrA at t=17.5 s  = %.4f kW\n', PfrA(find(tout>=17.5,1)));
fprintf('  Final Pout        = %.4f kW\n', Pout(end));
