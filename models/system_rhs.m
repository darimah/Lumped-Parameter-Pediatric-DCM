
function dx = cv_ode(t,x,pt,p)
% Cardiovascular ODE model (Bozkurt-style lumped parameter model)

Vla=x(1); Vlv=x(2); Vra=x(3); Vrv=x(4);
pao=x(5); Qao=x(6);
pas=x(7); Qas=x(8);
pvs=x(9);

ppo=x(10); Qpo=x(11);
pap=x(12); Qap=x(13);
pvp=x(14);

T=60/pt.HR;
tau=mod(t,T);

T1=0.33*T; T2=0.45*T;
fact=activation(tau,T,T1,T2);

plv=p.Ees_lv*(Vlv-p.V0_lv)*fact + p.Alv*(exp(p.Blv*Vlv)-1);
prv=p.Ees_rv*(Vrv-p.V0_rv)*fact + p.Arv*(exp(p.Brv*Vrv)-1);

pla=p.Ela*(Vla-p.V0_la);
pra=p.Era*(Vra-p.V0_ra);

Qmv=max((pla-plv)/p.Rmv,0);
Qav=max((plv-pao)/p.Rav,0);
Qtv=max((pra-prv)/p.Rtv,0);
Qpv=max((prv-ppo)/p.Rpv,0);

Qsv=(pvs-pra)/p.Rvs;
Qvp=(pvp-pla)/p.Rvp;

dVla=Qvp-Qmv;
dVlv=Qmv-Qav;
dVra=Qsv-Qtv;
dVrv=Qtv-Qpv;

dpao=(Qav-Qao)/p.Cao;
dQao=(pao-pas-p.Rao*Qao)/p.Lao;

dpas=(Qao-Qas)/p.Cas;
dQas=(pas-pvs-p.Ras*Qas)/p.Las;

dpvs=(Qas-Qsv)/p.Cvs;

dppo=(Qpv-Qpo)/p.Cpo;
dQpo=(ppo-pap-p.Rpo*Qpo)/p.Lpo;

dpap=(Qpo-Qap)/p.Cap;
dQap=(pap-pvp-p.Rap*Qap)/p.Lap;

dpvp=(Qap-Qvp)/p.Cvp;

dx=[dVla;dVlv;dVra;dVrv;dpao;dQao;dpas;dQas;dpvs;dppo;dQpo;dpap;dQap;dpvp];
end
