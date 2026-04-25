function f = objective_lv_diameter_only_vector(x, params_base, param_names, clinical)
% Objective for Stage 2: tune LV diameter only (no RV diameter required)

params = vector_to_struct(params_base, param_names, x);

sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

errs = [];

if isfield(clinical, 'D_lv_ed')
    errs(end+1) = abs((clinical.D_lv_ed - metrics.D_lv_ed) / clinical.D_lv_ed);
end

if isfield(clinical, 'D_lv_es')
    errs(end+1) = abs((clinical.D_lv_es - metrics.D_lv_es) / clinical.D_lv_es);
end

if isempty(errs)
    error('No LV diameter targets found in clinical data.');
end

f = mean(errs);
end