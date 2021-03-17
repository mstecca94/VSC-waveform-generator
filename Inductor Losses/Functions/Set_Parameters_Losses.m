function [ Converter ] = Set_Parameters_Losses ( Wave )

%%                  General Options - User Definitions

Converter.Spec.topology = Wave.Input.Topology ;
Converter.Spec.Mod = Wave.Input.Modulation ;

% General Inputs
Converter.Spec.V_dc = Wave.Input.vdc ; 
Converter.Spec.Pmax = Wave.Input.P ;  


Converter.Spec.V_ll_rms = Wave.Input.vll ; 
Converter.Spec.Ugp =  Wave.Input.vll*sqrt(2/3); 
Converter.Spec.M = 2*Converter.Spec.Ugp/Converter.Spec.V_dc;  
Converter.Spec.f_sup = Wave.Input.fg;        
Converter.Spec.fsw_val  = Wave.Input.fs;   
Converter.Spec.L1_val  = Wave.Input.Lc ;   
Converter.Spec.Lg_val = Wave.Input.Lg ;
Converter.Spec.Cf_val  = Wave.Input.C ;
Converter.Spec.PF = cos(Wave.Input.phi) ;
Converter.Spec.PHI = Wave.Input.phi; 
Converter.Spec.Ig = Wave.Input.I ;
% Converter.Spec.vdcmin = Wave.Input.Vdcmin ;         

Converter.Spec.Lp = 1.5e-3 ;
Converter.Spec.kp = 0.9 ;
Converter.Spec.Tamb = 40 ;
Converter.Spec.Tjmax_avg = 130 ;
Converter.Spec.L1_Ivar = 3.0*Converter.Spec.Pmax/3/Converter.Spec.Ugp*[0 0.33 0.5 0.66 1.0]; % Variation of Lf as function of Current
Converter.Spec.L1_Vvar = [1.0 1.0 1.0 1.0 1.0]; % Variation of Lf as function of Current

end