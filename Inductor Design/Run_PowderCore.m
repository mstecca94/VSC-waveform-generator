function [ Wave ] = Run_PowderCore( Wave )
%% Main Function for Inverter Design 
%  Thiago B. Soeiro
%  Last Change: 13.07.2013

%%                  General Options - User Definitions
% Plot Main Waveforms?
Yes_Plot = 1; % = 1 for yes
Core.Yes_Plot = Yes_Plot ; 

% Use FEMM for Inductor Design
Yes_LossFEMM =0;


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
%     figure;
%     subplot(2,1,1)
%     hold on
%     plot(Converter.Wav.Time,Converter.Wav.IgA)
%     plot(Converter.Wav.Time,Converter.Wav.D_iLpha)
%     plot(Converter.Wav.Time,Converter.Wav.iLA)
%     xlabel('Time [s]')
%     ylabel('Current [A]')
%     grid on
%     
%     subplot(2,1,2)
%     hold on
%     plot(Converter.Wav.Time,Converter.Wav.B_fluxA)
%     xlabel('Time [s]')
%     ylabel('Flux*N*Ae [B*m2]')
%     grid on    
%     
    [ Core , Converter , pareto ] = Basic_Ind_Design_Step_1_LF ( Converter ) ;
    
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
%     figure;
%     subplot(2,1,1)
%     hold on
%     plot(Converter.Wav.Time,Converter.Wav.IgA)
%     plot(Converter.Wav.Time,Converter.Wav.D_iLpha)
%     plot(Converter.Wav.Time,Converter.Wav.iLA)
%     xlabel('Time [s]')
%     ylabel('Current [A]')
%     grid on
%     
%     subplot(2,1,2)
%     hold on
%     plot(Converter.Wav.Time,Converter.Wav.B_fluxA)
%     xlabel('Time [s]')
%     ylabel('Flux*N*Ae [B*m2]')
%     grid on    
    
    [ Core , Converter , pareto ] = Basic_Ind_Design_Step_1_HF ( Converter ) ;
end
%%                         Adjust of Waveform Generation
% % [ Converter ] = Converter_Wav_Gen( Converter ) ;
[ Core , Converter  ] = Basic_Ind_Design_Step_2 ( Converter , Core ) ;
%%                      FEMM Setting UP
if (Yes_LossFEMM ==1) %&& (Core.BadResult==0)      
    [ Core , Converter ] = FEMM_set_up ( Core , Converter  ) ;
end

%%
if Wave.Inductor.IndToBeDesigned == 0
    Wave.Inductor.Lg.Pareto = pareto ;
    Wave.Inductor.Lg.Core = Core ;
    Wave.Inductor.Lg.Converter = Converter ;
else
    Wave.Inductor.Lc.Pareto = pareto ;
    Wave.Inductor.Lc.Core = Core ;
    Wave.Inductor.Lc.Converter = Converter ;
end

end
