clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical = get_clinical_patient(1);
params = default_parameters(clinical.model_id);
sim = integrate_system(clinical, params);
metrics = compute_clinical_indices(sim);

disp(metrics);
assert(all(isfinite(sim.x), 'all'), 'State contains NaN or Inf');
assert(isfinite(metrics.MAP), 'MAP invalid');
assert(isfinite(metrics.CO), 'CO invalid');
plot_hemodynamics(sim, metrics);
