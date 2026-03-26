This patch adds a parallel TBV/UBV workflow.

Copy these files into your project:
- utils/estimate_tbv_bsa_raes2006.m
- utils/add_tbv_ubv_to_clinical.m
- solvers/build_initial_state_tbv.m
- solvers/integrate_system_tbv.m
- optimization/objective_map_co_tbv.m
- optimization/objective_diameter_tbv.m
- optimization/objective_map_co_tbv_vector.m
- optimization/objective_diameter_tbv_vector.m
- optimization/fit_patient_patternsearch_refined_tbv.m
- tests/test_patient01_tbv_ubv_bsa.m

What it does:
1) estimates TBV from BSA + sex
2) sets UBV = 70% TBV
3) uses stressed volume to build venous/atrial/ventricular/arterial initial conditions
4) runs patternsearch using the TBV/UBV-aware solver

This is a first-pass implementation:
- TBV/UBV are active through initial conditions
- the ODE system itself is not yet rewritten as an explicit venous reservoir model
