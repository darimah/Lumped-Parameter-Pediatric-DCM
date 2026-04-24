function [bounds_x, bounds_k] = get_parameter_bounds(model_id)
mk = @(lb, ub) struct('lb', lb, 'ub', ub);
bounds_x = struct(); bounds_k = struct();

switch model_id
    case 1
        bounds_x.Ees_lv = mk(1.5, 3.5); bounds_x.Ees_rv = mk(1.0, 2.0);
        bounds_x.V0_lv  = mk(5, 10);    bounds_x.V0_rv  = mk(5, 10);
        bounds_x.Alv    = mk(0.9, 1.3); bounds_x.Arv    = mk(0.9, 1.3);
        bounds_x.Blv    = mk(0.02, 0.03); bounds_x.Brv = mk(0.02, 0.03);
        bounds_x.Rao    = mk(0.038, 0.058); bounds_x.Cao = mk(0.173, 0.273);
        bounds_x.Ras    = mk(0.5, 1.1); bounds_x.Cas = mk(0.333, 0.833);
        bounds_x.Rvs    = mk(0.038, 0.058); bounds_x.Cvs = mk(11.35, 16.35);
        bounds_x.Rpo    = mk(0.007, 0.012); bounds_x.Cpo = mk(1.333, 2.583);
        bounds_x.Rap    = mk(0.138, 0.158); bounds_x.Cap = mk(0.053, 0.103);
        bounds_x.Rvp    = mk(0.038, 0.058); bounds_x.Cvp = mk(11.35, 16.35);
        bounds_x.Vblood = mk(550, 750);
        bounds_k.Klv = mk(1.0, 2.0); bounds_k.Krv = mk(1.5, 4.5);
    case 2
        bounds_x.Ees_lv = mk(0.5, 2.8); 
        bounds_x.Ees_rv = mk(0.4, 1.8);
    
        bounds_x.V0_lv  = mk(5, 35);   
        bounds_x.V0_rv  = mk(10, 40);
    
        bounds_x.Alv    = mk(0.6, 1.4); 
        bounds_x.Arv    = mk(0.6, 1.3);
    
        bounds_x.Blv    = mk(0.010, 0.035); 
        bounds_x.Brv    = mk(0.010, 0.030);
    
        bounds_x.Rao    = mk(0.05, 0.25); 
        bounds_x.Cao    = mk(0.10, 0.35);
    
        bounds_x.Ras    = mk(0.6, 2.0); 
        bounds_x.Cas    = mk(0.20, 1.80);
    
        bounds_x.Rvs    = mk(0.02, 0.08); 
        bounds_x.Cvs    = mk(8, 24);
    
        bounds_x.Rpo    = mk(0.005, 0.05); 
        bounds_x.Cpo    = mk(0.4, 2.5);
    
        bounds_x.Rap    = mk(0.08, 0.8); 
        bounds_x.Cap    = mk(0.05, 0.6);
    
        bounds_x.Rvp    = mk(0.02, 0.10); 
        bounds_x.Cvp    = mk(8, 24);
    
        bounds_x.Vblood = mk(450, 900);
    
        bounds_k.Klv = mk(0.8, 2.4); 
        bounds_k.Krv = mk(0.8, 3.5);
    case 3
        bounds_x.Ees_lv = mk(1.25, 4.75); bounds_x.Ees_rv = mk(0.1, 0.8);
        bounds_x.V0_lv  = mk(0, 10);      bounds_x.V0_rv  = mk(10, 60);
        bounds_x.Alv    = mk(1.0, 1.4);   bounds_x.Arv    = mk(0.1, 1.0);
        bounds_x.Blv    = mk(0.02, 0.03); bounds_x.Brv    = mk(0.01, 0.02);
        bounds_x.Rao    = mk(0.01, 0.51); bounds_x.Cao = mk(0.1, 0.3);
        bounds_x.Ras    = mk(1.0, 2.5);   bounds_x.Cas = mk(0.2, 1.0);
        bounds_x.Rvs    = mk(0.01, 0.11); bounds_x.Cvs = mk(5, 10);
        bounds_x.Rpo    = mk(0.01, 0.11); bounds_x.Cpo = mk(1, 2);
        bounds_x.Rap    = mk(0.1, 1.5);   bounds_x.Cap = mk(0.1, 1.0);
        bounds_x.Rvp    = mk(0.01, 0.11); bounds_x.Cvp = mk(5, 15);
        bounds_x.Vblood = mk(550, 650);
        bounds_k.Klv = mk(1.0, 2.0); bounds_k.Krv = mk(0.5, 2.5);
    otherwise
        error('model_id must be 1, 2, or 3');
end
end
