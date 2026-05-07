clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical_base = bozkurt2022_patient01_clinical();
BSA_value = 1.10;   % replace with true value later
sex_char = 'M';     % replace with true value later

ubv_list = [0.60, 0.65, 0.70];
all_results = struct([]);

for i = 1:numel(ubv_list)
    alpha = ubv_list(i);
    clinical = add_tbv_ubv_to_clinical(clinical_base, BSA_value, sex_char, alpha);

    fprintf('\n=== V3 run | UBV fraction = %.2f ===\n', alpha);
    fprintf('TBV = %.2f mL | UBV = %.2f mL | SBV = %.2f mL\n', clinical.TBV_ml, clinical.UBV_ml, clinical.SBV_ml);

    opts = struct();
    opts.x_default_pct = 0.15;
    opts.ps_use_parallel = false;
    opts.ps_mesh_tolerance = 1e-4;
    opts.ps_step_tolerance = 1e-6;
    opts.ps_function_tolerance = 1e-6;
    opts.ps_max_iterations = 40;
    opts.ps_display = 'iter';
    opts.make_plot = true;

    opts.solver_options = struct();
    opts.solver_options.init_v3_settings = struct();
    opts.solver_options.init_v3_settings.vs_stressed_extra = 0.18;
    opts.solver_options.init_v3_settings.vp_stressed_extra = 0.08;

    opts.x_percent_map = struct();
    opts.x_percent_map.Ees_rv = 0.20;
    opts.x_percent_map.V0_rv  = 0.20;
    opts.x_percent_map.Rpo    = 0.25;
    opts.x_percent_map.Cpo    = 0.25;
    opts.x_percent_map.Rap    = 0.25;
    opts.x_percent_map.Cap    = 0.25;
    opts.x_percent_map.Rvp    = 0.20;
    opts.x_percent_map.Cvp    = 0.20;
    opts.x_percent_map.ubv_sys_fraction = 0.10;

    results = fit_patient_patternsearch_v3(clinical, opts);
    disp(results.comparison.relerr);
    all_results(i).alpha = alpha;
    all_results(i).results = results;
end

save(fullfile(project_root, 'results', 'patient01_v3_ubv_range.mat'), 'all_results');
