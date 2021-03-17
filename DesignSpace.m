%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\EPE extension'))
% addpath(genpath('C:\Users\mstec\surfdrive\Marco\Simulations\Converter\EPE extension')) % personal
ccc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% set plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.plot_arm_volt = 0 ;
Wave.FFT.plot_current = 0 ;
Wave.FFT.plotting = 0 ; % 0 no plotting / 1 simplified / 2 full
Wave.Input.plot_switching_energy = 0 ; % to plot interpolated switching energies
Wave.Input.plot_transition = 1 ; % to plot turn on / off transitions
Wave.Input.Plot_Filter_design = 1 ; % to plot the AC Filter design  
Wave.Input.plot_filter_compliance = 1 ; % to plot IEEE compliance 
Wave.Input.DClinkCurrentPlotting = 0 ; % to plot DC link currents
Wave.Input.plot_ESR_vs_f = 0 ; % to plot ESR vs f interpolation
Wave.Input.DClinkDesignPlotting = 0 ; % to plot DC link designs 
Wave.Input.Plot_DC_link_Current = 0 ; % to plot the DC link current for phi / M
Wave.Input.plot_InductorDesign = 0 ; % 1 to plot  the possible inducto designs
Wave.Input.AC_cap_plotting = 0 ; % 1 to plot the AC capacitor designs
Wave.Input.plot_AC_cost_interpolation = 0 ; % to plot the cost interpolation for AC Cap 
Wave.Input.plot_routine = 0 ; % to plot the routine results

%%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.Add_LCL = 1 ; % put one to consider LCL
Wave.Input.Application = 'Grid Connected' ;
Wave.Input.nps = 3 ; % number of parallel switches 1/3
Wave.Input.Exp = 1 ; % 1 to use experimental DPT data
Wave.Input.MOSFETmaxCurrent = 50 ; % maybe use this as maximum

Wave.Input.vdc = 650 ; % 1kV DC
Wave.Input.vll = 380 ; % 400 V line-to-line
Wave.Input.Pmax = 4500 ;% 100kW 
Wave.Input.M_range = 0.1:0.1:1;
Wave.Input.P = 4500 ;% 100kW
Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
Wave.Input.t_step = 0.5*1e-6 ; % time step
Wave.Input.fg = 50 ; % 50 Hz
Wave.Input.t = Wave.Input.t_step:Wave.Input.t_step:1/Wave.Input.fg; % 1 period
Wave.Input.fs = 12050 ; % 10 kHz
Wave.Input.phi = 0/180*pi ;
Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 
Wave.Input.LVRT_maxI = Wave.Input.I*2; % twice the nominal current

% routine parameters
Wave.Input.phimin = 0 ;
Wave.Input.phimax = pi/2 ;
Wave.Input.kres_sel = 0.25 ;
Wave.Input.routine_designs = 10 ;

% operation area
% Wave.Input.phimin = -pi/2 ;
% Wave.Input.phimax = pi/2 ;
% Wave.Input.Vdcmin = 774 ;
% Wave.Input.Vdcmax = 1004 ;

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
% Wave.Input.Topology = 'Two Level';
Wave.Input.Topology = 'Two Level - SiC';

Wave.Input.Wire = 3 ; % 3 or 4 wire (3+VG) system

Wave.Input.ACFilter = 'LCL' ; % LCL Filter
% Wave.Input.ACFilter = 'Custom LCL' ; % LCL Filter
% 0 max ripple / 2 min ripple / 1 min cap 
if strcmp(Wave.Input.ACFilter,'LCL')==1
    Wave.Input.kres_range = 0.15:0.025:0.5 ;
%     Wave.Input.kres_range = 0.15:0.35:0.5 ;
%     Wave.Input.kres_range = 0.35 ;
    Wave.Input.qfact = 0.10 ; % max LCL Q absorption = 15 % total P
    Wave.Input.Rc = 1e-3 ; % damping resistors
    Wave.Input.Rg = 1e-3 ; % damping resistors
    Wave.Input.Filter_selection = 3 ; % select 0 (max ripple) / 1 (min C) / 2 (min ripple) / 3 (medium ripple)
%     Wave.Input.sftycoeff_range = 1.025:0.375:2.025 ; % 2.5% increase from minimum Ltot (to ensure margin for IEEE 519 compliance)
%     Wave.Input.sftycoeff_range = 1.025:0.25:2.025 ; % 2.5% increase from minimum Ltot (to ensure margin for IEEE 519 compliance)
    Wave.Input.sftycoeff_range = 1.025:0.125:2.025 ; % 2.5% increase from minimum Ltot (to ensure margin for IEEE 519 compliance)
    Wave.Input.kres_sel = 0.25 ; % selected kres for filter design
end
if strcmp(Wave.Input.ACFilter,'Custom LCL')==1
    % custom made design 
    Wave.Input.C = 6.6e-6 ; 
    Wave.Input.Lc = 450e-6 ;
    Wave.Input.Lg = 320e-6 ;
    Wave.Input.Rc = 1e-3 ; % damping resistors
    Wave.Input.Rg = 1e-3 ; % damping resistors
    Wave.Input.fres = 1/2/pi*sqrt((Wave.Input.Lc+Wave.Input.Lg)/Wave.Input.Lc/Wave.Input.Lg/Wave.Input.C);
    Wave.Input.kres = Wave.Input.fres/Wave.Input.fs;
end

% Wave.Input.InductorDesign = 'Minimum Cost' ;
% Wave.Input.InductorDesign =  'Minimum Losses' ;
% Wave.Input.InductorDesign =  'Minimum Weight' ;
% if you select this turn on the plotting and check what has been selected
Wave.Input.InductorDesign =  'Optimal Point' ;
% Wave.Input.InductorDesign =  'Custom Point' ;
% Wave.Input.InductorDesignCustom =  [239 268] ; % Lc and Lg / derived from the graph

Wave.Input.FEMM_verification = 0 ; % 1 to verify the selected design throguh FEMM

% Wave.Input.Selected_AC_Cap_design = 'Minimum Cost' ;
Wave.Input.Selected_AC_Cap_design = 'Minimum Weight' ;

% Wave.Input.Modulation = 'S-PWM' ;
% Wave.Input.Modulation = 'Third Harmonic Injection 1/4';
% Wave.Input.Modulation = 'Third Harmonic Injection 1/6' ; 
% Wave.Input.Modulation = 'SV-PWM';
% Wave.Input.Modulation = 'D-PWM MIN';
% Wave.Input.Modulation = 'D-PWM MAX';
% Wave.Input.Modulation = 'D-PWM 0';
Wave.Input.Modulation = 'D-PWM 1';
% Wave.Input.Modulation = 'D-PWM 2';
% Wave.Input.Modulation = 'D-PWM 3'; 
% Wave.Input.Modulation = 'MSL D-PWM' ;

%% %%%%%%%%%%%%%%%%%%% Start Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate voltage
[ Wave ] = arm_voltage ( Wave ) ;

% fft of the voltage
[ Wave ] = volt_fft ( Wave ) ;

%%

if strcmp(Wave.Input.ACFilter,'LCL')==1
    % LCL filter design 
    [ Wave ] = LCL_design_space ( Wave ) ; 
end

%% Check for design space
design_space_pareto ( Wave ) ;



