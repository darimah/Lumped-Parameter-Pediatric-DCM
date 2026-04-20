function clinical = get_clinical_patient(patient_id)
switch patient_id
    case 1, clinical = bozkurt2022_patient01_clinical();
    case 2, clinical = bozkurt2022_patient02_clinical();
    case 3, clinical = bozkurt2022_patient03_clinical();
    case 4, clinical = patient04_clinical();
    case 5, clinical = patient05_clinical();
    case 6, clinical = patient06_clinical();
    case 7, clinical = patient07_clinical();
    otherwise, error('patient_id must be 1, 2, or 3');
end
end
