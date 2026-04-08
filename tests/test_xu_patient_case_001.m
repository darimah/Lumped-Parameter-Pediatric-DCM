clear; clc;
addpath(genpath(pwd));

clinical = xu_patient_case_001();
xu_results = xu_score_model(clinical);

assert(abs(xu_results.total_score - 19.5) < 1.0e-12, 'Unexpected Xu total score.');
assert(xu_results.is_above_score_cutoff == true, 'Case should be above Xu cutoff.');
assert(xu_results.points_age == 0.0, 'Age points should be zero for 52 months.');
assert(xu_results.points_function_class == 10.0, 'Ross IV should yield 10 points.');
assert(xu_results.points_mr == 2.5, 'MR points mismatch.');
assert(xu_results.points_low_voltage == 4.0, 'Low-voltage points mismatch.');
assert(xu_results.points_vasoactive == 3.0, 'Vasoactive points mismatch.');

print_xu_summary(clinical, xu_results);
fprintf('\nXu patient case 001 test passed.\n');
