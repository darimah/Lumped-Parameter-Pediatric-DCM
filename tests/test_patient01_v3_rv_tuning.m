clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical = bozkurt2022_patient01_clinical();

% Replace with true patient values later
BSA_value = 1.10;
sex_char = 'M';
UBV_fraction = 0.65;

clinical = add_tbv_ubv_to_clinical(clinical, BSA_value, sex_char, UBV_fraction);

fprintf('Running v3 RV-focused tuning...\n');
fprintf('TBV = %.2f mL\n', clinical.TBV_ml);
fprintf('UBV = %.2f mL\n', clinical.UBV_ml);
fprintf('SBV = %.2f mL\n', clinical.SBV_ml);

opts = struct();
opts.ps_use_parallel = false;
opts.ps_mesh_tolerance = 1e-4;
opts.ps_step_tolerance = 1e-6;
opts.ps_function_tolerance = 1e-6;
opts.ps_max_iterations_stage1 = 40;
opts.ps_max_iterations_stage2 = 30;
opts.ps_display = 'iter';
opts.make_plot = true;

opts.solver_options = struct();
opts.solver_options.init_v3_settings = struct();
opts.solver_options.init_v3_settings.vs_stressed_extra = 0.18;
opts.solver_options.init_v3_settings.vp_stressed_extra = 0.08;

results = fit_patient_patternsearch_v3_rv_tuning(clinical, opts);

disp('--- BEFORE tuning ---');
disp(results.before.comparison.relerr);

disp('--- AFTER stage 1 (RV/pulmonary filling) ---');
disp(results.stage1.comparison.relerr);

disp('--- AFTER stage 2 (Krv) ---');
disp(results.stage2.comparison.relerr);

save(fullfile(project_root, 'results', 'patient01_v3_rv_tuning.mat'), 'results');
