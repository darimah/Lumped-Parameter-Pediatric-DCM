function [lb, ub, names] = bounds_struct_to_vectors(bounds_struct, parameter_names)
if nargin < 2 || isempty(parameter_names)
    names = fieldnames(bounds_struct);
else
    names = parameter_names;
end
lb = zeros(numel(names),1);
ub = zeros(numel(names),1);
for k = 1:numel(names)
    lb(k) = bounds_struct.(names{k}).lb;
    ub(k) = bounds_struct.(names{k}).ub;
end
end
