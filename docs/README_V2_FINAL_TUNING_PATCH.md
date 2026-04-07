This patch adds focused final tuning for the best v2 workflow.

Files to copy into your project:
- optimization/objective_rv_v2.m
- optimization/objective_rv_v2_vector.m
- optimization/objective_rv_diameter_v2.m
- optimization/objective_rv_diameter_v2_vector.m
- optimization/fit_patient_patternsearch_v2_final.m
- tests/test_patient01_v2_final_tuning.m

What it does:
Stage 0:
- uses fit_patient_patternsearch_refined as warm start

Stage 1 tunes:
- Ees_rv
- V0_rv
- Rpo
- Cpo
- Rap
- Cap
- Rvp
- Cvp

Objective:
- Pao_dias
- V_rv_ed
- V_rv_es

Stage 2 tunes:
- Krv

Objective:
- D_rv_ed
- D_rv_es
