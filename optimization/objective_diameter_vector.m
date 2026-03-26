function J = objective_diameter_vector(x, base_params, parameter_names, clinical)
params = vector_to_struct(base_params, parameter_names, x);
[J, ~] = objective_diameter(params, clinical);
end
