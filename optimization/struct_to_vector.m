function [x, names] = struct_to_vector(param_struct, parameter_names)
if nargin < 2 || isempty(parameter_names)
    names = fieldnames(param_struct);
else
    names = parameter_names;
end
x = zeros(numel(names), 1);
for k = 1:numel(names)
    x(k) = param_struct.(names{k});
end
end
