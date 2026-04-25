function f = objective_full_hemodynamics_vector(x, params_base, param_names, clinical)
% Stage 1 objective for x-parameters only.
% Uses available hemodynamic/volume targets from clinical data.

params = vector_to_struct(params_base, param_names, x);

sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

errs = [];

candidate_fields = {'MAP','CO','Pao_sys','Pao_dias','V_lv_ed','V_lv_es','V_rv_ed','V_rv_es'};

for i = 1:numel(candidate_fields)
    nm = candidate_fields{i};
    if isfield(clinical, nm) && isfield(metrics, nm)
        errs(end+1) = abs((clinical.(nm) - metrics.(nm)) / clinical.(nm));
    end
end

if isempty(errs)
    error('No clinical targets found for Stage 1 objective.');
end

f = mean(errs);
end