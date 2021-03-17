function [ Wave ] = InductorDesignLCL ( Wave )
%%
% design Lg
 Wave.Inductor.IndToBeDesigned = 0 ;
[ Wave ] = Run_PowderCore( Wave ) ;
%%
% design Lc
 Wave.Inductor.IndToBeDesigned = 1 ;
[ Wave ] = Run_PowderCore( Wave ) ;
%%
% process data
[ Wave ] = optimal_inductor_design ( Wave ) ;

%%
FilterLosses = 3*(Wave.Inductor.Lg_Design.Total_Loss + Wave.Inductor.Lc_Design.Total_Loss) ;
FilterWeight = 3*(Wave.Inductor.Lg_Design.Total_Weight + Wave.Inductor.Lc_Design.Total_Weight) ;
FilterCost = 3*(Wave.Inductor.Lc_Design_spec(10)   + Wave.Inductor.Lg_Design_spec(10)) ;

% save data
Wave.Inductor.FilterEfficiency  = (Wave.Input.P-FilterLosses)/Wave.Input.P*100 ;
Wave.Inductor.FilterLosses  = FilterLosses ;
Wave.Inductor.FilterWeight  = FilterWeight ;
Wave.Inductor.FilterCost  = FilterCost ;
end
