%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\Waveform Generation'))
% addpath(genpath('C:\Users\mstec\surfdrive\Marco\Simulations\Converter\Waveform Generation')) % personal
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
Wave.Input.Pmax = 10000 ;% 100kW
Wave.Input.Application = 'Motor Drive' ; % now only SiC / IGBT based components not ready yet
Wave.Input.Lm = 0.0029 ;
Wave.Input.Rm = 27 ;

Wave.Input.Topology = 'Two Level - SiC' ;

Wave.Input.Topologies = {'Two Level - SiC'};
% Wave.Input.ModulationStrategies = {'S-PWM','Third Harmonic Injection 1/4','Third Harmonic Injection 1/6',...
%     'SV-PWM','D-PWM MIN','D-PWM MAX','D-PWM 0','D-PWM 1','D-PWM 2','D-PWM 3'};
Wave.Input.ModulationStrategies = {'SV-PWM','D-PWM 1'};
% Wave.Input.fs_range = [4050 6050 8050 10050 12050 14050] ;
Wave.Input.fs_range = [8000 16000 24000 32000] ;
Wave.Input.P_range = Wave.Input.Pmax ;
Wave.Input.phimin = -pi/3 ;
Wave.Input.phimax = pi/3 ;

phi_range = Wave.Input.phimin:pi/6:Wave.Input.phimax ;

% Wave.Input.Topologies = {'Two Level','Three Level NPC'};
% Wave.Input.ModulationStrategies = {'S-PWM','D-PWM 1'};
% Wave.Input.fs_range = [4050 8050] ;
% Wave.Input.P_range = Wave.Input.Pmax*0.05:Wave.Input.Pmax*0.3:Wave.Input.Pmax*0.35 ;
%%
for zz = 1:size(Wave.Input.fs_range,2)
for yy = 1:size(phi_range,2)
    Wave.Input.phi = phi_range(yy) ;
% for yy = 1:size(Wave.Input.Topologies,2)
% Wave.Input.Topology = char(Wave.Input.Topologies(yy)) ;
for xx = 1:size(Wave.Input.ModulationStrategies,2)
    
    Wave.Input.fs = Wave.Input.fs_range(zz) ; % 10 kHz
    Wave.Input.Modulation = char(Wave.Input.ModulationStrategies(xx)) ;
    %%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Wave.Input.vdc = 600 ; % 1kV DC
    Wave.Input.vll = 272 ; % 400 V line-to-line
    Wave.Input.P = 5000 ;% 100kW
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

    % define AC ripple in the current
    [ Wave ] = current_with_ripple_MD ( Wave ) ;

    % process current / find mean , rms and I on off and reverse recovery 
    [ Wave ] = current_processing ( Wave ) ;

    % load semiconductor data
    [ Wave ] = semiconductor_data ( Wave ) ;

    % calculate semiconductor losses
    [ Wave ] = semiconductor_losses ( Wave ) ;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%% Routines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ModComparison(xx,yy,zz).Wave.Input = Wave.Input ;
    ModComparison(xx,yy,zz).Wave.Input.t = [] ;
    ModComparison(xx,yy,zz).Wave.SemiconductorLosses = Wave.SemiconductorLosses ;
    ModComparison(xx,yy,zz).Wave.SemiconductorParameters = Wave.SemiconductorParameters ;
    ModComparison(xx,yy,zz).Wave.Losses = Wave.Losses ;

end
yy
end
zz
end

%%

for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    Losses_bar(xx,zz,1) = ModComparison(xx,zz).Wave.Losses.Pc_tot ; % cond losses
    Losses_bar(xx,zz,2) = ModComparison(xx,zz).Wave.Losses.Ps_tot ; % sw losses
    Losses_bar(xx,zz,3) = ModComparison(xx,zz).Wave.Losses.Ptot/3 ; % mach losses / not done yet
end
end

groupLabels = {'S','THI 1/4','TJI 1/6',...
    'SV','D-MIN','D-MAX','D-0','D-1','D-2','D-3'} ;
plotBarStackGroups(Losses_bar, groupLabels)
grid on
legend('Conduction Losses','Switching Losses','Machine Losses')
yy = 4 ; % 2LC SiC
ModulationStrategies = {'S','THI 1/4','TJI 1/6',...
    'SV','D-MIN','D-MAX','D-0','D-1','D-2','D-3'};
xlabel('Modulation strategy')
ylabel('Losses [W]')

%%
lw=1.25;
figure;
title('Two Level SiC Efficiency')

hold on
for zz = 1:size(ModComparison(1,1).Wave.Input.fs_range,2)
for xx = 1:size(ModComparison(1,1).Wave.Input.ModulationStrategies,2)
        scatter(xx,...
            ModComparison(xx,zz).Wave.Losses.Efficiency,[],...
            ModComparison(xx,zz).Wave.Input.fs/1000,'o','filled','LineWidth',lw)
end
end

grid on
xlabel('Modulation Strategy')
xticks(1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2))
xticklabels(ModulationStrategies)
xtickangle(45)
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Switching frequency [kHz]';
colormap(jet(4))
