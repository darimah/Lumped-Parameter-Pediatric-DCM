function [objective_value, detail] = objective_rv_diameter_v2(params, clinical)
sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

f_D_rv_ed = (clinical.D_rv_ed - metrics.D_rv_ed) / clinical.D_rv_ed;
f_D_rv_es = (clinical.D_rv_es - metrics.D_rv_es) / clinical.D_rv_es;

objective_value = abs(f_D_rv_ed) + abs(f_D_rv_es);

detail = struct();
detail.metrics = metrics;
detail.f_D_rv_ed = f_D_rv_ed;
detail.f_D_rv_es = f_D_rv_es;
detail.objective = objective_value;
end
