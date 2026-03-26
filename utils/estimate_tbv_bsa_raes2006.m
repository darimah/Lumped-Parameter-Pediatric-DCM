function tbv_ml = estimate_tbv_bsa_raes2006(BSA_m2, sex_char)
sex_char = upper(string(sex_char));
if sex_char == "M"
    tbv_ml = 2836.2 * BSA_m2 - 669.2;
elseif sex_char == "F"
    tbv_ml = 2846.9 * BSA_m2 - 715.0;
else
    error('sex_char must be M or F');
end
end
