clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

opts = struct();
opts.run_direct_first = true;
opts.x_default_pct = 0.15;
opts.k_default_pct = 0.10;

opts.x_percent_map = struct();
opts.x_percent_map.Ees_rv = 0.20;
opts.x_percent_map.V0_rv  = 0.20;
opts.x_percent_map.Rpo    = 0.25;
opts.x_percent_map.Cpo    = 0.25;
opts.x_percent_map.Rap    = 0.25;
opts.x_percent_map.Cap    = 0.25;
opts.x_percent_map.Rvp    = 0.20;
opts.x_percent_map.Cvp    = 0.20;

opts.k_percent_map = struct();
opts.k_percent_map.Krv = 0.20;
opts.k_percent_map.Klv = 0.10;

opts.ps_use_parallel = false;
opts.ps_mesh_tolerance = 1e-4;
opts.ps_step_tolerance = 1e-6;
opts.ps_function_tolerance = 1e-6;
opts.ps_max_iterations = 80;
opts.ps_display = 'iter';
opts.make_plot = true;

results = fit_patient_patternsearch_refined(1, opts);

disp('--- Patternsearch relative errors ---');
disp(results.comparison.relerr);

save(fullfile(project_root, 'results', 'patient01_patternsearch.mat'), 'results');
