function [ Wave ] = Run_PowderCore_Losses( Wave )
%% Main Function for Inverter Design 
%  Thiago B. Soeiro
%  Last Change: 13.07.2013

%%                  General Options - User Definitions
[ Converter ] = Set_Parameters ( Wave ) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    Basic Design Converter Side Inductor
Converter.Wav.thetaA = Wave.Input.t/0.02*pi ;
Converter.Wav.thetaA(Converter.Wav.thetaA(:)>pi)=Converter.Wav.thetaA(Converter.Wav.thetaA(:)>pi)-2*pi;
Converter.Wav.Time = Wave.Input.t ;

% grid side
if Wave.Inductor.IndToBeDesigned == 0
    Converter.Wav.IgA = Wave.Current.i_grid_side ;
    Converter.Wav.D_iLpha = Wave.Current.i_grid_side - Wave.Current.i_grid_side ; % i put this and not the envelop to solve the 3/4 wire issue
    Converter.Wav.iLA = Wave.Current.i_grid_side ;
    for m=1:size(Wave.Current.i_50Hz_a,2)
        IxA = Wave.Current.i_50Hz_a(m);
        Lf_a = Converter.Spec.Lg_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxA);                            
        B_fluxA(m) = Lf_a * IxA ; %Later need to be divided by (N*Ae)          
    end
    Converter.Wav.B_fluxA = B_fluxA;
    Converter.Spec.Inductor.Core.CoreType = Wave.Inductor.Lg_Design.CoreType ;
    Converter.Spec.Inductor.Core.MaterialType =Wave.Inductor.Lg_Design.MaterialType ;
    Converter.Spec.Inductor.Wire.CondMat= Wave.Inductor.Lg_Design.Wire_Material ;
    [ Core ] = extract_selected_design_data ( Wave ) ;
    [ Core , Converter , pareto ] = Basic_Ind_Design_Step_1_Losses ( Converter , Core ) ;
    
% converter side
else
    Converter.Wav.IgA = Wave.Current.i_grid_side ;
    Converter.Wav.D_iLpha = Wave.Current.i_converter_side - Wave.Current.i_grid_side ; % i put this and not the envelop to solve the 3/4 wire issue
    Converter.Wav.iLA = Wave.Current.i_converter_side ;
    for m=1:size(Wave.Current.i_converter_side,2)
        IxA = Wave.Current.i_converter_side(m);
        Lf_a = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxA);                            
        B_fluxA(m) = Lf_a * IxA ; %Later need to be divided by (N*Ae)
    end
    Converter.Wav.B_fluxA = B_fluxA;
    Converter.Spec.Inductor.Core.CoreType = Wave.Inductor.Lc_Design.CoreType ;
    Converter.Spec.Inductor.Core.MaterialType = Wave.Inductor.Lc_Design.MaterialType ;
    Converter.Spec.Inductor.Wire.CondMat= Wave.Inductor.Lc_Design.Wire_Material ;
    [ Core ] = extract_selected_design_data ( Wave ) ;
    [ Core , Converter , pareto ] = Basic_Ind_Design_Step_1_Losses ( Converter , Core ) ;
end
%%                         Adjust of Waveform Generation
% % [ Converter ] = Converter_Wav_Gen( Converter ) ;
[ Core , Converter  ] = Basic_Ind_Design_Step_2 ( Converter , Core ) ;

%%
if Wave.Inductor.IndToBeDesigned == 0
    Wave.Inductor.Lg_Routine.Pareto = pareto ;
    Wave.Inductor.Lg_Routine.Core = Core ;
    Wave.Inductor.Lg_Routine.Converter = Converter ;
else
    Wave.Inductor.Lc_Routine.Pareto = pareto ;
    Wave.Inductor.Lc_Routine.Core = Core ;
    Wave.Inductor.Lc_Routine.Converter = Converter ;
end

end