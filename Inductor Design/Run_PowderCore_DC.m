function [ Inductor_Results ] = Run_PowderCore_DC( Design )
%% Main Function for Inverter Design 
%  Thiago B. Soeiro
%  Last Change: 13.07.2013

%%                  General Options - User Definitions
% Plot Main Waveforms?
Yes_Plot = 0; % = 1 for yes

Core.Yes_Plot = Yes_Plot ; 
% Basic Inductor Design?
Yes_Ind_Design =1;
% Use FEMM for Inductor Design
Yes_LossFEMM =0;

Design.Parameters.L1_val = Design.Parameters.Ldc ;   

[ Design , Converter ] = Set_Parameters ( Design ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                       START of Waveform Generation

[ Converter ] = Converter_Wav_Gen_DC( Converter );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
if (Yes_Ind_Design==1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                  Basic Design Converter Side Inductor

    [ Core , Converter , pareto ] = Basic_Ind_Design_Step_1_LF ( Converter ) ;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [ Core , Converter  ] = Basic_Ind_Design_Step_2 ( Converter , Core ) ;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                      FEMM Setting UP
    if (Yes_LossFEMM ==1) %&& (Core.BadResult==0)
        
        [ Core , Converter ] = FEMM_set_up ( Core , Converter  ) ;
        
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 
Inductor_Results.Pareto = pareto ;
Inductor_Results.Core = Core ;
Inductor_Results.Converter = Converter ;
Inductor_Results.Design = Design ;

end
