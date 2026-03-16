
function m = metrics(sim)

t=sim.t;
x=sim.x;

pao=x(:,5);
Qao=x(:,6);
Vlv=x(:,2);

MAP=trapz(t,pao)/(t(end)-t(1));
CO=trapz(t,Qao)/(t(end)-t(1))*60/1000;

EDV=max(Vlv);
ESV=min(Vlv);
SV=EDV-ESV;
EF=SV/EDV*100;

m.MAP=MAP;
m.CO=CO;
m.EDV=EDV;
m.ESV=ESV;
m.EF=EF;

end
