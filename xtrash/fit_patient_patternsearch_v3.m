function results = fit_patient_patternsearch_v3(clinical, options)
if nargin < 2
    options = struct();
end
if ~isfield(options, 'x_default_pct'), options.x_default_pct = 0.15; end
if ~isfield(options, 'x_percent_map'), options.x_percent_map = struct(); end
if ~isfield(options, 'ps_use_parallel'), options.ps_use_parallel = false; end
if ~isfield(options, 'ps_mesh_tolerance'), options.ps_mesh_tolerance = 1e-4; end
if ~isfield(options, 'ps_step_tolerance'), options.ps_step_tolerance = 1e-6; end
if ~isfield(options, 'ps_function_tolerance'), options.ps_function_tolerance = 1e-6; end
if ~isfield(options, 'ps_max_iterations'), options.ps_max_iterations = 50; end
if ~isfield(options, 'ps_display'), options.ps_display = 'iter'; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end
if ~isfield(options, 'solver_options'), options.solver_options = struct(); end

params0 = default_parameters(clinical.model_id);
params0.ubv_sys_fraction = 0.80;

[bounds_x, ~] = get_parameter_bounds(clinical.model_id);
bounds_x.ubv_sys_fraction = struct('lb', 0.70, 'ub', 0.90);

warm_bounds_x = refine_bounds_around_best(params0, bounds_x, options.x_default_pct, options.x_percent_map);

x_names = fieldnames(warm_bounds_x);
[x0_stage1, ~] = struct_to_vector(params0, x_names);
[lb1, ub1, x_names] = bounds_struct_to_vectors(warm_bounds_x, x_names);

obj1 = @(x) objective_map_co_v3_vector(x, params0, x_names, clinical, options.solver_options);

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
params_final = vector_to_struct(params0, x_names, xbest1);

sim = integrate_system_v3(clinical, params_final, options.solver_options);
metrics = compute_clinical_indices_v3(sim);
comparison = compare_model_vs_clinical(metrics, clinical);

if options.make_plot
    figure('Color','w','Name',[clinical.label '_v3']);
    subplot(2,2,1); plot(metrics.t, metrics.P_lv, 'LineWidth',1.5); hold on; plot(metrics.t, metrics.P_ao, 'LineWidth',1.5); grid on; title('LV and Aortic Pressure');
    subplot(2,2,2); plot(metrics.V_lv, metrics.P_lv, 'LineWidth',1.5); hold on; plot(metrics.V_rv, metrics.P_rv, 'LineWidth',1.5); grid on; title('PV Loops');
    subplot(2,2,3); plot(metrics.t, metrics.P_vs, 'LineWidth',1.5); hold on; plot(metrics.t, metrics.P_vp, 'LineWidth',1.5); grid on; legend('P_{vs}','P_{vp}','Location','best'); title('Venous pressures');
    subplot(2,2,4); plot(metrics.t, metrics.D_lv, 'LineWidth',1.5); hold on; plot(metrics.t, metrics.D_rv, 'LineWidth',1.5); grid on; title(sprintf('Diameters | MAP=%.2f, CO=%.2f', metrics.MAP, metrics.CO));
end

results = struct();
results.clinical = clinical;
results.params = params_final;
results.sim = sim;
results.metrics = metrics;
results.comparison = comparison;
results.patternsearch.fval = fval1;
results.patternsearch.exitflag = exitflag1;
results.patternsearch.output = output1;
end
