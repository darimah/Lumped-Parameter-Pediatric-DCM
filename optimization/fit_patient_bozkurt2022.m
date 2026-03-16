function results = fit_patient_bozkurt2022(patient_id)
if nargin < 1
    patient_id = 1;
end

clinical = get_clinical_patient(patient_id);
params0 = default_parameters(clinical.model_id);
[bounds_x, bounds_k] = get_parameter_bounds(clinical.model_id);

disp('Stage 1: fit MAP and CO');
stage1 = direct_search_bozkurt(clinical, params0, bounds_x, @objective_map_co, fieldnames(bounds_x), 10, 12);

disp('Stage 2: fit Klv and Krv');
stage2 = direct_search_bozkurt(clinical, stage1.best_params, bounds_k, @objective_diameter, fieldnames(bounds_k), 10, 10);

sim = integrate_system(clinical, stage2.best_params);
metrics = compute_clinical_indices(sim);
comparison = compare_model_vs_clinical(metrics, clinical);
plot_hemodynamics(sim, metrics);

results.clinical = clinical;
results.stage1 = stage1;
results.stage2 = stage2;
results.params = stage2.best_params;
results.sim = sim;
results.metrics = metrics;
results.comparison = comparison;
end
