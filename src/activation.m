
function f = activation(t,T,T1,T2)
% Ventricular activation function (Bozkurt 2019)
if t<T1
f=(1-cos(pi*t/T1))/2;
elseif t<T2
f=(1+cos(pi*(t-T1)/(T2-T1)))/2;
else
f=0;
end
end
