function J = objective_rv_diameter_v2_vector(x, base_params, parameter_names, clinical)
params = vector_to_struct(base_params, parameter_names, x);
[J, ~] = objective_rv_diameter_v2(params, clinical);
end
