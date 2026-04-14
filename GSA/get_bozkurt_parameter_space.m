function pspace = get_bozkurt_parameter_space(patient_id, use_saved_final_mat)
% GET_BOZKURT_PARAMETER_SPACE
% Returns all Bozkurt model parameters, their baseline values, and bounds.
%
% If use_saved_final_mat = true, this function loads the previously saved
% final Stage-1 result instead of re-running the optimisation.

if nargin < 1
    patient_id = 1;
end
if nargin < 2
    use_saved_final_mat = true;
end

clinical = get_clinical_patient(patient_id);
base_params = default_parameters(clinical.model_id);

if use_saved_final_mat
    project_root = fileparts(fileparts(mfilename('fullpath')));
    mat_name = sprintf('patient%02d_results.mat', patient_id);
    mat_path = fullfile(project_root, 'results', mat_name);

    if exist(mat_path, 'file')
        S = load(mat_path);
        if isfield(S, 'results') && isfield(S.results, 'final') && isfield(S.results.final, 'params')
            base_params = S.results.final.params;
        else
            warning('Saved MAT file found, but results.final.params not found. Using default parameters.');
        end
    else
        warning('Saved final MAT file not found: %s. Using default parameters.', mat_path);
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