% extract_epri_pdf_model_notes.m
% Attempt to locate and summarise the EPRI EVCharger PDF.
% If not found, records assumptions to docs folder.

if ~exist('project_root','var')
    run(fullfile(fileparts(mfilename('fullpath')), 'epri_ev_params_init.m'));
end

pdf_name = 'EVCharger_Model_Specifications_2023-Dana_Robson.pdf';
hits = dir(fullfile('D:\AI2SIM','**',pdf_name));

docs_dir = fullfile(project_root,'docs');

if ~isempty(hits)
    pdf_path = fullfile(hits(1).folder, hits(1).name);
    fprintf('PDF found: %s\n', pdf_path);
    % Copy to docs folder for reference
    copyfile(pdf_path, fullfile(docs_dir, pdf_name));
    fprintf('  Copied to docs folder.\n');
    fprintf('  NOTE: If MATLAB Text Analytics Toolbox is available,\n');
    fprintf('        add extractFileText() call here to parse content.\n');
else
    fprintf('PDF not found on disk.\n');
    fprintf('  Using assumed parameter values documented in:\n');
    fprintf('  docs\\epri_model_interpretation.md\n');
end

% Write a brief notes file regardless
fid = fopen(fullfile(docs_dir,'pdf_extraction_log.txt'),'w');
fprintf(fid,'PDF search: %s\n', pdf_name);
if ~isempty(hits)
    fprintf(fid,'Status: FOUND at %s\n', pdf_path);
    fprintf(fid,'Action: Copied to docs folder.\n');
else
    fprintf(fid,'Status: NOT FOUND\n');
    fprintf(fid,'Action: All model parameters are ASSUMPTIONS.\n');
    fprintf(fid,'        See epri_model_interpretation.md for details.\n');
    fprintf(fid,'\nAssumed key parameters:\n');
    fprintf(fid,'  Tv (voltage filter) = %.3f s\n', Tv);
    fprintf(fid,'  UV threshold (A,B,C) = %.2f pu\n', UV_A);
    fprintf(fid,'  Cessation hold-off A/B/C = %.2f / %.2f / %.2f s\n', ...
        cessation_time_A, cessation_time_B, cessation_time_C);
    fprintf(fid,'  Ramp time A/B/C = %.2f / %.2f / %.2f s\n', ...
        ramp_time_A, ramp_time_B, ramp_time_C);
end
fclose(fid);
fprintf('extract_epri_pdf_model_notes: done.\n');
