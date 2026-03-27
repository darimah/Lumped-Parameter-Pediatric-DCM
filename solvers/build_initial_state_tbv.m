function x0 = build_initial_state_tbv(clinical, params, settings)
if nargin < 3
    settings = struct();
end
if ~isfield(settings, 'frac_sven'), settings.frac_sven = 0.45; end
if ~isfield(settings, 'frac_pven'), settings.frac_pven = 0.18; end
if ~isfield(settings, 'frac_atria'), settings.frac_atria = 0.07; end
if ~isfield(settings, 'frac_vent'), settings.frac_vent = 0.15; end
if ~isfield(settings, 'frac_art'),  settings.frac_art  = 0.15; end

if ~isfield(clinical, 'TBV_ml') || ~isfield(clinical, 'UBV_ml')
    error('clinical must contain TBV_ml and UBV_ml. Use add_tbv_ubv_to_clinical first.');
end

SBV = clinical.TBV_ml - clinical.UBV_ml;
if SBV <= 0
    error('Stressed blood volume must be positive');
end

V_sven = settings.frac_sven * SBV;
V_pven = settings.frac_pven * SBV;
V_atria = settings.frac_atria * SBV;
V_vent  = settings.frac_vent * SBV;
V_art   = settings.frac_art  * SBV;

V_la0 = 0.50 * V_atria;
V_ra0 = 0.50 * V_atria;

V_lv0 = max(0.85 * clinical.V_lv_ed, 0.30 * V_vent + 0.70 * clinical.V_lv_ed); % kedua bagian ini yang diubah
V_rv0 = max(0.80 * clinical.V_rv_ed, 0.20 * V_vent + 0.80 * clinical.V_rv_ed);

P_vs0 = max(3, V_sven / max(params.Cvs, eps));
P_vp0 = max(4, V_pven / max(params.Cvp, eps));

P_ao0 = clinical.Pao_dias;
P_as0 = max(20, 0.35 * P_ao0 + V_art / max(params.Cas, eps));
P_po0 = max(8, V_art / max(params.Cpo, eps));
P_ap0 = max(6, 0.65 * P_po0);

q0 = clinical.CO * 1000 / 60;

x0 = [V_la0; V_lv0; V_ra0; V_rv0; P_ao0; q0; P_as0; q0; P_vs0; P_po0; q0; P_ap0; q0; P_vp0];
end
