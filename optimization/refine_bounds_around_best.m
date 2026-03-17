function refined_bounds = refine_bounds_around_best(best_params, base_bounds, percent_default, percent_map)
if nargin < 3 || isempty(percent_default)
    percent_default = 0.15;
end
if nargin < 4
    percent_map = struct();
end

names = fieldnames(base_bounds);
refined_bounds = struct();

for k = 1:numel(names)
    name = names{k};
    base_lb = base_bounds.(name).lb;
    base_ub = base_bounds.(name).ub;
    best_val = best_params.(name);

    if isfield(percent_map, name)
        pct = percent_map.(name);
    else
        pct = percent_default;
    end

    lb_new = max(base_lb, best_val * (1 - pct));
    ub_new = min(base_ub, best_val * (1 + pct));

    if ub_new <= lb_new
        mid = min(max(best_val, base_lb), base_ub);
        halfwidth = max(1e-6, 0.01 * max(abs(mid), 1));
        lb_new = max(base_lb, mid - halfwidth);
        ub_new = min(base_ub, mid + halfwidth);
    end

    refined_bounds.(name) = struct('lb', lb_new, 'ub', ub_new);
end
end
