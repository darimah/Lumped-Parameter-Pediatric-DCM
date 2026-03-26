function results = fit_patient_patternsearch_refined(patient_id, options)
if nargin < 1
    patient_id = 1;
end
if nargin < 2
    options = struct();
end

if ~isfield(options, 'run_direct_first'), options.run_direct_first = true; end
if ~isfield(options, 'x_default_pct'), options.x_default_pct = 0.15; end
if ~isfield(options, 'k_default_pct'), options.k_default_pct = 0.10; end
if ~isfield(options, 'x_percent_map'), options.x_percent_map = struct(); end
if ~isfield(options, 'k_percent_map'), options.k_percent_map = struct(); end
if ~isfield(options, 'ps_use_parallel'), options.ps_use_parallel = false; end
if ~isfield(options, 'ps_mesh_tolerance'), options.ps_mesh_tolerance = 1e-4; end
if ~isfield(options, 'ps_step_tolerance'), options.ps_step_tolerance = 1e-6; end
if ~isfield(options, 'ps_function_tolerance'), options.ps_function_tolerance = 1e-6; end
if ~isfield(options, 'ps_max_iterations'), options.ps_max_iterations = 80; end
if ~isfield(options, 'ps_display'), options.ps_display = 'iter'; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end

clinical = get_clinical_patient(patient_id);
params0 = default_parameters(clinical.model_id);
[bounds_x, bounds_k] = get_parameter_bounds(clinical.model_id);

if options.run_direct_first
    warm = fit_patient_bozkurt2022_refined(patient_id, options);
    warm_params = warm.final.params;
    warm_bounds_x = warm.pass2.bounds_x;
    warm_bounds_k = warm.pass2.bounds_k;
else
    warm = [];
    warm_params = params0;
    warm_bounds_x = refine_bounds_around_best(params0, bounds_x, options.x_default_pct, options.x_percent_map);
    warm_bounds_k = refine_bounds_around_best(params0, bounds_k, options.k_default_pct, options.k_percent_map);
end

x_names = fieldnames(warm_bounds_x);
[x0_stage1, ~] = struct_to_vector(warm_params, x_names);
[lb1, ub1, x_names] = bounds_struct_to_vectors(warm_bounds_x, x_names);
obj1 = @(x) objective_map_co_vector(x, warm_params, x_names, clinical);

ps_opts1 = optimoptions('patternsearch', ...
    'Display', options.ps_display, ...
    'UseCompletePoll', true, ...
    'UseCompleteSearch', false, ...
    'UseParallel', options.ps_use_parallel, ...
    'MeshTolerance', options.ps_mesh_tolerance, ...
    'StepTolerance', options.ps_step_tolerance, ...
    'FunctionTolerance', options.ps_function_tolerance, ...
    'MaxIterations', options.ps_max_iterations);

[xbest1, fval1, exitflag1, output1] = patternsearch(obj1, x0_stage1, [], [], [], [], lb1, ub1, [], ps_opts1);
params_stage1 = vector_to_struct(warm_params, x_names, xbest1);

k_names = fieldnames(warm_bounds_k);
[x0_stage2, ~] = struct_to_vector(params_stage1, k_names);
[lb2, ub2, k_names] = bounds_struct_to_vectors(warm_bounds_k, k_names);
obj2 = @(x) objective_diameter_vector(x, params_stage1, k_names, clinical);

ps_opts2 = optimoptions('patternsearch', ...
    'Display', options.ps_display, ...
    'UseCompletePoll', true, ...
    'UseCompleteSearch', false, ...
    'UseParallel', options.ps_use_parallel, ...
    'MeshTolerance', options.ps_mesh_tolerance, ...
    'StepTolerance', options.ps_step_tolerance, ...
    'FunctionTolerance', options.ps_function_tolerance, ...
    'MaxIterations', options.ps_max_iterations);

[xbest2, fval2, exitflag2, output2] = patternsearch(obj2, x0_stage2, [], [], [], [], lb2, ub2, [], ps_opts2);
params_final = vector_to_struct(params_stage1, k_names, xbest2);

sim = integrate_system(clinical, params_final);
metrics = compute_clinical_indices(sim);
comparison = compare_model_vs_clinical(metrics, clinical);

if options.make_plot
    plot_hemodynamics(sim, metrics);
end

results = struct();
results.clinical = clinical;
results.warm = warm;
results.params = params_final;
results.sim = sim;
results.metrics = metrics;
results.comparison = comparison;

results.patternsearch.stage1.x_names = x_names;
results.patternsearch.stage1.xbest = xbest1;
results.patternsearch.stage1.fval = fval1;
results.patternsearch.stage1.exitflag = exitflag1;
results.patternsearch.stage1.output = output1;
results.patternsearch.stage1.bounds.lb = lb1;
results.patternsearch.stage1.bounds.ub = ub1;

results.patternsearch.stage2.k_names = k_names;
results.patternsearch.stage2.xbest = xbest2;
results.patternsearch.stage2.fval = fval2;
results.patternsearch.stage2.exitflag = exitflag2;
results.patternsearch.stage2.output = output2;
results.patternsearch.stage2.bounds.lb = lb2;
results.patternsearch.stage2.bounds.ub = ub2;
end
