function save_xu_results(clinical, xu_results, output_directory)
% SAVE_XU_RESULTS
% -----------------------------------------------------------------------
% Save Xu model inputs and outputs to a MAT file.
%
% INPUTS:
%   clinical         - clinical input struct.
%   xu_results       - Xu scoring output struct.
%   output_directory - directory for saved MAT files.
%
% OUTPUTS:
%   None.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

if nargin < 3
    output_directory = fullfile('results', 'xu');
end

if ~exist(output_directory, 'dir')
    mkdir(output_directory);
end

file_name = sprintf('%s_xu_score.mat', clinical.patient_id);
file_path = fullfile(output_directory, file_name);

save(file_path, 'clinical', 'xu_results');
fprintf('Saved Xu results to: %s\n', file_path);
end
