function severity = classify_dcm_severity(metrics)
% CLASSIFY_DCM_SEVERITY
% Automatic DCM severity label from model outputs
%
% Input:
%   metrics.EF_lv   -> LVEF (%)
%   metrics.CO      -> cardiac output (L/min)
%   metrics.MAP     -> mean arterial pressure (mmHg)
%
% Output:
%   severity.label_3class  -> mild / moderate / severe
%   severity.label_2class  -> mild / severe
%   severity.summary       -> formatted string for command window

LVEF = metrics.EF_lv;
CO   = metrics.CO;
MAP  = metrics.MAP;

% 3-class rule
if (LVEF >= 40) && (CO >= 3.0) && (MAP >= 60)
    label_3class = 'mild';
elseif (LVEF < 30) || (CO < 2.5) || (MAP < 55)
    label_3class = 'severe';
else
    label_3class = 'moderate';
end

% 2-class rule
if (LVEF >= 40) && (CO >= 3.0) && (MAP >= 60)
    label_2class = 'mild';
else
    label_2class = 'severe';
end

severity = struct();
severity.LVEF = LVEF;
severity.CO = CO;
severity.MAP = MAP;
severity.label_3class = label_3class;
severity.label_2class = label_2class;
severity.summary = sprintf( ...
    ['=== DCM Severity Classification ===\n' ...
     'LVEF : %.2f %%\n' ...
     'CO   : %.2f L/min\n' ...
     'MAP  : %.2f mmHg\n' ...
     '3-class label : %s\n' ...
     '2-class label : %s\n'], ...
     LVEF, CO, MAP, label_3class, label_2class);
end