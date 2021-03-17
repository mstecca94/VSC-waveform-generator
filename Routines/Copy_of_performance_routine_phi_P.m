function [ WaveR ] = performance_routine_phi_P ( Wave )
%% parameters sweep
Pmax = 100000 ;

phi_range = Wave.Input.phimin:pi/6:Wave.Input.phimax/2 ;
P_range = Pmax*0.05:Pmax*0.05:Pmax*0.15 ;

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
Wave.Input.vll = 400 ; % 400 V line-to-line
Wave.Input.fg = 50 ; % 50 Hz
Wave.Input.fs = 16050 ; % 10 kHz
Wave.Input.phi = 0 ;
Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 

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

        % iteration data
        % semiconductor
        WaveR2.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        WaveR2.Semiconductor.Losses_C(x,y,z) = Wave.Losses.Ps_tot ;
        WaveR2.Semiconductor.Losses_S(x,y,z) = Wave.Losses.Pc_tot ;
        WaveR2.Semiconductor.Efficiency(x,y,z) = Wave.Losses.Efficiency ;
        WaveR2.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        
        x
    end
    y
end
%% plotting
[X2,Y2]=meshgrid(phi_range/pi*180,P_range/Pmax);

figure;

subplot(1,2,1)
surf(X2,Y2,WaveR2.Semiconductor.Efficiency)
grid on
ylabel('Output Power [p.u.]')
xlabel('Phi [deg]')
zlabel('Efficiency [%]')

subplot(1,2,2)
surf(X2,Y2,WaveR2.Semiconductor.Losses)
grid on
ylabel('Output Power [p.u.]')
xlabel('Phi [deg]')
zlabel('Losses [kW]')

end