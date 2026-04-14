function pspace = get_bozkurt_parameter_space(patient_id, use_final_stage1)
% GET_BOZKURT_PARAMETER_SPACE
% Returns all Bozkurt model parameters, their baseline values, and bounds.
%
% This function is designed to work with the final project structure we
% built in chat:
%   - get_clinical_patient
%   - default_parameters
%   - get_parameter_bounds
%   - fit_patient_patternsearch_v2_final
%
% INPUTS
%   patient_id         : integer
%   use_final_stage1   : logical, if true uses results.final.params as baseline
%
% OUTPUT
%   pspace.names       : cell array of parameter names
%   pspace.base        : baseline parameter struct
%   pspace.base_vec    : baseline parameter vector
%   pspace.lb          : lower bounds vector
%   pspace.ub          : upper bounds vector

if nargin < 1
    patient_id = 1;
end
if nargin < 2
    use_final_stage1 = true;
end

clinical = get_clinical_patient(patient_id);
base_params = default_parameters(clinical.model_id);

if use_final_stage1
    try
        fitted = fit_patient_patternsearch_v2_final(patient_id);
        base_params = fitted.final.params;
    catch ME
        warning('Could not load final Stage-1 parameters. Falling back to default_parameters. Message: %s', ME.message);
    end
end

[bounds_x, bounds_k] = get_parameter_bounds(clinical.model_id);

names_x = fieldnames(bounds_x);
names_k = fieldnames(bounds_k);
all_names = [names_x; names_k];

lb = zeros(numel(all_names),1);
ub = zeros(numel(all_names),1);
base_vec = zeros(numel(all_names),1);

for i = 1:numel(all_names)
    name = all_names{i};
    if isfield(bounds_x, name)
        lb(i) = bounds_x.(name).lb;
        ub(i) = bounds_x.(name).ub;
    else
        lb(i) = bounds_k.(name).lb;
        ub(i) = bounds_k.(name).ub;
    end
    base_vec(i) = base_params.(name);
end

pspace = struct();
pspace.patient_id = patient_id;
pspace.names = all_names;
pspace.base = base_params;
pspace.base_vec = base_vec;
pspace.lb = lb;
pspace.ub = ub;
end
