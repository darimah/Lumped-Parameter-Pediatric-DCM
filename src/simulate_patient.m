
function sim = simulate_patient(pt,p)

T=60/pt.HR;
tend=10*T;

x0=[30;pt.LVEDV;30;pt.RVEDV;80;0;30;0;8;15;0;12;0;8];

opts=odeset('RelTol',1e-4,'MaxStep',1e-3);
[t,x]=ode15s(@(t,x)cv_ode(t,x,pt,p),[0 tend],x0,opts);

sim.t=t;
sim.x=x;

end
