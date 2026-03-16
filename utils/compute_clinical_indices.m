function metrics = compute_clinical_indices(sim)
idx = build_state_index();
t = sim.t; x = sim.x; params = sim.params; clinical = sim.clinical;

V_lv = x(:, idx.V_lv);
V_rv = x(:, idx.V_rv);
P_ao = x(:, idx.P_ao);
Q_ao = x(:, idx.Q_ao);

P_lv = zeros(size(t));
P_rv = zeros(size(t));
for k = 1:numel(t)
    E_v = elastance_ventricle(mod(t(k), sim.T), sim.T);
    P_lv(k) = params.Ees_lv * (V_lv(k) - params.V0_lv) * E_v + params.Alv * (exp(params.Blv * V_lv(k)) - 1);
    P_rv(k) = params.Ees_rv * (V_rv(k) - params.V0_rv) * E_v + params.Arv * (exp(params.Brv * V_rv(k)) - 1);
end

D_lv = geometry_diameter(V_lv, params.Klv, clinical.l_lv);
D_rv = geometry_diameter(V_rv, params.Krv, clinical.l_rv);

metrics = struct();
metrics.MAP = trapz(t, P_ao) / (t(end) - t(1));
metrics.CO  = trapz(t, Q_ao) / (t(end) - t(1)) * 60 / 1000;
metrics.Pao_sys  = max(P_ao);
metrics.Pao_dias = min(P_ao);
metrics.V_lv_ed = max(V_lv); metrics.V_lv_es = min(V_lv);
metrics.V_rv_ed = max(V_rv); metrics.V_rv_es = min(V_rv);
metrics.SV_lv = metrics.V_lv_ed - metrics.V_lv_es;
metrics.SV_rv = metrics.V_rv_ed - metrics.V_rv_es;
metrics.EF_lv = 100 * metrics.SV_lv / metrics.V_lv_ed;
metrics.EF_rv = 100 * metrics.SV_rv / metrics.V_rv_ed;
metrics.D_lv_ed = max(D_lv); metrics.D_lv_es = min(D_lv);
metrics.D_rv_ed = max(D_rv); metrics.D_rv_es = min(D_rv);
metrics.P_lv = P_lv; metrics.P_rv = P_rv; metrics.P_ao = P_ao;
metrics.V_lv = V_lv; metrics.V_rv = V_rv; metrics.D_lv = D_lv; metrics.D_rv = D_rv; metrics.t = t;
end
