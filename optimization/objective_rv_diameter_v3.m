function [objective_value, detail] = objective_rv_diameter_v3(params, clinical, solver_options)
if nargin < 3
    solver_options = struct();
end

sim = integrate_system_v3(clinical, params, solver_options);
metrics = compute_clinical_indices_v3(sim);

f_D_rv_ed = (clinical.D_rv_ed - metrics.D_rv_ed) / clinical.D_rv_ed;
f_D_rv_es = (clinical.D_rv_es - metrics.D_rv_es) / clinical.D_rv_es;

objective_value = abs(f_D_rv_ed) + abs(f_D_rv_es);

detail = struct();
detail.metrics = metrics;
detail.f_D_rv_ed = f_D_rv_ed;
detail.f_D_rv_es = f_D_rv_es;
detail.objective = objective_value;
end
