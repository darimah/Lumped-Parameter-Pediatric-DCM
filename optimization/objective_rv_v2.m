function [objective_value, detail] = objective_rv_v2(params, clinical)
sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

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
