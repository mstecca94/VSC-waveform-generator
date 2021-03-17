function [ Wave ] = FEMM_set_up ( Wave )
Core.Opt.Plot = 1;  % Plot Waveforms     
Core.Opt.DropPerm = 1;  % Considers Drop in Permability    
Core.Number_of_Harmonics = 20; % Number of Harmonics to Be Analyzed.
Core.Wav.waveform(:,1) = Wave.Input.t;

% grid side
Core.Wav.waveform(:,2) = Wave.Current.i_grid_side ;      
Core.sigma = Wave.Inductor.Lg_Design.Wire_Sigma ; % Core.Wire.sigma;
Core.n_strand = Wave.Inductor.Lg_Design.Wire_n_strand ; % Core.Wire.n_strand;
Core.d_strand = Wave.Inductor.Lg_Design.Wire_d_strand; % Core.Wire.d_strand;
Core.d_wire = Wave.Inductor.Lg_Design.Wire_Diameter ; % Core.Wire.d_wire;
Core.OD = Wave.Inductor.Lg_Design.Core_OD ;
Core.ID = Wave.Inductor.Lg_Design.Core_ID ;
Core.HT = Wave.Inductor.Lg_Design.Core_HT ;

Core.e = Wave.Inductor.Lg_Design.Core_e ;
Core.d_ISO = Wave.Inductor.Lg_Design.Wire_d_ISO ;
Core.N = Wave.Inductor.Lg_Design.Core_N ;
Core.Turn_Length = Wave.Inductor.Lg_Design.Core_Wire_Turn_Length ;
Core.Winding.RoundWire_Stranded = Wave.Inductor.Lg_Design.Core_RoundWire_Stranded ;
Core.Winding.RoundWire_Solid = Wave.Inductor.Lg_Design.Core_RoundWire_Solid ;
Core.CondMat = 'CU' ;
if Core.Opt.DropPerm ==1
    Core.mu_FE=Wave.Inductor.Lg_Design.Core_mir_peak;
else
    Core.mu_FE=Wave.Inductor.Lg_Design.Core_InitPerm;
end 
     
[ Core ] = FEMM_Analysis( Core );
Wave.Inductor.Lg_Design.PwdgFEMM = Core.Pw_FEMM;
Wave.Inductor.Lg_Design.P_FEM = Core.P_FEM;
Wave.Inductor.Lg_Design.L_IpeakFEMM = Core.L_FEMM(1,1);
Wave.Inductor.Lg_Design.MLT_FEMM = Core.MLT;
Wave.Inductor.Lg_Design.Res_acBydc_FEMM = Core.Res_acBydc;
Wave.Inductor.Lg_Design.Total_Loss_FEMM = Wave.Inductor.Lg_Design.Core_Loss +...
    Wave.Inductor.Lg_Design.PwdgFEMM + Wave.Inductor.Lg_Design.Wire_Pprox ;

clear Core
%%        
Core.Opt.Plot = 1;  % Plot Waveforms     
Core.Opt.DropPerm = 1;  % Considers Drop in Permability    
Core.Number_of_Harmonics = 20; % Number of Harmonics to Be Analyzed.
Core.Wav.waveform(:,1) = Wave.Input.t;
% converter side
Core.Wav.waveform(:,2) = Wave.Current.i_converter_side ;      
Core.sigma = Wave.Inductor.Lc_Design.Wire_Sigma ; % Core.Wire.sigma;
Core.n_strand = Wave.Inductor.Lc_Design.Wire_n_strand ; % Core.Wire.n_strand;
Core.d_strand = Wave.Inductor.Lc_Design.Wire_d_strand; % Core.Wire.d_strand;
Core.d_wire = Wave.Inductor.Lc_Design.Wire_Diameter ; % Core.Wire.d_wire;
Core.OD = Wave.Inductor.Lc_Design.Core_OD ;
Core.ID = Wave.Inductor.Lc_Design.Core_ID ;
Core.HT = Wave.Inductor.Lc_Design.Core_HT ;
Core.e = Wave.Inductor.Lc_Design.Core_e ;
Core.d_ISO = Wave.Inductor.Lc_Design.Wire_d_ISO ;
Core.N = Wave.Inductor.Lc_Design.Core_N ;
Core.Turn_Length = Wave.Inductor.Lc_Design.Core_Wire_Turn_Length ;
Core.Winding.RoundWire_Stranded = Wave.Inductor.Lc_Design.Core_RoundWire_Stranded ;
Core.Winding.RoundWire_Solid = Wave.Inductor.Lc_Design.Core_RoundWire_Solid ;
Core.CondMat = Wave.Inductor.Lc_Design.Core_CondMat ;

%         Core.d_wire = 0.021 ; % Core.Wire.d_wire;

if Core.Opt.DropPerm ==1
    Core.mu_FE=Wave.Inductor.Lc_Design.Core_mir_peak;
else
    Core.mu_FE=Wave.Inductor.Lc_Design.Core_InitPerm;
end 

[ Core ] = FEMM_Analysis( Core );
Wave.Inductor.Lc_Design.PwdgFEMM = Core.Pw_FEMM;
Wave.Inductor.Lc_Design.P_FEM = Core.P_FEM;
Wave.Inductor.Lc_Design.L_IpeakFEMM = Core.L_FEMM(1,1);
Wave.Inductor.Lc_Design.MLT_FEMM = Core.MLT;
Wave.Inductor.Lc_Design.Res_acBydc_FEMM = Core.Res_acBydc;
Wave.Inductor.Lc_Design.Total_Loss_FEMM = Wave.Inductor.Lc_Design.Core_Loss +...
    Wave.Inductor.Lc_Design.PwdgFEMM + Wave.Inductor.Lc_Design.Wire_Pprox ;

    
Wave.Inductor.FilterLosses_noFEMM = Wave.Inductor.FilterLosses ;     
Wave.Inductor.FilterEfficiency_noFEMM = Wave.Inductor.FilterEfficiency ;   

Wave.Inductor.FilterLosses = 3*(Wave.Inductor.Lc_Design.Total_Loss_FEMM...
     + Wave.Inductor.Lg_Design.Total_Loss_FEMM );
Wave.Inductor.FilterEfficiency = (Wave.Input.P-Wave.Inductor.FilterLosses)/Wave.Input.P*100 ;
end
