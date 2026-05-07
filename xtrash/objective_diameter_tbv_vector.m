function J = objective_diameter_tbv_vector(x, base_params, parameter_names, clinical, solver_options)
params = vector_to_struct(base_params, parameter_names, x);
[J, ~] = objective_diameter_tbv(params, clinical, solver_options);
end
