function dx = system_rhs(t, x, clinical, params)
V_la = x(1); V_lv = x(2); V_ra = x(3); V_rv = x(4);
P_ao = x(5); Q_ao = x(6); P_as = x(7); Q_as = x(8); P_vs = x(9);
P_po = x(10); Q_po = x(11); P_ap = x(12); Q_ap = x(13); P_vp = x(14);

T = 60 / clinical.HR;
tau = mod(t, T);

E_v = elastance_ventricle(tau, T);
T_atrial = 0.8 * T;

E_la = elastance_atrium(tau, T, params.Emin_la, params.Emax_la, T_atrial, params.atrial_delay_la);
E_ra = elastance_atrium(tau, T, params.Emin_ra, params.Emax_ra, T_atrial, params.atrial_delay_ra);

P_lv = params.Ees_lv * (V_lv - params.V0_lv) * E_v + params.Alv * (exp(params.Blv * V_lv) - 1);
P_rv = params.Ees_rv * (V_rv - params.V0_rv) * E_v + params.Arv * (exp(params.Brv * V_rv) - 1);
P_la = E_la * (V_la - params.V0_la);
P_ra = E_ra * (V_ra - params.V0_ra);

Q_mv = valve_flow(P_la, P_lv, params.Rmv_f, params.Rmv_b);
Q_av = valve_flow(P_lv, P_ao, params.Rav_f, params.Rav_b);
Q_tv = valve_flow(P_ra, P_rv, params.Rtv_f, params.Rtv_b);
Q_pv = valve_flow(P_rv, P_po, params.Rpv_f, params.Rpv_b);

Q_sv = (P_vs - P_ra) / params.Rvs;
Q_vp = (P_vp - P_la) / params.Rvp;

dV_la = Q_vp - Q_mv;
dV_lv = Q_mv - Q_av;
dV_ra = Q_sv - Q_tv;
dV_rv = Q_tv - Q_pv;

dP_ao = (Q_av - Q_ao) / params.Cao;
dQ_ao = (P_ao - P_as - params.Rao * Q_ao) / params.Lao;

dP_as = (Q_ao - Q_as) / params.Cas;
dQ_as = (P_as - P_vs - params.Ras * Q_as) / params.Las;
dP_vs = (Q_as - Q_sv) / params.Cvs;

dP_po = (Q_pv - Q_po) / params.Cpo;
dQ_po = (P_po - P_ap - params.Rpo * Q_po) / params.Lpo;

dP_ap = (Q_po - Q_ap) / params.Cap;
dQ_ap = (P_ap - P_vp - params.Rap * Q_ap) / params.Lap;
dP_vp = (Q_ap - Q_vp) / params.Cvp;

dx = [dV_la; dV_lv; dV_ra; dV_rv; dP_ao; dQ_ao; dP_as; dQ_as; dP_vs; dP_po; dQ_po; dP_ap; dQ_ap; dP_vp];
end
