function [A, B] = generate_sobol_ab(N, D, scramble_seed)
% GENERATE_SOBOL_AB
% Generate two Sobol base matrices A and B of size N x D each.

if nargin < 3
    scramble_seed = 123;
end

p = sobolset(D, 'Skip', 1e3, 'Leap', 1e2);
p = scramble(p, 'MatousekAffineOwen');

% reset random stream for reproducibility of scrambling effects
rng(scramble_seed, 'twister');

U = net(p, 2*N);
A = U(1:N, :);
B = U(N+1:2*N, :);
end
