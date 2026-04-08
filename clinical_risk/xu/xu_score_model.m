function xu_results = xu_score_model(clinical)
% XU_SCORE_MODEL
% -----------------------------------------------------------------------
% Compute the Xu 2025 quantitative pediatric DCM risk score.
%
% This function implements only the published point-based scoring system,
% not the full nomogram probability map. The score is intended as a
% clinical-risk layer that can later be compared against LPM-derived
% hemodynamic indices such as LVEF.
%
% INPUTS:
%   clinical   - struct with Xu predictor fields.
%
% OUTPUTS:
%   xu_results - struct containing predictor flags, point assignment,
%                total score, and cutoff classification.
%
% ASSUMPTIONS:
%   - Age threshold is 58.5 months.
%   - Ross class III-IV is treated as the pediatric analogue used by Xu.
%   - Total score cutoff for higher risk is 13.25 points.
%
% REFERENCES:
%   [1] Xu B. et al. (2025). Children, 12, 880.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

validate_xu_inputs(clinical);

age_months = clinical.age_months;                           % [months]
ross_class = clinical.ross_class;                           % [class]
has_mr = clinical.has_mr_moderate_to_severe;                % [logical]
has_low_voltage = clinical.has_low_voltage_limb_leads;      % [logical]
requires_vasoactive = clinical.requires_vasoactive_drugs;   % [logical]

age_cutoff_months = 58.5;                                   % [months]
score_cutoff = 13.25;                                       % [points]

is_age_high_risk = age_months >= age_cutoff_months;         % [logical]
is_function_class_high_risk = ross_class >= 3;              % [logical]

points_age = 1.0 * double(is_age_high_risk);                % [points]
points_function_class = 10.0 * double(is_function_class_high_risk);  % [points]
points_mr = 2.5 * double(has_mr);                           % [points]
points_low_voltage = 4.0 * double(has_low_voltage);         % [points]
points_vasoactive = 3.0 * double(requires_vasoactive);      % [points]

total_score = points_age + points_function_class + points_mr + ...
    points_low_voltage + points_vasoactive;                 % [points]

xu_results = struct();
xu_results.patient_id = clinical.patient_id;
xu_results.age_cutoff_months = age_cutoff_months;           % [months]
xu_results.score_cutoff = score_cutoff;                     % [points]

xu_results.is_age_high_risk = is_age_high_risk;
xu_results.is_function_class_high_risk = is_function_class_high_risk;
xu_results.has_mr_moderate_to_severe = has_mr;
xu_results.has_low_voltage_limb_leads = has_low_voltage;
xu_results.requires_vasoactive_drugs = requires_vasoactive;

xu_results.points_age = points_age;                         % [points]
xu_results.points_function_class = points_function_class;   % [points]
xu_results.points_mr = points_mr;                           % [points]
xu_results.points_low_voltage = points_low_voltage;         % [points]
xu_results.points_vasoactive = points_vasoactive;           % [points]
xu_results.total_score = total_score;                       % [points]

xu_results.is_above_score_cutoff = total_score >= score_cutoff;
xu_results.model_name = 'Xu 2025 quantitative scoring model';
xu_results.model_scope = 'Risk stratification for death/heart transplantation in pediatric DCM';
end
