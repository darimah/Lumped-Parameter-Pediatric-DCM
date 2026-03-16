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
