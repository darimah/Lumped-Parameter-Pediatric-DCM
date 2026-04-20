function comparison = compare_model_vs_clinical(metrics, clinical)
% COMPARE_MODEL_VS_CLINICAL
% Compare only variables that exist in both metrics and clinical.

candidate_fields = { ...
    'MAP', 'CO', 'Pao_sys', 'Pao_dias', ...
    'V_lv_ed', 'V_lv_es', 'V_rv_ed', 'V_rv_es', ...
    'D_lv_ed', 'D_lv_es', 'D_rv_ed', 'D_rv_es'};

comparison = struct();
comparison.model = struct();
comparison.clinical = struct();
comparison.relerr = struct();

for i = 1:numel(candidate_fields)
    f = candidate_fields{i};

    if isfield(metrics, f) && isfield(clinical, f)
        comparison.model.(f) = metrics.(f);
        comparison.clinical.(f) = clinical.(f);
        comparison.relerr.(f) = (metrics.(f) - clinical.(f)) / clinical.(f);
    end
end
end