function clinical = bozkurt2022_patient01_clinical()
clinical = struct();
clinical.id = 1; clinical.model_id = 1; clinical.label = 'Bozkurt2022_Patient01';
clinical.HR = 101;
clinical.l_lv = (5.9 + 7.1)/2; clinical.l_rv = (5.1 + 6.5)/2;
clinical.MAP = 76.3; clinical.CO = 5.3;
clinical.Pao_sys = 109; clinical.Pao_dias = 60;
clinical.V_lv_es = 48; clinical.V_lv_ed = 100;
clinical.V_rv_es = 26; clinical.V_rv_ed = 83;
clinical.D_lv_es = 3.4; clinical.D_lv_ed = 4.6;
clinical.D_rv_es = 1.7; clinical.D_rv_ed = 2.7;
end
