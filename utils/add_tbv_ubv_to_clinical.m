function clinical = add_tbv_ubv_to_clinical(clinical, BSA_m2, sex_char, ubv_fraction)
if nargin < 4 || isempty(ubv_fraction)
    ubv_fraction = 0.70;
end
clinical.BSA = BSA_m2;
clinical.sex = upper(string(sex_char));
clinical.TBV_ml = estimate_tbv_bsa_raes2006(BSA_m2, sex_char);
clinical.UBV_ml = ubv_fraction * clinical.TBV_ml;
clinical.SBV_ml = clinical.TBV_ml - clinical.UBV_ml;
end
