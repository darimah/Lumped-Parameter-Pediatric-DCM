function Q = valve_flow(P_up, P_down, R_forward, R_backward)
dP = P_up - P_down;
if dP >= 0
    Q = dP / R_forward;
else
    Q = dP / R_backward;
end
end
