function print_xu_summary(clinical, xu_results)
% PRINT_XU_SUMMARY
% -----------------------------------------------------------------------
% Print a concise terminal summary of Xu model inputs and outputs.
%
% INPUTS:
%   clinical   - input clinical struct.
%   xu_results - output struct from xu_score_model.
%
% OUTPUTS:
%   None.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

fprintf('\n=== Xu 2025 Pediatric DCM Score Summary ===\n');
fprintf('Patient ID                    : %s\n', clinical.patient_id);
fprintf('Age at onset                  : %.1f months\n', clinical.age_months);
fprintf('Ross class                    : %d\n', clinical.ross_class);
fprintf('Moderate-to-severe MR         : %s\n', local_yes_no(clinical.has_mr_moderate_to_severe));
fprintf('Low voltage limb leads        : %s\n', local_yes_no(clinical.has_low_voltage_limb_leads));
fprintf('Requires vasoactive drugs     : %s\n', local_yes_no(clinical.requires_vasoactive_drugs));

fprintf('\nPoints\n');
fprintf('  Age >= %.1f months          : %.1f\n', xu_results.age_cutoff_months, xu_results.points_age);
fprintf('  Ross class III-IV           : %.1f\n', xu_results.points_function_class);
fprintf('  Moderate-to-severe MR       : %.1f\n', xu_results.points_mr);
fprintf('  Low voltage limb leads      : %.1f\n', xu_results.points_low_voltage);
fprintf('  Requires vasoactive drugs   : %.1f\n', xu_results.points_vasoactive);

fprintf('\nTotal Xu score                : %.2f\n', xu_results.total_score);
fprintf('Score cutoff                  : %.2f\n', xu_results.score_cutoff);
fprintf('Above cutoff                  : %s\n', local_yes_no(xu_results.is_above_score_cutoff));
end

function text_out = local_yes_no(flag_value)
% LOCAL_YES_NO — convert logical scalar to Yes/No text.
if flag_value
    text_out = 'Yes';
else
    text_out = 'No';
end
end
