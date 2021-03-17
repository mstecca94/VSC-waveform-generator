function [ WaveR ] = performance_routine_M ( Wave )
%% parameters sweep
M_range = Wave.Input.M_range ;

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


%% routine
y=1;
z=1;
for x = 1:size(M_range,2)
    Wave.Input.M = M_range(x) ;% 100kW
%     Wave.Input.vll = Wave.Input.M*Wave.Input.vdc/2/sqrt(2)*sqrt(3);
%     Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
    
    Wave.Input.vll = Wave.Input.M*Wave.Input.vdc/2/sqrt(2)*sqrt(3);
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

    % load DC capacitors data
    [ Wave ] = DC_capacitors_data ( Wave ) ;

    % find DC Link current / in this point
    [ Wave ] = DC_link_current ( Wave ) ;

    % evaluate DC link losses
    [ Wave ] = DC_link_losses ( Wave )  ;

    % inductor losses
    Wave.Inductor.IndToBeDesigned = 0 ;
    [ Wave ] = Run_PowderCore_Losses( Wave ) ;
    Wave.Inductor.IndToBeDesigned = 1 ; 
    [ Wave ] = Run_PowderCore_Losses( Wave ) ;
    
    % design LCL capacitor
    [ Wave ] = AC_cap_losses_routine ( Wave );
    
    % iteration data
    % semiconductor
    WaveR.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
    WaveR.Semiconductor.Losses_C(x,y,z) = Wave.Losses.Ps_tot ;
    WaveR.Semiconductor.Losses_S(x,y,z) = Wave.Losses.Pc_tot ;
    WaveR.Semiconductor.Efficiency(x,y,z) = Wave.Losses.Efficiency ;
    WaveR.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
    
    % dc link
    WaveR.DClink.Efficiency(x,y,z) = Wave.DClink.DCLinkEfficiency ;
    WaveR.DClink.Losses(x,y,z) = Wave.DClink.Losses ;

    % ac capacitors
    WaveR.AC_Cap.Efficiency(x,y,z) = Wave.AC_Cap.Efficiency ;
    WaveR.AC_Cap.Losses(x,y,z) = Wave.AC_Cap.Losses ;    

    % inductors
    WaveR.Inductor.Losses_Lg(x,y,z) = Wave.Inductor.Lg_Routine.Core.Total_Loss ;
    WaveR.Inductor.Losses_Lc(x,y,z) = Wave.Inductor.Lc_Routine.Core.Total_Loss ;
    WaveR.Inductor.Losses(x,y,z) = 3*(Wave.Inductor.Lg_Routine.Core.Total_Loss+Wave.Inductor.Lc_Routine.Core.Total_Loss) ;
    WaveR.Inductor.Efficiency(x,y,z) = (Wave.Input.P - WaveR.Inductor.Losses(x,y,z))/Wave.Input.P*100; 

    % total
    WaveR.Converter.Efficiency(x,y,z) = WaveR.Semiconductor.Efficiency(x,y,z)*WaveR.Inductor.Efficiency(x,y,z)*...
        WaveR.DClink.Efficiency(x,y,z)*WaveR.AC_Cap.Efficiency(x,y,z)/100/100/100;
    WaveR.Converter.Losses(x,y,z) = WaveR.Semiconductor.Losses(x,y,z) + 3*WaveR.Inductor.Losses(x,y,z) +...
        WaveR.DClink.Losses(x,y,z)+WaveR.AC_Cap.Losses(x,y,z);

    Efficiency(x,y,z) = WaveR.Semiconductor.Efficiency(x,y,z)*WaveR.Inductor.Efficiency(x,y,z)*...
        WaveR.DClink.Efficiency(x,y,z)*WaveR.AC_Cap.Efficiency(x,y,z)/100/100/100;
    Losses(x,y,z) = WaveR.Semiconductor.Losses(x,y,z) + WaveR.Inductor.Losses(x,y,z) +...
        WaveR.DClink.Losses(x,y,z) + WaveR.AC_Cap.Losses(x,y,z);
end

%% plotting

if Wave.Input.plot_routine == 1
    lw = 1.25 ;
    figure;

    subplot(1,2,1)
    plot(M_range,Efficiency,'b','LineWidth',lw)
    grid on
    xlabel('M [p.u.]')
    ylabel('Efficiency [%]')

    subplot(1,2,2)
    hold on
    plot(M_range,WaveR.Inductor.Losses,'b','LineWidth',lw)
    plot(M_range,WaveR.Semiconductor.Losses,'r','LineWidth',lw)
    plot(M_range,WaveR.DClink.Losses,'g','LineWidth',lw)
    plot(M_range,WaveR.AC_Cap.Losses,'k','LineWidth',lw)
    grid on
    xlabel('M [p.u.]')
    ylabel('Losses [kW]')
    legend('Inductor','Semiconductor','DC Link','AC Cap')
    
    figure;
    title('Converter efficiency varying M')
    hold on 
    plot(M_range,Efficiency,'b','LineWidth',lw)
    grid on
    xlabel('M [p.u.]')
    ylabel('Efficiency [%]')
end
end