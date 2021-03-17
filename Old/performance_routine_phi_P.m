function [ WaveR ] = performance_routine_phi_P ( Wave )
%% parameters sweep
Pmax = Wave.Input.Pmax ;

phi_range = Wave.Input.phimin:pi/6:Wave.Input.phimax ;
P_range = Pmax*0.1:Pmax*0.1:Pmax ;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% set plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.plot_arm_volt = 0 ;
Wave.FFT.plot_current = 0 ;
Wave.FFT.plotting = 0 ; % 0 no plotting / 1 simplified / 2 full
Wave.Input.plot_switching_energy = 0 ; % to plot interpolated switching energies
Wave.Input.plot_transition = 0 ; % to plot turn on / off transitions
Wave.Input.Plot_Filter_design = 0 ; % to plot the AC Filter design  
Wave.Input.plot_filter_compliance = 0 ; % to plot IEEE compliance 
Wave.Input.DClinkCurrentPlotting = 0 ; % to plot DC link currents
Wave.Input.plot_ESR_vs_f = 0 ; % to plot ESR vs f interpolation
Wave.Input.DClinkDesignPlotting = 0 ; % to plot DC link designs 
Wave.Input.Plot_DC_link_Current = 0 ; % to plot the DC link current for phi / M
Wave.Input.plot_InductorDesign = 0 ; % 1 to plot  the possible inducto designs
Wave.Input.AC_cap_plotting = 0 ; % 1 to plot the AC capacitor designs
Wave.Input.plot_AC_cost_interpolation = 0 ; % to plot the cost interpolation for AC Cap 

%%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% routine
z=1;
for y = 1:size(phi_range,2)
    Wave.Input.phi = phi_range(y) ;
    for x = 1:size(P_range,2)
        Wave.Input.P = P_range(x) ;% 100kW
        Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
        % generate voltage
        [ Wave ] = arm_voltage ( Wave ) ;

        % fft of the voltage
        [ Wave ] = volt_fft ( Wave ) ;

        % define AC ripple in the current
        [ Wave ] = current_with_ripple ( Wave ) ;

        % process current / find mean , rms and I on off and reverse recovery 
        [ Wave ] = current_processing ( Wave ) ;

        % calculate semiconductor losses
        [ Wave ] = semiconductor_losses ( Wave ) ;

%         % load DC capacitors data
%         [ Wave ] = DC_capacitors_data ( Wave ) ;
% 
%         % find DC Link current / in this point
%         [ Wave ] = DC_link_current ( Wave ) ;
% 
%         % evaluate DC link losses
%         [ Wave ] = DC_link_losses ( Wave )  ;
% 
%         % inductor losses
%         Wave.Inductor.IndToBeDesigned = 0 ;
%         [ Wave ] = Run_PowderCore_Losses( Wave ) ;
%         Wave.Inductor.IndToBeDesigned = 1 ; 
%         [ Wave ] = Run_PowderCore_Losses( Wave ) ;
% 
%         % design LCL capacitor
%         [ Wave ] = AC_cap_losses_routine ( Wave );

        % iteration data
        % semiconductor
        WaveR.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        WaveR.Semiconductor.Losses_C(x,y,z) = Wave.Losses.Ps_tot ;
        WaveR.Semiconductor.Losses_S(x,y,z) = Wave.Losses.Pc_tot ;
        WaveR.Semiconductor.Efficiency(x,y,z) = Wave.Losses.Efficiency ;
        WaveR.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        x
    end
    y
end
%% plotting
[X,Y]=meshgrid(phi_range/pi*180,P_range/Pmax);

figure;
surf(X,Y,WaveR.Semiconductor.Efficiency)
grid on
ylabel('Output Power [p.u.]')
xlabel('Phi [deg]')
zlabel('Efficiency [%]')

%%
figure;

subplot(1,2,1)
surf(X,Y,WaveR.Semiconductor.Efficiency)
grid on
ylabel('Output Power [p.u.]')
xlabel('Phi [deg]')
zlabel('Efficiency [%]')

subplot(1,2,2)
surf(X,Y,WaveR.Semiconductor.Losses)
grid on
ylabel('Output Power [p.u.]')
xlabel('Phi [deg]')
zlabel('Losses [kW]')

end