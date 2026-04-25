function results = fit_patient_patternsearch_v2_final(patient_id, options)
% FINAL two-stage tuning adapted to current protocol
%
% Stage 0: optional warm start using fit_patient_patternsearch_refined
%          only when RV diameter data exist
% Stage 1: optimise hemodynamic parameter vector x
% Stage 2: tune Klv only using LV diameter targets
%
% Final result = Stage 2

if nargin < 1
    patient_id = 1;
end
if nargin < 2
    options = struct();
end

if ~isfield(options, 'run_warm_start'), options.run_warm_start = true; end
if ~isfield(options, 'ps_use_parallel'), options.ps_use_parallel = false; end
if ~isfield(options, 'ps_mesh_tolerance'), options.ps_mesh_tolerance = 1e-4; end
if ~isfield(options, 'ps_step_tolerance'), options.ps_step_tolerance = 1e-6; end
if ~isfield(options, 'ps_function_tolerance'), options.ps_function_tolerance = 1e-6; end
if ~isfield(options, 'ps_max_iterations_stage1'), options.ps_max_iterations_stage1 = 80; end
if ~isfield(options, 'ps_max_iterations_stage2'), options.ps_max_iterations_stage2 = 60; end
if ~isfield(options, 'ps_display'), options.ps_display = 'iter'; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end

clinical = get_clinical_patient(patient_id);

% -------------------------------
% Stage 0: initial parameter set
% -------------------------------
if options.run_warm_start && isfield(clinical,'D_rv_ed') && isfield(clinical,'D_rv_es')
    warm = fit_patient_patternsearch_refined(patient_id);
    params0 = warm.params;
    before_metrics = warm.metrics;
    before_comparison = warm.comparison;
else
    warm = [];
    params0 = default_parameters(clinical.model_id);
    sim0 = integrate_system(clinical, params0);
    before_metrics = compute_clinical_indices(sim0);
    before_comparison = compare_model_vs_clinical(before_metrics, clinical);
end

% -------------------------------
% Stage 1: optimise x only
% -------------------------------
stage1_names = { ...
    'Ees_lv','Ees_rv','V0_lv','V0_rv','Alv','Arv','Blv','Brv', ...
    'Rao','Cao','Ras','Cas','Rvs','Cvs', ...
    'Rpo','Cpo','Rap','Cap','Rvp','Cvp','Vblood'};

[bounds_x, ~] = get_parameter_bounds(clinical.model_id);

bounds_stage1 = struct();
for i = 1:numel(stage1_names)
    nm = stage1_names{i};
    bounds_stage1.(nm) = bounds_x.(nm);
end

[x0_stage1, ~] = struct_to_vector(params0, stage1_names);
[lb1, ub1, stage1_names] = bounds_struct_to_vectors(bounds_stage1, stage1_names);

obj1 = @(x) objective_full_hemodynamics_vector(x, params0, stage1_names, clinical);

ps_opts1 = optimoptions('patternsearch', ...
    'Display', options.ps_display, ...
    'UseCompletePoll', true, ...
    'UseCompleteSearch', false, ...
    'UseParallel', options.ps_use_parallel, ...
    'MeshTolerance', options.ps_mesh_tolerance, ...
    'StepTolerance', options.ps_step_tolerance, ...
    'FunctionTolerance', options.ps_function_tolerance, ...
    'MaxIterations', options.ps_max_iterations_stage1);

[xbest1, fval1, exitflag1, output1] = patternsearch(obj1, x0_stage1, [], [], [], [], lb1, ub1, [], ps_opts1);
params_stage1 = vector_to_struct(params0, stage1_names, xbest1);

sim1 = integrate_system(clinical, params_stage1);
metrics1 = compute_clinical_indices(sim1);
comparison1 = compare_model_vs_clinical(metrics1, clinical);
severity1 = classify_dcm_severity(metrics1);

% -------------------------------
% Stage 2: tune Klv only
% -------------------------------
stage2_names = {'Klv'};

[x0_stage2, ~] = struct_to_vector(params_stage1, stage2_names);

lb2 = max(0.5, 0.80 * params_stage1.Klv);
ub2 = 1.20 * params_stage1.Klv;

obj2 = @(x) objective_lv_diameter_only_vector(x, params_stage1, stage2_names, clinical);

ps_opts2 = optimoptions('patternsearch', ...
    'Display', options.ps_display, ...
    'UseCompletePoll', true, ...
    'UseCompleteSearch', false, ...
    'UseParallel', options.ps_use_parallel, ...
    'MeshTolerance', options.ps_mesh_tolerance, ...
    'StepTolerance', options.ps_step_tolerance, ...
    'FunctionTolerance', options.ps_function_tolerance, ...
    'MaxIterations', options.ps_max_iterations_stage2);

[xbest2, fval2, exitflag2, output2] = patternsearch(obj2, x0_stage2, [], [], [], [], lb2, ub2, [], ps_opts2);
params_stage2 = vector_to_struct(params_stage1, stage2_names, xbest2);

sim2 = integrate_system(clinical, params_stage2);
metrics2 = compute_clinical_indices(sim2);
comparison2 = compare_model_vs_clinical(metrics2, clinical);
severity2 = classify_dcm_severity(metrics2);

disp(severity2.summary);

if options.make_plot
    plot_hemodynamics(sim2, metrics2);
end

results = struct();
results.clinical = clinical;
results.warm = warm;

results.before = struct();
results.before.params = params0;
results.before.metrics = before_metrics;
results.before.comparison = before_comparison;

results.stage1 = struct();
results.stage1.params = params_stage1;
results.stage1.sim = sim1;
results.stage1.metrics = metrics1;
results.stage1.comparison = comparison1;
results.stage1.fval = fval1;
results.stage1.exitflag = exitflag1;
results.stage1.output = output1;
results.stage1.parameter_names = stage1_names;
results.stage1.bounds.lb = lb1;
results.stage1.bounds.ub = ub1;
results.stage1.severity = severity1;

results.stage2 = struct();
results.stage2.params = params_stage2;
results.stage2.sim = sim2;
results.stage2.metrics = metrics2;
results.stage2.comparison = comparison2;
results.stage2.fval = fval2;
results.stage2.exitflag = exitflag2;
results.stage2.output = output2;
results.stage2.parameter_names = stage2_names;
results.stage2.bounds.lb = lb2;
results.stage2.bounds.ub = ub2;
results.stage2.severity = severity2;

results.final = results.stage2;
end