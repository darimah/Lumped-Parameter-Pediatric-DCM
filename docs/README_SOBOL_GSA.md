Bozkurt Sobol GSA Patch
======================

Purpose
-------
Run Sobol Global Sensitivity Analysis (Saltelli scheme) on the final Bozkurt model.

What this patch assumes
-----------------------
Your current project already contains the final Bozkurt pipeline we built in chat, including:
- get_clinical_patient
- default_parameters
- get_parameter_bounds
- fit_patient_patternsearch_v2_final
- integrate_system
- compute_clinical_indices

What this patch does
--------------------
- Uses ALL Bozkurt parameters:
  x (21 parameters) + k (2 parameters) = 23 total
- Uses the SAME bounds as your model
- Uses Sobol/Saltelli with N = 64 and 128 as base sample sizes
- Evaluates ALL major outputs:
  MAP, CO, Pao_sys, Pao_dias,
  V_lv_ed, V_lv_es, V_rv_ed, V_rv_es,
  EF_lv, EF_rv,
  D_lv_ed, D_lv_es, D_rv_ed, D_rv_es

Expected evaluation counts
--------------------------
For D parameters, Saltelli requires:
    N * (D + 2)

For D = 23:
- N = 64  -> 1600 model evaluations
- N = 128 -> 3200 model evaluations

Files to add
------------
src/get_bozkurt_parameter_space.m
src/evaluate_bozkurt_outputs.m
src/generate_sobol_ab.m
src/scale_unit_to_bounds.m
src/sobol_saltelli_indices.m
src/run_bozkurt_sobol_once.m
run/run_bozkurt_sobol_gsa.m

How to run
----------
From project root:
    cd DCM_MATLAB_Project
    addpath(genpath(pwd))
    run(fullfile('run','run_bozkurt_sobol_gsa.m'))

Outputs
-------
Saved into /results:
- bozkurt_sobol_patient01_N64.mat
- bozkurt_sobol_patient01_N128.mat
- per-output CSV ranking tables for each N

Interpretation
--------------
S1 = first-order Sobol index
ST = total-order Sobol index

Large ST means the parameter is influential for that output.
Large difference between ST and S1 suggests strong interactions.
