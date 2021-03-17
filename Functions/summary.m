function [ Wave ] = summary ( Wave )

%%
fprintf('\n')
disp('%%%%%%%%%%%%%  Summary  %%%%%%%%%%%%%')
fprintf('\n')
disp('Input:')
fprintf('\nTopology: %s - %d wire system \n',Wave.Input.Topology,Wave.Input.Wire)
fprintf('Modulation Type: %s \n',Wave.Input.Modulation)
fprintf('Switching Frequency: %.3f kHz \n',Wave.Input.fs/1000)
fprintf('Filter Resonance Frequency: %.3f kHz / kres = %.3f \n',Wave.Input.fs/1000*Wave.Input.kres,...
    Wave.Input.kres)
fprintf('Output Power: %d kW \n',Wave.Input.P/1000)
fprintf('Phase Shift: %.3f deg \n',Wave.Input.phi/pi*180)
fprintf('Voltages: V_{dc} = %d V - V_{ac,ll} = %d V\n',Wave.Input.vdc,Wave.Input.vll)
fprintf('LCL Filter: L_{c} = %.3f mH - L_{g} = %.3f mH - C = %.3f uF \n\n',...
    Wave.Input.Lc*1000,Wave.Input.Lg*1000,Wave.Input.C*1e6)

disp('Semiconductor:')
fprintf('\n')
fprintf('Module: %s \n',Wave.SemiconductorParameters.Module);
fprintf('Cost: %.3f [€]\n',Wave.SemiconductorParameters.cost)
fprintf('Current Ripple: %.2f %% of the peak AC current \n',...
    max(abs(Wave.Current.i_converter_side-Wave.Current.i_grid_side))/max(Wave.Current.i_50Hz_a)*100)
fprintf('Efficiency: %.2f%% \n\n',Wave.Losses.Efficiency)

% disp('AC Filter Design:')
% fprintf('\n')
% fprintf('Inductor Losses: %.3f [kW] \n',Wave.Inductor.FilterLosses/1000)
% fprintf('Inductor Cost: %.3f [k€] \n',Wave.Inductor.FilterCost/1000)
% fprintf('Inductor Weight: %.3f [kg] \n',Wave.Inductor.FilterWeight)
% if Wave.Input.FEMM_verification == 1
%     disp('-----Inductors verified through FEMM-----')
%     fprintf('Error of skin effect losses analytical derivation: %.3f%% (Lc) %.3f%% (Lg)\n',...
%         (Wave.Inductor.Lc_Design.PwdgFEMM-Wave.Inductor.Lc_Design.Wire_Pskin)/...
%         Wave.Inductor.Lc_Design.PwdgFEMM*100,(Wave.Inductor.Lg_Design.PwdgFEMM-...
%         Wave.Inductor.Lg_Design.Wire_Pskin)/Wave.Inductor.Lg_Design.PwdgFEMM*100)
% end
% fprintf('AC Capacitor Losses: %.3f [kW] \n',Wave.AC_Cap.FinalDesign(8)/1000)
% fprintf('AC Capacitor Cost: %.3f [k€] \n',Wave.AC_Cap.FinalDesign(6)/1000)
% fprintf('AC Capacitor Weight: %.3f [kg] \n\n',Wave.AC_Cap.FinalDesign(10))
% 
% disp('System:')
% fprintf('\nConverter efficiency: %.2f%% \n',Wave.Losses.Efficiency*Wave.DClink.DCLinkEfficiency*...
%     Wave.Inductor.FilterEfficiency*Wave.AC_Cap.FinalDesign(9)/100/100/100)
% fprintf('Semiconductor efficiency: %.2f%% \n',Wave.Losses.Efficiency)
% fprintf('DC Link efficiency: %.2f%% \n',Wave.DClink.DCLinkEfficiency)
% fprintf('AC Filter efficiency: %.2f%% \n',Wave.Inductor.FilterEfficiency*Wave.AC_Cap.FinalDesign(9)/100)
% disp('-----')
% fprintf('Total Cost: %.2f [€] \n',Wave.DClink.Design(12)*1000+Wave.Inductor.FilterCost+...
%     Wave.SemiconductorParameters.cost+Wave.AC_Cap.FinalDesign(6)/1000)
% fprintf('Cost per kW: %.2f [€/kW] \n',(Wave.DClink.Design(12)*1000+Wave.Inductor.FilterCost+...
%     Wave.SemiconductorParameters.cost+Wave.AC_Cap.FinalDesign(6)/1000)/Wave.Input.P*1000)
% disp('-----')
% fprintf('Total Weight: %.2f [kg] \n',Wave.DClink.Design(10)+Wave.Inductor.FilterWeight+...
%     Wave.SemiconductorParameters.weight+Wave.AC_Cap.FinalDesign(10))
% fprintf('Power density: %.2f [kW/kg] \n',Wave.Input.P/1000/(Wave.DClink.Design(10)+Wave.Inductor.FilterWeight+...
%     Wave.SemiconductorParameters.weight+Wave.AC_Cap.FinalDesign(10)))
% 
% Wave.System.Cost = Wave.DClink.Design(12)*1000+Wave.Inductor.FilterCost+...
%     Wave.SemiconductorParameters.cost+Wave.AC_Cap.FinalDesign(6)/1000 ;
% Wave.System.Efficiency = Wave.Losses.Efficiency*Wave.DClink.DCLinkEfficiency*...
%     Wave.Inductor.FilterEfficiency*Wave.AC_Cap.FinalDesign(9)/100/100/100 ;
% Wave.System.Weight = Wave.DClink.Design(10)+Wave.Inductor.FilterWeight+...
%     Wave.SemiconductorParameters.weight+Wave.AC_Cap.FinalDesign(10) ;
% 
% Wave.System.PowerDensity = Wave.Input.P/1000/(Wave.DClink.Design(10)+Wave.Inductor.FilterWeight+...
%     Wave.SemiconductorParameters.weight+Wave.AC_Cap.FinalDesign(10)) ;
% Wave.System.CostperkW = (Wave.DClink.Design(12)*1000+Wave.Inductor.FilterCost+...
%     Wave.SemiconductorParameters.cost+Wave.AC_Cap.FinalDesign(6)/1000)/Wave.Input.P*1000 ;

end