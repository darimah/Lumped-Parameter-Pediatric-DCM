function [objective_value, detail] = objective_rv_v3(params, clinical, solver_options)
if nargin < 3
    solver_options = struct();
end

sim = integrate_system_v3(clinical, params, solver_options);
metrics = compute_clinical_indices_v3(sim);

f_Pao_dias = (clinical.Pao_dias - metrics.Pao_dias) / clinical.Pao_dias;
f_V_rv_ed  = (clinical.V_rv_ed  - metrics.V_rv_ed ) / clinical.V_rv_ed;
f_V_rv_es  = (clinical.V_rv_es  - metrics.V_rv_es ) / clinical.V_rv_es;

objective_value = abs(f_Pao_dias) + abs(f_V_rv_ed) + abs(f_V_rv_es);

detail = struct();
detail.metrics = metrics;
detail.f_Pao_dias = f_Pao_dias;
detail.f_V_rv_ed = f_V_rv_ed;
detail.f_V_rv_es = f_V_rv_es;
detail.objective = objective_value;
end
