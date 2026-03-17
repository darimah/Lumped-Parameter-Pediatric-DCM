clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

opts = struct();
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

results = fit_patient_bozkurt2022_refined(1, opts);

disp('--- PASS 1 relative errors ---');
disp(results.pass1.comparison.relerr);

disp('--- PASS 2 relative errors ---');
disp(results.pass2.comparison.relerr);

save(fullfile(project_root, 'results', 'patient01_refined_bounds.mat'), 'results');
