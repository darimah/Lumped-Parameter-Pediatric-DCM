
MATLAB PROJECT STRUCTURE FOR DCM PATIENT-SPECIFIC MODEL

Folders:
src/
  cv_ode.m            cardiovascular equations
  activation.m        ventricular activation
  simulate_patient.m  run simulation
  metrics.m           compute MAP CO EF

run/
  demo_verify_bozkurt2022.m  example script

data/
  patients_template.csv      template for your clinical data

Workflow:
1. Edit data/patients_template.csv with patient data
2. Load data in MATLAB
3. Call simulate_patient()
4. Run parameter optimisation
