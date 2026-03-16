function plot_hemodynamics(sim, metrics)
figure('Color','w','Name',sim.clinical.label);

subplot(2,2,1);
plot(metrics.t, metrics.P_lv, 'LineWidth', 1.5); hold on;
plot(metrics.t, metrics.P_ao, 'LineWidth', 1.5);
grid on; xlabel('t (s)'); ylabel('Pressure (mmHg)');
legend('P_{lv}','P_{ao}','Location','best'); title('LV and Aortic Pressure');

subplot(2,2,2);
plot(metrics.V_lv, metrics.P_lv, 'LineWidth', 1.5); hold on;
plot(metrics.V_rv, metrics.P_rv, 'LineWidth', 1.5);
grid on; xlabel('Volume (mL)'); ylabel('Pressure (mmHg)');
legend('LV','RV','Location','best'); title('PV Loops');

subplot(2,2,3);
plot(metrics.t, metrics.D_lv, 'LineWidth', 1.5); hold on;
plot(metrics.t, metrics.D_rv, 'LineWidth', 1.5);
grid on; xlabel('t (s)'); ylabel('Diameter (cm)');
legend('D_{lv}','D_{rv}','Location','best'); title('Diameters');

subplot(2,2,4);
plot(metrics.t, metrics.P_ao, 'LineWidth', 1.5);
grid on; xlabel('t (s)'); ylabel('Pressure (mmHg)');
title(sprintf('Aortic Pressure | MAP=%.2f, CO=%.2f', metrics.MAP, metrics.CO));
end
