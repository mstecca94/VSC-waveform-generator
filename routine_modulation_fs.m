%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\Waveform Generation'))
addpath(genpath('C:\Users\mstec\surfdrive\Marco\Simulations\Converter\Waveform Generation')) % personal
ccc

Wave.Input.Add_LCL = 1 ; % put one to consider LCL

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
Wave.Input.plot_routine = 0 ; % to plot the routine results

%% %%%%%%%%%%%%%%%%%%%%%%%%%% Routine %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Wave.Input.ModulationStrategies = {'S-PWM','Third Harmonic Injection 1/4','Third Harmonic Injection 1/6',...
    'SV-PWM','D-PWM MIN','D-PWM MAX','D-PWM 0','D-PWM 1','D-PWM 2','D-PWM 3'};

% Wave.Input.ModulationStrategies = {'S-PWM','Third Harmonic Injection 1/6','SV-PWM','D-PWM 1'};
% Wave.Input.ModulationStrategies = {'Third Harmonic Injection 1/6','SV-PWM'};
Wave.Input.ModulationStrategies = {'S-PWM','D-PWM 1'};
Wave.Input.fs_range = [4050 8050] ;

Wave.Input.Pmax = 100000 ;% 100kW
Wave.Input.P_range = [ Wave.Input.Pmax*0.05:Wave.Input.Pmax*0.05:Wave.Input.Pmax*0.35 ...
    Wave.Input.Pmax*0.4:Wave.Input.Pmax*0.2:Wave.Input.Pmax] ;

Wave.Input.P_range = Wave.Input.Pmax*0.05:Wave.Input.Pmax*0.3:Wave.Input.Pmax*0.35 ;

for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    
    Wave.Input.fs = Wave.Input.fs_range(yy) ; % 10 kHz
    Wave.Input.Modulation = char(Wave.Input.ModulationStrategies(xx)) ;
    %%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Wave.Input.vdc = 900 ; % 1kV DC
    Wave.Input.vll = 400 ; % 400 V line-to-line
    Wave.Input.P = 100000 ;% 100kW
    Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
    Wave.Input.t_step = 0.5*1e-6 ; % time step
    Wave.Input.t=Wave.Input.t_step:Wave.Input.t_step:0.02; % 1 period
    Wave.Input.fg = 50 ; % 50 Hz
    if strcmp(Wave.Input.Modulation,'D-PWM MIN') == 1 || strcmp(Wave.Input.Modulation,'D-PWM MAX') == 1
        Wave.Input.fs = Wave.Input.fs - 50 ;
    end
    Wave.Input.phi = 0 ;
    Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 

    % operation area
    Wave.Input.phimin = -pi/2 ;
    Wave.Input.phimax = pi/2 ;
    Wave.Input.Vdcmin = 774 ;
    Wave.Input.Vdcmax = 1004 ;

    Wave.Input.DesignDClink = 0 ; % put 1 to design the DC Link / 0 to use a pre made design
    % parameters from samsung M3-R089  / for the DC link design
    if Wave.Input.DesignDClink == 1
        Wave.Input.grid_v_variation = 0.1 ; % +/- 10% AC voltage variation
        % three types of DC link designs
        Wave.Input.DC_Design = 'Minimum Cost' ;
        % Wave.Input.DC_Design = 'Minimum Volume' ;
        % Wave.Input.DC_Design = 'Maximum Lifetime' ;
    end
    %%%%%%%%%% Topology / Modulation / N Wire selection / AC Filter %%%%%%%%%%%
    Wave.Input.Topology = 'Two Level';
    % Wave.Input.Topology = 'Two Level - SiC';
    % Wave.Input.Topology = 'Three Level NPC';
    % Wave.Input.Topology = 'Three Level TTYPE';

    Wave.Input.Wire = 3 ; % 3 or 4 wire (3+VG) system

    % Wave.Input.ACFilter = 'L' ; % just L filter 
    % / the L filter for now does not work

    Wave.Input.ACFilter = 'LCL' ; % LCL Filter
    % 0 max ripple / 2 min ripple / 1 min cap 
    if strcmp(Wave.Input.ACFilter,'LCL')==1
            Wave.Input.kres = 0.2 ;
            Wave.Input.qfact = 0.1 ; % max LCL Q absorption = 5 % total P
            Wave.Input.Rc = 1e-3 ; % damping resistors
            Wave.Input.Rg = 1e-3 ; % damping resistors
            Wave.Input.Filter_selection = 2 ; % select 0 / 1 / 2
    end
    % Wave.Input.InductorDesign = 'Minimum Cost' ;
    % Wave.Input.InductorDesign =  'Minimum Losses' ;
    % Wave.Input.InductorDesign =  'Minimum Weight' ;
    % if you select this turn on the plotting and check what has been selected
    Wave.Input.InductorDesign =  'Optimal Point' ;

    Wave.Input.FEMM_verification = 0 ; % 1 to verify the selected design throguh FEMM

    % Wave.Input.Selected_AC_Cap_design = 'Minimum Cost' ;
    Wave.Input.Selected_AC_Cap_design = 'Minimum Weight' ;


    %% %%%%%%%%%%%%%%%%%%% Start Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % generate voltage
    [ Wave ] = arm_voltage ( Wave ) ;

    % fft of the voltage
    [ Wave ] = volt_fft ( Wave ) ;

    % LCL filter design 
    [ Wave ] = filter_design ( Wave ) ; 

    % define AC ripple in the current
    [ Wave ] = current_with_ripple ( Wave ) ;

    % process current / find mean , rms and I on off and reverse recovery 
    [ Wave ] = current_processing ( Wave ) ;

    % load semiconductor data
    [ Wave ] = semiconductor_data ( Wave ) ;

    % calculate semiconductor losses
    [ Wave ] = semiconductor_losses ( Wave ) ;

    % design DC link and find losses at this operating point
    [ Wave ] = DC_link ( Wave ) ;

    % design LCL inductors
    [ Wave ] = InductorDesignLCL ( Wave ) ;

    if Wave.Input.FEMM_verification == 1
    % FEMMM verification of skin effect losses
    [ Wave ] = FEMM_set_up ( Wave ) ; 
    end

    % design LCL capacitor
     [ Wave ] = AC_cap_design ( Wave );

    [ Wave ] = summary ( Wave ) ;
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%% Routines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % routine for P efficiency
    [ WaveR ] = performance_routine_P ( Wave ) ;
    
    ModComparison(xx,yy).Wave = Wave ;
    ModComparison(xx,yy).WaveR = WaveR ;

end
end
%% Plotting
figure;
title('Efficiency curve for different modulations')
hold on
for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    plot(Wave.Input.P_range/Wave.Input.Pmax,ModComparison(xx,yy).WaveR.Converter.Efficiency)
end
end
legend(char(Wave.Input.ModulationStrategies))
grid on
xlabel('Output Power [p.u.]')
ylabel('Efficiency [%]')

figure;
sgtitle('Weight - Cost - Efficiency design space')

subplot(1,2,1)
hold on
for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    scatter(ModComparison(xx,yy).Wave.System.Cost,ModComparison(xx,yy).Wave.System.Efficiency,[],...
        ModComparison(xx,yy).Wave.System.Weight,'filled')
end
end
legend(char(Wave.Input.ModulationStrategies))
grid on
xlabel('Cost [€]')
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Weight [kg]';
colormap(jet)

subplot(1,2,2)
hold on
for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    scatter(ModComparison(xx,yy).Wave.System.CostperkW,ModComparison(xx,yy).Wave.System.Efficiency,[],...
        ModComparison(xx,yy).Wave.System.PowerDensity,'filled')
end
end

legend(char(Wave.Input.ModulationStrategies))
grid on
xlabel('Cost  per kW [€/kW]')
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Power density [kW/kg]';
colormap(jet)

%% 
figure;
sgtitle('Weight - Cost - Efficiency design space')
subplot(1,2,1)
hold on
for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    if mod(xx,2) == 1 
        xy = 1 ;
    else
        xy = -1 ;
    end
    scatter(ModComparison(xx,yy).Wave.System.Cost,ModComparison(xx,yy).Wave.System.Efficiency)
%     ModComparison(xx,yy).Wave.System.Weight,'filled')
    text(ModComparison(xx,yy).Wave.System.Cost-100,ModComparison(xx,yy).Wave.System.Efficiency+0.04*1*sign(xy)...
        ,sprintf('%s - %.0f kHz',char(Wave.Input.ModulationStrategies(xx)),Wave.Input.fs_range(yy)/1000))
    text(ModComparison(xx,yy).Wave.System.Cost-50,ModComparison(xx,yy).Wave.System.Efficiency+0.02*1*sign(xy)...
        ,sprintf('{%.1f kg}',ModComparison(xx,yy).Wave.System.Weight))
end
end
legend(char(Wave.Input.ModulationStrategies))
grid on
xlabel('Cost [euro]')
ylabel('Efficiency [%]')
% c = colorbar;
% c.Label.String = 'Weight [kg]';
% colormap(jet)

subplot(1,2,2)
hold on
for yy = 1:size(Wave.Input.fs_range,2)
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    if mod(xx,2) == 1 
        xy = 1 ;
    else
        xy = -1 ;
    end
    scatter(ModComparison(xx,yy).Wave.System.CostperkW,ModComparison(xx,yy).Wave.System.Efficiency)
%     ModComparison(xx,yy).Wave.System.PowerDensity,'filled')
    text(ModComparison(xx,yy).Wave.System.CostperkW-1.5,ModComparison(xx,yy).Wave.System.Efficiency+0.04*1*sign(xy)...
        ,sprintf('%s - %.0f kHz',char(Wave.Input.ModulationStrategies(xx)),Wave.Input.fs_range(yy)/1000))
    text(ModComparison(xx,yy).Wave.System.CostperkW-0.75,ModComparison(xx,yy).Wave.System.Efficiency+0.02*1*sign(xy)...
        ,sprintf('{%.1f kW/kg}',ModComparison(xx,yy).Wave.System.PowerDensity))
end
end

legend(char(Wave.Input.ModulationStrategies))
grid on
xlabel('Cost  per kW [€/kW]')
ylabel('Efficiency [%]')
% c = colorbar;
% c.Lbel.String = 'Power density [kW/kg]';
% colormap(jet)
