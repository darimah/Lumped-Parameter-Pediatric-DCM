function E_at = elastance_atrium(tau, T, Emin, Emax, T_atrial, delay)
tau_shifted = tau - delay;
if tau_shifted < 0
    tau_shifted = tau_shifted + T;
end

if tau_shifted < T_atrial
    f = 0;
else
    f = 1 - cos(2*pi*(tau_shifted - T_atrial)/(T - T_atrial));
end

E_at = Emin + 0.5 * (Emax - Emin) * f;
end
