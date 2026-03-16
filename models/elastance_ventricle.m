function e_t = elastance_ventricle(tau, T)
T1 = 0.33*T; T2 = 0.45*T;
if tau < T1
    e_t = (1 - cos(pi * tau / T1)) / 2;
elseif tau < T2
    e_t = (1 + cos(pi * (tau - T1) / (T2 - T1))) / 2;
else
    e_t = 0;
end
end
