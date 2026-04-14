function X = scale_unit_to_bounds(U, lb, ub)
% SCALE_UNIT_TO_BOUNDS
% Map unit hypercube samples U in [0,1] to parameter bounds [lb, ub].

X = lb(:)' + U .* (ub(:)' - lb(:)');
end
