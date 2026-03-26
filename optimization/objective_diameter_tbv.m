function [objective_value, detail] = objective_diameter_tbv(params, clinical, solver_options)
if nargin < 3
    solver_options = struct();
end
sim = integrate_system_tbv(clinical, params, solver_options);
metrics = compute_clinical_indices(sim);

e = [
    (clinical.D_lv_es - metrics.D_lv_es) / clinical.D_lv_es
    (clinical.D_lv_ed - metrics.D_lv_ed) / clinical.D_lv_ed
    (clinical.D_rv_es - metrics.D_rv_es) / clinical.D_rv_es
    (clinical.D_rv_ed - metrics.D_rv_ed) / clinical.D_rv_ed
];
objective_value = max(abs(e));

detail.metrics = metrics;
detail.errors = e;
detail.objective = objective_value;
end
