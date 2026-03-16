function [objective_value, detail] = objective_map_co(params, clinical)
sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);
f_MAP = (clinical.MAP - metrics.MAP) / clinical.MAP;
f_CO  = (clinical.CO  - metrics.CO ) / clinical.CO;
objective_value = abs(f_MAP + f_CO);
detail.metrics = metrics;
detail.f_MAP = f_MAP;
detail.f_CO = f_CO;
detail.objective = objective_value;
end
