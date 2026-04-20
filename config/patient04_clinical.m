function clinical = patient04_clinical()
clinical = struct();
clinical.id = 4; clinical.model_id = 4; clinical.label = 'Patient04';
clinical.HR = 80;
clinical.l_lv = (7.3 + 7.7)/2; clinical.l_rv = (7.1 + 7.3)/2;
clinical.MAP = 82.0; clinical.CO = 2.6;
clinical.Pao_sys = 118; clinical.Pao_dias = 64;
clinical.V_lv_es = 45; clinical.V_lv_ed = 74;
clinical.V_rv_es = 134; clinical.V_rv_ed = 183;
clinical.D_lv_es = 2.7; clinical.D_lv_ed = 3.5;
clinical.D_rv_es = 4.8; clinical.D_rv_ed = 5.1;
end
