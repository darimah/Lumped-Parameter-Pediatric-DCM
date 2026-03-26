function sim = integrate_system_tbv(clinical, params, solver_options)
if nargin < 3
    solver_options = struct();
end
if ~isfield(solver_options, 'n_cycles'), solver_options.n_cycles = 12; end
if ~isfield(solver_options, 'RelTol'),   solver_options.RelTol = 1e-3; end
if ~isfield(solver_options, 'AbsTol'),   solver_options.AbsTol = 1e-6; end
if ~isfield(solver_options, 'MaxStep'),  solver_options.MaxStep = 1e-3; end
if ~isfield(solver_options, 'tbv_init_settings'), solver_options.tbv_init_settings = struct(); end

T = 60 / clinical.HR;
t_end = solver_options.n_cycles * T;

x0 = build_initial_state_tbv(clinical, params, solver_options.tbv_init_settings);

ode_options = odeset('RelTol', solver_options.RelTol, 'AbsTol', solver_options.AbsTol, 'MaxStep', solver_options.MaxStep);
[t_full, x_full] = ode15s(@(t, x) system_rhs(t, x, clinical, params), [0, t_end], x0, ode_options);

keep = t_full >= (t_end - T);
sim.t = t_full(keep) - (t_end - T);
sim.x = x_full(keep, :);
sim.T = T;
sim.params = params;
sim.clinical = clinical;
sim.solver_options = solver_options;
sim.init_mode = 'TBV_UBV';
end
