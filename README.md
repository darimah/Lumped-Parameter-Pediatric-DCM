# DCM MATLAB Project v2

Project modular untuk replikasi dan pengembangan **patient-specific cardiovascular modelling**
berdasarkan Bozkurt 2022, Bozkurt 2019, dan format data dari protokol pasien.

## Alur cepat
1. `run(fullfile('tests','test_baseline.m'))`
2. `run(fullfile('tests','test_patient01_demo.m'))`
3. `results = fit_patient_bozkurt2022(1);`

## Folder
- `config/` data klinis + parameter default
- `models/` persamaan fisiologi inti
- `solvers/` integrator numerik
- `optimization/` objective dan direct search
- `utils/` metrik, plot, pembanding
- `tests/` demo dan sanity check
- `data/` template CSV
- `docs/` catatan teori & kamus data


## Xu clinical risk layer
Folder `clinical_risk/xu/` contains a standalone implementation of the Xu 2025
quantitative pediatric DCM scoring model. This module is intentionally kept
separate from the LPM physics so that raw clinical inputs and simulated model
outputs remain traceable and do not overwrite one another.

### Quick run
1. `run(fullfile('tests','test_xu_patient_case_001.m'))`
2. `run_xu_case(@xu_patient_case_001);`

### Current patient case used for Xu
- age at onset: 52 months
- height: 101 cm
- weight: 16.4 kg
- BSA: 0.68 m^2
- Ross class: IV
- moderate-to-severe MR: yes
- low voltage limb leads: yes
- vasoactive drugs required: yes

Expected Xu quantitative score for this case: **19.5 points**.
