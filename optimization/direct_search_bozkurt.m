function search_result = direct_search_bozkurt(clinical, params_init, bounds_struct, objective_handle, parameter_names, n_steps, n_rounds)
if nargin < 6 || isempty(n_steps), n_steps = 10; end
if nargin < 7 || isempty(n_rounds), n_rounds = 12; end

lower_bounds = zeros(numel(parameter_names), 1);
upper_bounds = zeros(numel(parameter_names), 1);
for k = 1:numel(parameter_names)
    lower_bounds(k) = bounds_struct.(parameter_names{k}).lb;
    upper_bounds(k) = bounds_struct.(parameter_names{k}).ub;
end

best_params = params_init;
[best_value, best_detail] = objective_handle(best_params, clinical);
history = [];

for round_id = 1:n_rounds
    step_sizes = (upper_bounds - lower_bounds) / n_steps;

    for step_id = 0:n_steps
        trial = best_params;
        for k = 1:numel(parameter_names)
            pname = parameter_names{k};
            if startsWith(pname, 'A') || startsWith(pname, 'B')
                trial.(pname) = upper_bounds(k) - step_sizes(k) * step_id;
            else
                trial.(pname) = lower_bounds(k) + step_sizes(k) * step_id;
            end
        end

        [fval, fdetail] = objective_handle(trial, clinical);
        history = [history; round_id, step_id, fval]; %#ok<AGROW>
        if fval < best_value
            best_value = fval;
            best_detail = fdetail;
            best_params = trial;
        end
    end

    best_vec = zeros(numel(parameter_names), 1);
    for k = 1:numel(parameter_names)
        best_vec(k) = best_params.(parameter_names{k});
    end
    lower_bounds = max(best_vec - step_sizes, lower_bounds);
    upper_bounds = min(best_vec + step_sizes, upper_bounds);
end

search_result.best_params = best_params;
search_result.best_value = best_value;
search_result.best_detail = best_detail;
search_result.history = history;
end
