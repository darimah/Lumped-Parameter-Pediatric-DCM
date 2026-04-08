function validate_xu_inputs(clinical)
% VALIDATE_XU_INPUTS
% -----------------------------------------------------------------------
% Validate the required clinical fields for the Xu 2025 DCM scoring model.
%
% INPUTS:
%   clinical - struct containing Xu predictor fields.
%
% OUTPUTS:
%   None. Throws an error if a required field is missing or invalid.
%
% ASSUMPTIONS:
%   - Ross class is an integer in {1,2,3,4}.
%   - Binary predictors are stored as logical scalars.
%
% REFERENCES:
%   [1] Xu B. et al. (2025). Children, 12, 880.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

required_fields = {
    'patient_id', ...
    'age_months', ...
    'ross_class', ...
    'has_mr_moderate_to_severe', ...
    'has_low_voltage_limb_leads', ...
    'requires_vasoactive_drugs'};

for i_field = 1:numel(required_fields)
    field_name = required_fields{i_field};
    if ~isfield(clinical, field_name)
        error('validate_xu_inputs:MissingField', ...
            'Missing required field: %s', field_name);
    end
end

age_months = clinical.age_months;                           % [months]
ross_class = clinical.ross_class;                           % [class]
has_mr = clinical.has_mr_moderate_to_severe;                % [logical]
has_low_voltage = clinical.has_low_voltage_limb_leads;      % [logical]
requires_vasoactive = clinical.requires_vasoactive_drugs;   % [logical]

if ~(isscalar(age_months) && isnumeric(age_months) && isfinite(age_months) && age_months >= 0)
    error('validate_xu_inputs:InvalidAge', ...
        'clinical.age_months must be a finite non-negative scalar.');
end

if ~(isscalar(ross_class) && isnumeric(ross_class) && any(ross_class == [1, 2, 3, 4]))
    error('validate_xu_inputs:InvalidRossClass', ...
        'clinical.ross_class must be one of 1, 2, 3, or 4.');
end

if ~(islogical(has_mr) && isscalar(has_mr))
    error('validate_xu_inputs:InvalidMR', ...
        'clinical.has_mr_moderate_to_severe must be a logical scalar.');
end

if ~(islogical(has_low_voltage) && isscalar(has_low_voltage))
    error('validate_xu_inputs:InvalidLowVoltage', ...
        'clinical.has_low_voltage_limb_leads must be a logical scalar.');
end

if ~(islogical(requires_vasoactive) && isscalar(requires_vasoactive))
    error('validate_xu_inputs:InvalidVasoactive', ...
        'clinical.requires_vasoactive_drugs must be a logical scalar.');
end
end
