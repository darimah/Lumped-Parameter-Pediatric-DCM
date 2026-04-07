function results = fit_patient_patternsearch_v3_rv_tuning(clinical, options)
if nargin < 2
    options = struct();
end

if ~isfield(options, 'ps_use_parallel'), options.ps_use_parallel = false; end
if ~isfield(options, 'ps_mesh_tolerance'), options.ps_mesh_tolerance = 1e-4; end
if ~isfield(options, 'ps_step_tolerance'), options.ps_step_tolerance = 1e-6; end
if ~isfield(options, 'ps_function_tolerance'), options.ps_function_tolerance = 1e-6; end
if ~isfield(options, 'ps_max_iterations_stage1'), options.ps_max_iterations_stage1 = 40; end
if ~isfield(options, 'ps_max_iterations_stage2'), options.ps_max_iterations_stage2 = 30; end
if ~isfield(options, 'ps_display'), options.ps_display = 'iter'; end
if ~isfield(options, 'make_plot'), options.make_plot = true; end
if ~isfield(options, 'solver_options'), options.solver_options = struct(); end

params0 = default_parameters(clinical.model_id);
params0.ubv_sys_fraction = 0.80;

sim0 = integrate_system_v3(clinical, params0, options.solver_options);
metrics0 = compute_clinical_indices_v3(sim0);
comparison0 = compare_model_vs_clinical(metrics0, clinical);

stage1_names = {'ubv_sys_fraction', 'Rvp', 'Cvp', 'Rpo', 'Cpo'};

bounds_stage1 = struct();
bounds_stage1.ubv_sys_fraction = struct('lb', 0.70, 'ub', 0.90);
bounds_stage1.Rvp = struct('lb', 0.75 * params0.Rvp, 'ub', 1.25 * params0.Rvp);
bounds_stage1.Cvp = struct('lb', 0.75 * params0.Cvp, 'ub', 1.25 * params0.Cvp);
bounds_stage1.Rpo = struct('lb', 0.75 * params0.Rpo, 'ub', 1.25 * params0.Rpo);
bounds_stage1.Cpo = struct('lb', 0.75 * params0.Cpo, 'ub', 1.25 * params0.Cpo);

[x0_stage1, ~] = struct_to_vector(params0, stage1_names);
[lb1, ub1, stage1_names] = bounds_struct_to_vectors(bounds_stage1, stage1_names);

obj1 = @(x) objective_rv_v3_vector(x, params0, stage1_names, clinical, options.solver_options);

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

sim1 = integrate_system_v3(clinical, params_stage1, options.solver_options);
metrics1 = compute_clinical_indices_v3(sim1);
comparison1 = compare_model_vs_clinical(metrics1, clinical);

stage2_names = {'Krv'};
bounds_stage2 = struct();
bounds_stage2.Krv = struct('lb', 0.80, 'ub', 2.50);

[x0_stage2, ~] = struct_to_vector(params_stage1, stage2_names);
[lb2, ub2, stage2_names] = bounds_struct_to_vectors(bounds_stage2, stage2_names);

obj2 = @(x) objective_rv_diameter_v3_vector(x, params_stage1, stage2_names, clinical, options.solver_options);

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
params_final = vector_to_struct(params_stage1, stage2_names, xbest2);

sim2 = integrate_system_v3(clinical, params_final, options.solver_options);
metrics2 = compute_clinical_indices_v3(sim2);
comparison2 = compare_model_vs_clinical(metrics2, clinical);

if options.make_plot
    figure('Color','w','Name',[clinical.label '_v3_rv_tuning']);
    subplot(2,2,1);
    plot(metrics2.t, metrics2.P_lv, 'LineWidth', 1.5); hold on;
    plot(metrics2.t, metrics2.P_ao, 'LineWidth', 1.5);
    grid on; xlabel('t (s)'); ylabel('Pressure (mmHg)');
    legend('P_{lv}','P_{ao}','Location','best'); title('LV and Aortic Pressure');

    subplot(2,2,2);
    plot(metrics2.V_lv, metrics2.P_lv, 'LineWidth', 1.5); hold on;
    plot(metrics2.V_rv, metrics2.P_rv, 'LineWidth', 1.5);
    grid on; xlabel('Volume (mL)'); ylabel('Pressure (mmHg)');
    legend('LV','RV','Location','best'); title('PV Loops');

    subplot(2,2,3);
    plot(metrics2.t, metrics2.P_vs, 'LineWidth', 1.5); hold on;
    plot(metrics2.t, metrics2.P_vp, 'LineWidth', 1.5);
    grid on; xlabel('t (s)'); ylabel('Pressure (mmHg)');
    legend('P_{vs}','P_{vp}','Location','best'); title('Venous Pressures');

    subplot(2,2,4);
    plot(metrics2.t, metrics2.D_lv, 'LineWidth', 1.5); hold on;
    plot(metrics2.t, metrics2.D_rv, 'LineWidth', 1.5);
    grid on; xlabel('t (s)'); ylabel('Diameter (cm)');
    legend('D_{lv}','D_{rv}','Location','best');
    title(sprintf('Diameters | MAP=%.2f, CO=%.2f', metrics2.MAP, metrics2.CO));
end

results = struct();
results.clinical = clinical;

results.before = struct();
results.before.params = params0;
results.before.sim = sim0;
results.before.metrics = metrics0;
results.before.comparison = comparison0;

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

results.stage2 = struct();
results.stage2.params = params_final;
results.stage2.sim = sim2;
results.stage2.metrics = metrics2;
results.stage2.comparison = comparison2;
results.stage2.fval = fval2;
results.stage2.exitflag = exitflag2;
results.stage2.output = output2;
results.stage2.parameter_names = stage2_names;
results.stage2.bounds.lb = lb2;
results.stage2.bounds.ub = ub2;

results.final = struct();
results.final.params = params_final;
results.final.sim = sim2;
results.final.metrics = metrics2;
results.final.comparison = comparison2;
end
