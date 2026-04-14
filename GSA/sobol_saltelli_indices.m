function stats = sobol_saltelli_indices(YA, YB, YABi)
% SOBOL_SALTELLI_INDICES
% Compute first-order and total-order Sobol indices using Saltelli estimators.
%
% INPUTS
%   YA   : N x 1 output from matrix A
%   YB   : N x 1 output from matrix B
%   YABi : N x D output from mixed matrices AB_i
%
% OUTPUT
%   stats.S1
%   stats.ST
%   stats.varY
%   stats.N_valid

% Keep only rows where all evaluations are finite
mask = isfinite(YA) & isfinite(YB) & all(isfinite(YABi), 2);
YA = YA(mask);
YB = YB(mask);
YABi = YABi(mask, :);

N = numel(YA);
D = size(YABi, 2);

if N < 8
    error('Too few valid model evaluations remain to estimate Sobol indices.');
end

Y = [YA; YB];
varY = var(Y, 1);

if varY <= 0
    S1 = nan(D,1);
    ST = nan(D,1);
else
    S1 = zeros(D,1);
    ST = zeros(D,1);
    for i = 1:D
        % Saltelli 2010 style estimators
        S1(i) = mean(YB .* (YABi(:,i) - YA)) / varY;
        ST(i) = 0.5 * mean((YA - YABi(:,i)).^2) / varY;
    end
end

stats = struct();
stats.S1 = S1;
stats.ST = ST;
stats.varY = varY;
stats.N_valid = N;
end
