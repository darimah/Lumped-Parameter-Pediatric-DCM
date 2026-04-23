function results = fit_patient_patternsearch_v2_final(patient_id, options)
% FINAL one-stage tuning on top of the best v2 workflow.
%
% Stage 0: warm start using fit_patient_patternsearch_refined
% Stage 1: tune RV/pulmonary filling only
%
% Final result = Stage 1

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
if ~isfield(options, 'ps_max_iterations_stage1'), options.ps_max_iterations_stage1 = 40; end
if ~isfield(options, 'ps_display'), options.ps_display = 'iter'; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end

clinical = get_clinical_patient(patient_id);

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
% Stage 1 only: RV/pulmonary tuning
% -------------------------------
stage1_names = {'Ees_rv','V0_rv','Rpo','Cpo','Rap','Cap','Rvp','Cvp'};

bounds_stage1 = struct();
bounds_stage1.Ees_rv = struct('lb', 0.80 * params0.Ees_rv, 'ub', 1.20 * params0.Ees_rv);
bounds_stage1.V0_rv  = struct('lb', 0.80 * params0.V0_rv , 'ub', 1.20 * params0.V0_rv );
bounds_stage1.Rpo    = struct('lb', 0.75 * params0.Rpo   , 'ub', 1.25 * params0.Rpo   );
bounds_stage1.Cpo    = struct('lb', 0.75 * params0.Cpo   , 'ub', 1.25 * params0.Cpo   );
bounds_stage1.Rap    = struct('lb', 0.75 * params0.Rap   , 'ub', 1.25 * params0.Rap   );
bounds_stage1.Cap    = struct('lb', 0.75 * params0.Cap   , 'ub', 1.25 * params0.Cap   );
bounds_stage1.Rvp    = struct('lb', 0.75 * params0.Rvp   , 'ub', 1.25 * params0.Rvp   );
bounds_stage1.Cvp    = struct('lb', 0.75 * params0.Cvp   , 'ub', 1.25 * params0.Cvp   );

[x0_stage1, ~] = struct_to_vector(params0, stage1_names);
[lb1, ub1, stage1_names] = bounds_struct_to_vectors(bounds_stage1, stage1_names);

obj1 = @(x) objective_rv_v2_vector(x, params0, stage1_names, clinical);

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
disp(severity1.summary);

if options.make_plot
    plot_hemodynamics(sim1, metrics1);
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

% Final result = masuk ke label
results.stage1.severity = severity1;

results.final = results.stage1;
results.final.severity = severity1;
end