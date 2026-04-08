function clinical = xu_patient_case_001()
% XU_PATIENT_CASE_001
% -----------------------------------------------------------------------
% Return a single pediatric DCM clinical record formatted for the Xu 2025
% quantitative scoring model.
%
% The values in this file are intended only for the Xu clinical risk layer.
% They do not modify the lumped-parameter model. This separation preserves
% a clear boundary between raw clinical measurements and simulated outputs.
%
% INPUTS:
%   None.
%
% OUTPUTS:
%   clinical - struct containing demographic, ECG, echocardiographic, and
%              treatment variables needed by the Xu scoring system.
%
% ASSUMPTIONS:
%   - Age is stored as age at diagnosis/onset in months.
%   - Ross classification is used for this pediatric case.
%   - Mitral regurgitation is already mapped to the binary question used in
%     the Xu score: moderate-to-severe = true, otherwise false.
%   - Low limb-lead voltage is stored as a binary ECG finding.
%   - Need for vasoactive drugs is stored as a binary treatment variable.
%
% REFERENCES:
%   [1] Xu B. et al. (2025). Prognosis of Pediatric Dilated Cardiomyopathy:
%       Nomogram and Risk Score Models for Predicting Death/Heart
%       Transplantation. Children, 12, 880.
%
% AUTHOR:   OpenAI
% DATE:     2026-04-08
% VERSION:  1.0
% -----------------------------------------------------------------------

clinical = struct();

clinical.patient_id = 'xu_case_001';
clinical.age_months = 52;                        % [months]
clinical.sex = 1;                                % [0=female, 1=male]
clinical.height_cm = 101;                        % [cm]
clinical.weight_kg = 16.4;                       % [kg]
clinical.BSA = 0.68;                             % [m^2]

clinical.ross_class = 4;                         % [class]
clinical.has_mr_moderate_to_severe = true;       % [logical]
clinical.has_low_voltage_limb_leads = true;      % [logical]
clinical.requires_vasoactive_drugs = true;       % [logical]

clinical.P_ao_sys = 96;                          % [mmHg]
clinical.P_ao_dia = 57;                          % [mmHg]

clinical.data_source = 'Manual transcription from patient form image + user confirmation';
end
