clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical = get_clinical_patient(1);
params = default_parameters(clinical.model_id);
sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);
comparison = compare_model_vs_clinical(metrics, clinical); %#ok<NASGU>
disp(metrics);
plot_hemodynamics(sim, metrics);
