function param_struct = vector_to_struct(param_struct, parameter_names, x)
for k = 1:numel(parameter_names)
    param_struct.(parameter_names{k}) = x(k);
end
end
