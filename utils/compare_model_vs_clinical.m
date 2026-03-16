function comparison = compare_model_vs_clinical(metrics, clinical)
comparison = struct();
comparison.relerr.MAP      = (clinical.MAP      - metrics.MAP)      / clinical.MAP;
comparison.relerr.CO       = (clinical.CO       - metrics.CO)       / clinical.CO;
comparison.relerr.Pao_sys  = (clinical.Pao_sys  - metrics.Pao_sys)  / clinical.Pao_sys;
comparison.relerr.Pao_dias = (clinical.Pao_dias - metrics.Pao_dias) / clinical.Pao_dias;
comparison.relerr.V_lv_ed  = (clinical.V_lv_ed  - metrics.V_lv_ed)  / clinical.V_lv_ed;
comparison.relerr.V_lv_es  = (clinical.V_lv_es  - metrics.V_lv_es)  / clinical.V_lv_es;
comparison.relerr.V_rv_ed  = (clinical.V_rv_ed  - metrics.V_rv_ed)  / clinical.V_rv_ed;
comparison.relerr.V_rv_es  = (clinical.V_rv_es  - metrics.V_rv_es)  / clinical.V_rv_es;
comparison.relerr.D_lv_ed  = (clinical.D_lv_ed  - metrics.D_lv_ed)  / clinical.D_lv_ed;
comparison.relerr.D_lv_es  = (clinical.D_lv_es  - metrics.D_lv_es)  / clinical.D_lv_es;
comparison.relerr.D_rv_ed  = (clinical.D_rv_ed  - metrics.D_rv_ed)  / clinical.D_rv_ed;
comparison.relerr.D_rv_es  = (clinical.D_rv_es  - metrics.D_rv_es)  / clinical.D_rv_es;
disp('--- Relative Errors ---');
disp(comparison.relerr);
end
