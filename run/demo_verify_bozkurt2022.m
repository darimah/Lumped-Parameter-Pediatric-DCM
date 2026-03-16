
clear
clc

addpath('../src')

pt.HR=101;
pt.LVEDV=100;
pt.RVEDV=83;

p.Ees_lv=2.4;
p.Ees_rv=1.5;
p.V0_lv=7;
p.V0_rv=7;

p.Alv=1.1;
p.Arv=1.1;
p.Blv=0.025;
p.Brv=0.025;

p.Rao=0.05; p.Cao=0.22;
p.Ras=0.8; p.Cas=0.6;
p.Rvs=0.05; p.Cvs=14;

p.Rpo=0.01; p.Cpo=1.9;
p.Rap=0.15; p.Cap=0.08;
p.Rvp=0.05; p.Cvp=14;

p.Lao=1e-5; p.Las=1e-5;
p.Lpo=1e-5; p.Lap=1e-5;

p.Rmv=0.002;
p.Rav=0.002;
p.Rtv=0.001;
p.Rpv=0.001;

p.Ela=0.3;
p.Era=0.3;

p.V0_la=3;
p.V0_ra=3;

sim=simulate_patient(pt,p);
m=metrics(sim)

plot(sim.t,sim.x(:,5))
title('Aortic pressure')
xlabel('time')
ylabel('mmHg')
