function params = default_parameters(model_id)
if nargin < 1
    model_id = 1;
end

params = struct();

params.V0_la   = 3.0;
params.V0_ra   = 3.0;
params.Emax_la = 0.4;
params.Emin_la = 0.2;
params.Emax_ra = 0.4;
params.Emin_ra = 0.2;
params.atrial_delay_la = 0.0375;
params.atrial_delay_ra = 0.0375;

params.Rmv_f = 0.002; params.Rmv_b = 1.0e16;
params.Rav_f = 0.002; params.Rav_b = 1.0e16;
params.Rtv_f = 0.001; params.Rtv_b = 1.0e16;
params.Rpv_f = 0.001; params.Rpv_b = 1.0e16;

params.Lao = 1.0e-5;
params.Las = 1.0e-5;
params.Lpo = 1.0e-5;
params.Lap = 1.0e-5;

switch model_id
    case 1
        params.Ees_lv = 2.480; params.Ees_rv = 1.490;
        params.V0_lv  = 7.450; params.V0_rv  = 7.450;
        params.Alv    = 1.104; params.Arv    = 1.104;
        params.Blv    = 0.025; params.Brv    = 0.025;
        params.Rao    = 0.048; params.Cao    = 0.222;
        params.Ras    = 0.794; params.Cas    = 0.578;
        params.Rvs    = 0.048; params.Cvs    = 13.800;
        params.Rpo    = 0.009; params.Cpo    = 1.946;
        params.Rap    = 0.148; params.Cap    = 0.078;
        params.Rvp    = 0.048; params.Cvp    = 13.800;
        params.Vblood = 638;
        params.Klv    = 1.30;  params.Krv    = 1.68;
    case 2
        params.Ees_lv = 1.150; params.Ees_rv = 1.040;
        params.V0_lv  = 14.500; params.V0_rv  = 19.500;
        params.Alv    = 1.080; params.Arv    = 1.080;
        params.Blv    = 0.022; params.Brv    = 0.022;
        params.Rao    = 0.135; params.Cao    = 0.203;
        params.Ras    = 1.050; params.Cas    = 0.975;
        params.Rvs    = 0.044; params.Cvs    = 14.400;
        params.Rpo    = 0.009; params.Cpo    = 0.900;
        params.Rap    = 0.144; params.Cap    = 0.118;
        params.Rvp    = 0.044; params.Cvp    = 14.400;
        params.Vblood = 595;
        params.Klv    = 1.38;  params.Krv    = 1.20;
    case 3
        params.Ees_lv = 2.440; params.Ees_rv = 0.338;
        params.V0_lv  = 3.400; params.V0_rv  = 27.000;
        params.Alv    = 1.264; params.Arv    = 0.694;
        params.Blv    = 0.027; params.Brv    = 0.017;
        params.Rao    = 0.180; params.Cao    = 0.168;
        params.Ras    = 1.510; params.Cas    = 0.456;
        params.Rvs    = 0.044; params.Cvs    = 6.700;
        params.Rpo    = 0.044; params.Cpo    = 1.340;
        params.Rap    = 0.576; params.Cap    = 0.406;
        params.Rvp    = 0.044; params.Cvp    = 8.400;
        params.Vblood = 584;
        params.Klv    = 1.70;  params.Krv    = 0.90;
        params.Rtv_b  = 0.55;
        params.Rpv_b  = 3.5;
    otherwise
        error('model_id must be 1, 2, or 3');
end
end
