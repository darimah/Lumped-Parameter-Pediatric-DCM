function J = objective_map_co_vector(x, base_params, parameter_names, clinical)
params = vector_to_struct(base_params, parameter_names, x);
[J, ~] = objective_map_co(params, clinical);
end
