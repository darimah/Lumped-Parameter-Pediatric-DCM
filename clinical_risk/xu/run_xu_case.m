function xu_results = run_xu_case(clinical_input)
% RUN_XU_CASE
% -----------------------------------------------------------------------
% Execute the Xu 2025 quantitative scoring model for a pediatric DCM case.
%
% INPUTS:
%   clinical_input - either:
%                    (1) a struct containing Xu input fields, or
%                    (2) a function handle returning such a struct.
%
% OUTPUTS:
%   xu_results     - Xu scoring output struct.
%
% ASSUMPTIONS:
%   - The case has already been mapped to the Xu predictor definitions.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

if isa(clinical_input, 'function_handle')
    clinical = clinical_input();
else
    clinical = clinical_input;
end

xu_results = xu_score_model(clinical);
print_xu_summary(clinical, xu_results);
save_xu_results(clinical, xu_results, fullfile('results', 'xu'));
end
