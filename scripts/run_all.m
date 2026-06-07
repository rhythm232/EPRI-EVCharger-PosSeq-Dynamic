% run_all.m – EPRI EVCharger positive-sequence dynamic model.
project_root = 'D:\AI2SIM\EV_AI\EPRI_EVCharger_PosSeq_Dynamic_R2024b';
cd(project_root);
run(fullfile(project_root,'scripts','epri_ev_params_init.m'));
run(fullfile(project_root,'scripts','extract_epri_pdf_model_notes.m'));
run(fullfile(project_root,'scripts','build_epri_evcharger_posseq_model.m'));
run(fullfile(project_root,'scripts','run_epri_evcharger_simulation.m'));
run(fullfile(project_root,'scripts','analyze_epri_evcharger_results.m'));
fprintf('\nrun_all: COMPLETE\n');
