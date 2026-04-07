function x0 = build_initial_state_v3(clinical, params, settings)
if nargin < 3
    settings = struct();
end
if ~isfield(settings, 'vs_stressed_extra'), settings.vs_stressed_extra = 0.18; end
if ~isfield(settings, 'vp_stressed_extra'), settings.vp_stressed_extra = 0.08; end

if ~isfield(clinical, 'UBV_ml') || ~isfield(clinical, 'TBV_ml')
    error('clinical must contain TBV_ml and UBV_ml');
end

SBV = clinical.TBV_ml - clinical.UBV_ml;
UBV_sys = params.ubv_sys_fraction * clinical.UBV_ml;
UBV_pul = (1 - params.ubv_sys_fraction) * clinical.UBV_ml;

V_vs0 = UBV_sys + settings.vs_stressed_extra * SBV;
V_vp0 = UBV_pul + settings.vp_stressed_extra * SBV;

V_la0 = max(20, 0.35 * clinical.V_lv_ed);
V_ra0 = max(18, 0.35 * clinical.V_rv_ed);
V_lv0 = max(0.90 * clinical.V_lv_ed, clinical.V_lv_ed - 5);
V_rv0 = max(0.90 * clinical.V_rv_ed, clinical.V_rv_ed - 4);

P_ao0 = clinical.Pao_dias;
q0 = clinical.CO * 1000 / 60;
P_as0 = max(25, 0.45 * P_ao0);
P_po0 = 15;
P_ap0 = 12;

x0 = [V_la0; V_lv0; V_ra0; V_rv0; P_ao0; q0; P_as0; q0; V_vs0; P_po0; q0; P_ap0; q0; V_vp0];
end
