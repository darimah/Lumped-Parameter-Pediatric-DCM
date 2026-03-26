Tambahkan file-file ini ke proyekmu:

optimization/struct_to_vector.m
optimization/vector_to_struct.m
optimization/bounds_struct_to_vectors.m
optimization/objective_map_co_vector.m
optimization/objective_diameter_vector.m
optimization/fit_patient_patternsearch_refined.m
tests/test_patient01_patternsearch.m

Cara pakai:
cd DCM_MATLAB_Project_v2
addpath(genpath(pwd))
run(fullfile('tests','test_patient01_patternsearch.m'))

Atau:
opts = struct();
results = fit_patient_patternsearch_refined(1, opts);

Catatan:
- Patch ini memakai patternsearch SETELAH warm-start dari direct search + refined bounds
- Jadi file lama tetap dipakai
- Butuh Global Optimization Toolbox
