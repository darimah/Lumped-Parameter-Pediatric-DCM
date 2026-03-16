function [objective_value, detail] = objective_diameter(params, clinical)
sim = integrate_system(clinical, params);
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
