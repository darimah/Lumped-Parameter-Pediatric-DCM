V3 patch introduces an explicit venous-reservoir interpretation of UBV.

Files to copy into your project:
- models/system_rhs_v3.m
- solvers/build_initial_state_v3.m
- solvers/integrate_system_v3.m
- utils/build_state_index_v3.m
- utils/compute_clinical_indices_v3.m
- optimization/objective_map_co_v3.m
- optimization/objective_map_co_v3_vector.m
- optimization/fit_patient_patternsearch_v3.m
- tests/test_patient01_v3_ubv_range.m

This patch is parallel to your old workflow and does not overwrite it.
