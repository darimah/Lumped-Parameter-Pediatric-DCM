function results = fit_patient_bozkurt2022_refined(patient_id, options)
if nargin < 1
    patient_id = 1;
end
if nargin < 2
    options = struct();
end

if ~isfield(options, 'x_default_pct'), options.x_default_pct = 0.15; end
if ~isfield(options, 'k_default_pct'), options.k_default_pct = 0.10; end
if ~isfield(options, 'x_percent_map'), options.x_percent_map = struct(); end
if ~isfield(options, 'k_percent_map'), options.k_percent_map = struct(); end
if ~isfield(options, 'n_steps_stage1'), options.n_steps_stage1 = 10; end
if ~isfield(options, 'n_rounds_stage1'), options.n_rounds_stage1 = 12; end
if ~isfield(options, 'n_steps_stage2'), options.n_steps_stage2 = 10; end
if ~isfield(options, 'n_rounds_stage2'), options.n_rounds_stage2 = 10; end
if ~isfield(options, 'n_steps_stage1_refined'), options.n_steps_stage1_refined = 10; end
if ~isfield(options, 'n_rounds_stage1_refined'), options.n_rounds_stage1_refined = 10; end
if ~isfield(options, 'n_steps_stage2_refined'), options.n_steps_stage2_refined = 10; end
if ~isfield(options, 'n_rounds_stage2_refined'), options.n_rounds_stage2_refined = 8; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end

clinical = get_clinical_patient(patient_id);
params0 = default_parameters(clinical.model_id);
[bounds_x, bounds_k] = get_parameter_bounds(clinical.model_id);

x_names = fieldnames(bounds_x);
k_names = fieldnames(bounds_k);

disp('=== PASS 1: original bounds ===');
disp('Stage 1: fit MAP and CO');
pass1_stage1 = direct_search_bozkurt(clinical, params0, bounds_x, @objective_map_co, ...
    x_names, options.n_steps_stage1, options.n_rounds_stage1);

disp('Stage 2: fit Klv and Krv');
pass1_stage2 = direct_search_bozkurt(clinical, pass1_stage1.best_params, bounds_k, @objective_diameter, ...
    k_names, options.n_steps_stage2, options.n_rounds_stage2);

sim1 = integrate_system(clinical, pass1_stage2.best_params);
metrics1 = compute_clinical_indices(sim1);
comparison1 = compare_model_vs_clinical(metrics1, clinical);

refined_bounds_x = refine_bounds_around_best(pass1_stage2.best_params, bounds_x, ...
    options.x_default_pct, options.x_percent_map);
refined_bounds_k = refine_bounds_around_best(pass1_stage2.best_params, bounds_k, ...
    options.k_default_pct, options.k_percent_map);

disp('=== PASS 2: refined bounds around best solution ===');
disp('Stage 1: refined fit MAP and CO');
pass2_stage1 = direct_search_bozkurt(clinical, pass1_stage2.best_params, refined_bounds_x, @objective_map_co, ...
    x_names, options.n_steps_stage1_refined, options.n_rounds_stage1_refined);

disp('Stage 2: refined fit Klv and Krv');
pass2_stage2 = direct_search_bozkurt(clinical, pass2_stage1.best_params, refined_bounds_k, @objective_diameter, ...
    k_names, options.n_steps_stage2_refined, options.n_rounds_stage2_refined);

sim2 = integrate_system(clinical, pass2_stage2.best_params);
metrics2 = compute_clinical_indices(sim2);
comparison2 = compare_model_vs_clinical(metrics2, clinical);

if options.make_plot
    plot_hemodynamics(sim2, metrics2);
end

results = struct();
results.clinical = clinical;

results.pass1 = struct();
results.pass1.stage1 = pass1_stage1;
results.pass1.stage2 = pass1_stage2;
results.pass1.metrics = metrics1;
results.pass1.comparison = comparison1;
results.pass1.bounds_x = bounds_x;
results.pass1.bounds_k = bounds_k;

results.pass2 = struct();
results.pass2.stage1 = pass2_stage1;
results.pass2.stage2 = pass2_stage2;
results.pass2.metrics = metrics2;
results.pass2.comparison = comparison2;
results.pass2.bounds_x = refined_bounds_x;
results.pass2.bounds_k = refined_bounds_k;

results.final = struct();
results.final.params = pass2_stage2.best_params;
results.final.sim = sim2;
results.final.metrics = metrics2;
results.final.comparison = comparison2;
end
