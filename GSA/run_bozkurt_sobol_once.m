function result = run_bozkurt_sobol_once(patient_id, N, use_final_stage1)
% RUN_BOZKURT_SOBOL_ONCE
% One complete Sobol GSA run for a given patient and base sample size N.
%
% Uses all Bozkurt parameters and all main model outputs.

if nargin < 1
    patient_id = 1;
end
if nargin < 2
    N = 64;
end
if nargin < 3
    use_final_stage1 = true;
end

pspace = get_bozkurt_parameter_space(patient_id, use_final_stage1);
D = numel(pspace.names);

fprintf('\n=== Sobol GSA | patient %d | N = %d | D = %d ===\n', patient_id, N, D);
fprintf('Planned model evaluations (Saltelli): %d\n', N * (D + 2));

[A_u, B_u] = generate_sobol_ab(N, D, 123);
A = scale_unit_to_bounds(A_u, pspace.lb, pspace.ub);
B = scale_unit_to_bounds(B_u, pspace.lb, pspace.ub);

% Evaluate A and B first
[yA1, y_names, ~] = evaluate_bozkurt_outputs(A(1,:)', pspace.names, patient_id);
M = numel(yA1);

YA = nan(N, M);
YB = nan(N, M);
YAB = nan(N, D, M);

tic;
for r = 1:N
    try
        [YA(r,:), y_names] = i_eval_row(A(r,:), pspace.names, patient_id);
    catch
        YA(r,:) = nan(1,M);
    end
    try
        [YB(r,:), ~] = i_eval_row(B(r,:), pspace.names, patient_id);
    catch
        YB(r,:) = nan(1,M);
    end
end

for i = 1:D
    fprintf('Mixed matrix %d / %d : %s\n', i, D, pspace.names{i});
    ABi = A;
    ABi(:, i) = B(:, i);

    for r = 1:N
        try
            [YAB(r,i,:), ~] = i_eval_row(ABi(r,:), pspace.names, patient_id);
        catch
            YAB(r,i,:) = nan(1,1,M);
        end
    end
end
elapsed_sec = toc;

S1 = nan(D, M);
ST = nan(D, M);
valid_counts = nan(1, M);
varY = nan(1, M);

for m = 1:M
    stats = sobol_saltelli_indices(YA(:,m), YB(:,m), squeeze(YAB(:,:,m)));
    S1(:,m) = stats.S1;
    ST(:,m) = stats.ST;
    valid_counts(m) = stats.N_valid;
    varY(m) = stats.varY;
end

result = struct();
result.patient_id = patient_id;
result.N = N;
result.D = D;
result.param_names = pspace.names;
result.output_names = y_names;
result.lb = pspace.lb;
result.ub = pspace.ub;
result.base_vec = pspace.base_vec;
result.S1 = S1;
result.ST = ST;
result.valid_counts = valid_counts;
result.varY = varY;
result.elapsed_sec = elapsed_sec;
result.total_evaluations = N * (D + 2);

% rank parameters for each output by ST
rankings = struct();
for m = 1:M
    [st_sorted, idx] = sort(ST(:,m), 'descend');
    rankings.(y_names{m}) = table(pspace.names(idx), st_sorted, S1(idx,m), ...
        'VariableNames', {'Parameter','ST','S1'});
end
result.rankings = rankings;

fprintf('Elapsed time: %.1f sec (%.2f min)\n', elapsed_sec, elapsed_sec/60);

end

function [y_row, y_names] = i_eval_row(row_vec, param_names, patient_id)
[y_col, y_names] = evaluate_bozkurt_outputs(row_vec(:), param_names, patient_id);
y_row = y_col(:).';
end
