clear; clc;
project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

clinical = get_clinical_patient(1);
params = default_parameters(clinical.model_id);
sim = integrate_system(clinical, params);
idx = build_state_index();
total_heart = sim.x(:, idx.V_la) + sim.x(:, idx.V_lv) + sim.x(:, idx.V_ra) + sim.x(:, idx.V_rv);
fprintf('Heart volume range over last cycle = %.4f mL\n', max(total_heart) - min(total_heart));
