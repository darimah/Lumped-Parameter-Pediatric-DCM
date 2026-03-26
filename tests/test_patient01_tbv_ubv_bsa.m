clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical = bozkurt2022_patient01_clinical();

% Replace these with the real patient values later.
clinical = add_tbv_ubv_to_clinical(clinical, 1.10, 'M', 0.70);

fprintf('TBV = %.2f mL\n', clinical.TBV_ml);
fprintf('UBV = %.2f mL\n', clinical.UBV_ml);
fprintf('SBV = %.2f mL\n', clinical.SBV_ml);

opts = struct();
opts.x_default_pct = 0.15;
opts.k_default_pct = 0.10;
opts.ps_use_parallel = false;
opts.ps_mesh_tolerance = 1e-4;
opts.ps_step_tolerance = 1e-6;
opts.ps_function_tolerance = 1e-6;
opts.ps_max_iterations = 60;
opts.ps_display = 'iter';
opts.make_plot = true;

opts.solver_options = struct();
opts.solver_options.tbv_init_settings = struct();
opts.solver_options.tbv_init_settings.frac_sven = 0.45;
opts.solver_options.tbv_init_settings.frac_pven = 0.18;
opts.solver_options.tbv_init_settings.frac_atria = 0.07;
opts.solver_options.tbv_init_settings.frac_vent  = 0.15;
opts.solver_options.tbv_init_settings.frac_art   = 0.15;

results = fit_patient_patternsearch_refined_tbv(clinical, opts);

disp('--- TBV/UBV relative errors ---');
disp(results.comparison.relerr);

save(fullfile(project_root, 'results', 'patient01_tbv_ubv_bsa.mat'), 'results');
