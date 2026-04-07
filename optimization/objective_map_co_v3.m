function [objective_value, detail] = objective_map_co_v3(params, clinical, solver_options)
if nargin < 3
    solver_options = struct();
end
sim = integrate_system_v3(clinical, params, solver_options);
metrics = compute_clinical_indices_v3(sim);

f_MAP = (clinical.MAP - metrics.MAP) / clinical.MAP;
f_CO  = (clinical.CO  - metrics.CO ) / clinical.CO;

objective_value = abs(f_MAP) + abs(f_CO);

detail.metrics = metrics;
detail.f_MAP = f_MAP;
detail.f_CO = f_CO;
detail.objective = objective_value;
end
