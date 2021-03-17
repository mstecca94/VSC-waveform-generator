function [ Wave ] = summary_MD ( Wave )

%%
fprintf('\n')
disp('%%%%%%%%%%%%%  Summary  %%%%%%%%%%%%%')
fprintf('\n')
disp('Input:')
fprintf('\nTopology: %s - %d wire system \n',Wave.Input.Topology,Wave.Input.Wire)
fprintf('Modulation Type: %s \n',Wave.Input.Modulation)
fprintf('Switching Frequency: %.3f kHz \n',Wave.Input.fs/1000)
fprintf('Output Power: %d kW \n',Wave.Input.P/1000)
fprintf('Voltages: V_{dc} = %d V - V_{ac,ll} = %d V\n',Wave.Input.vdc,Wave.Input.vll)

disp('Semiconductor:')
fprintf('\n')
fprintf('Module: %s \n',Wave.SemiconductorParameters.Module);
fprintf('Cost: %.3f [€]\n',Wave.SemiconductorParameters.cost)
fprintf('Current Ripple: %.2f %% of the peak AC current \n',...
    max(abs(Wave.Current.i_converter_side-Wave.Current.i_grid_side))/max(Wave.Current.i_50Hz_a)*100)
fprintf('Efficiency: %.2f%% \n\n',Wave.Losses.Efficiency)

disp('System:')
fprintf('Semiconductor efficiency: %.2f%% \n',Wave.Losses.Efficiency*0.997)


end