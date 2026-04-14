function [y, y_names, metrics] = evaluate_bozkurt_outputs(param_vec, param_names, patient_id)
% EVALUATE_BOZKURT_OUTPUTS
% Runs the Bozkurt model once and returns the full output vector used for GSA.
%
% OUTPUT VECTOR:
%   MAP, CO, Pao_sys, Pao_dias,
%   V_lv_ed, V_lv_es, V_rv_ed, V_rv_es,
%   EF_lv, EF_rv,
%   D_lv_ed, D_lv_es, D_rv_ed, D_rv_es

clinical = get_clinical_patient(patient_id);
params = default_parameters(clinical.model_id);

for i = 1:numel(param_names)
    params.(param_names{i}) = param_vec(i);
end

sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

y_names = { ...
    'MAP','CO','Pao_sys','Pao_dias', ...
    'V_lv_ed','V_lv_es','V_rv_ed','V_rv_es', ...
    'EF_lv','EF_rv', ...
    'D_lv_ed','D_lv_es','D_rv_ed','D_rv_es'};

y = [ ...
    metrics.MAP; metrics.CO; metrics.Pao_sys; metrics.Pao_dias; ...
    metrics.V_lv_ed; metrics.V_lv_es; metrics.V_rv_ed; metrics.V_rv_es; ...
    metrics.EF_lv; metrics.EF_rv; ...
    metrics.D_lv_ed; metrics.D_lv_es; metrics.D_rv_ed; metrics.D_rv_es];
end
