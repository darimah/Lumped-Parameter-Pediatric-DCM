function sim = integrate_system(clinical, params, solver_options)
if nargin < 3
    solver_options = struct();
end
if ~isfield(solver_options, 'n_cycles'), solver_options.n_cycles = 12; end
if ~isfield(solver_options, 'RelTol'),   solver_options.RelTol = 1e-3; end
if ~isfield(solver_options, 'AbsTol'),   solver_options.AbsTol = 1e-6; end
if ~isfield(solver_options, 'MaxStep'),  solver_options.MaxStep = 1e-3; end

T = 60 / clinical.HR;
t_end = solver_options.n_cycles * T;

q0 = clinical.CO * 1000 / 60;
x0 = [30; max(clinical.V_lv_ed,80); 30; max(clinical.V_rv_ed,80); clinical.Pao_dias; q0; 30; q0; 8; 15; q0; 12; q0; 8];

ode_options = odeset('RelTol', solver_options.RelTol, 'AbsTol', solver_options.AbsTol, 'MaxStep', solver_options.MaxStep);
[t_full, x_full] = ode15s(@(t,x) system_rhs(t, x, clinical, params), [0, t_end], x0, ode_options);

keep = t_full >= (t_end - T);
sim.t = t_full(keep) - (t_end - T);
sim.x = x_full(keep, :);
sim.T = T;
sim.params = params;
sim.clinical = clinical;
end
