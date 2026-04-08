clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

patient_id = 1;

opts = struct();
opts.run_warm_start = true;
opts.ps_use_parallel = false;
opts.ps_mesh_tolerance = 1e-4;
opts.ps_step_tolerance = 1e-6;
opts.ps_function_tolerance = 1e-6;
opts.ps_max_iterations_stage1 = 40;
opts.ps_display = 'iter';
opts.make_plot = true;

results = fit_patient_patternsearch_v2_final(patient_id, opts);

disp('--- BEFORE final tuning (best v2 warm start) ---');
disp(results.before.comparison.relerr);

disp('--- FINAL result (Stage 1 only) ---');
disp(results.final.comparison.relerr);

disp(results.final.severity.summary);

save(fullfile(project_root, 'results', 'patient01_v2_final_stage1.mat'), 'results');