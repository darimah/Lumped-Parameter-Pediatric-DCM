clear; clc;

project_root = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(project_root));

patient_id = 2; %ubah patient id di sini
N_list = [64, 128];
use_final_stage1 = true;   % now means: use saved final MAT

results_dir = fullfile(project_root, 'results');
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

all_gsa = struct([]);
for k = 1:numel(N_list)
    N = N_list(k);
    gsa = run_bozkurt_sobol_once(patient_id, N, use_final_stage1);
    all_gsa(k).N = N;
    all_gsa(k).gsa = gsa;

    mat_name = sprintf('bozkurt_sobol_patient%02d_N%d.mat', patient_id, N);
    save(fullfile(results_dir, mat_name), 'gsa');

    % Export ranking tables for each output
    out_names = gsa.output_names;
    for m = 1:numel(out_names)
        T = gsa.rankings.(out_names{m});
        csv_name = sprintf('bozkurt_sobol_patient%02d_N%d_%s.csv', patient_id, N, out_names{m});
        writetable(T, fullfile(results_dir, csv_name));
    end
end

save(fullfile(results_dir, sprintf('bozkurt_sobol_patient%02d_all.mat', patient_id)), 'all_gsa');

disp('=== Sobol GSA completed ===');
disp('Saved MAT files and per-output ranking CSV files into /results');
