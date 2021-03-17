%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\Waveform Generation'))
% addpath(genpath('C:\Users\mstec\surfdrive\Marco\Simulations\Converter\Waveform Generation')) % personal
ccc

Wave.Input.Add_LCL = 1 ; % put one to consider LCL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Routines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Routine_VDC_P = 0 ;
Routine_PHI_P = 0 ;
Routine_P = 0 ;
Routine_M = 0 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% set plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.plot_arm_volt = 1 ;
Wave.FFT.plot_current = 1 ;
Wave.FFT.plotting = 1 ; % 0 no plotting / 1 simplified / 2 full
Wave.Input.plot_switching_energy = 0 ; % to plot interpolated switching energies
Wave.Input.plot_transition = 1 ; % to plot turn on / off transitions
Wave.Input.Plot_Filter_design = 1 ; % to plot the AC Filter design  
Wave.Input.plot_filter_compliance = 1 ; % to plot IEEE compliance 
Wave.Input.DClinkCurrentPlotting = 1 ; % to plot DC link currents
Wave.Input.plot_ESR_vs_f = 0 ; % to plot ESR vs f interpolation
Wave.Input.DClinkDesignPlotting = 0 ; % to plot DC link designs 
Wave.Input.Plot_DC_link_Current = 0 ; % to plot the DC link current for phi / M
Wave.Input.plot_InductorDesign = 1; % 1 to plot  the possible inducto designs
Wave.Input.AC_cap_plotting = 0 ; % 1 to plot the AC capacitor designs
Wave.Input.plot_AC_cost_interpolation = 0 ; % to plot the cost interpolation for AC Cap 
Wave.Input.plot_routine = 0 ; % to plot the routine results

%%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.Application = 'Grid Connected' ;
% Wave.Input.Application = 'Motor Drive' ; % now only SiC / IGBT based components not ready yet
Wave.Input.nps = 1 ; % number of parallel switches 1/3
Wave.Input.Lm = 0.01 ;
Wave.Input.Rm = 27 ;
Wave.Input.Exp = 1 ; % put 1 to use the double-pulse test measurement results

Wave.Input.vdc = 900 ; % 1kV DC
Wave.Input.vll = 400 ; % 400 V line-to-line
Wave.Input.Pmax = 100000 ;% 100kW 
Wave.Input.M_range = 0.1:0.1:1;
Wave.Input.P_range = Wave.Input.Pmax*0.05:Wave.Input.Pmax*0.05:Wave.Input.Pmax ;
Wave.Input.P = 100000 ;% 100kW
Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
Wave.Input.t_step = 0.5*1e-6 ; % time step
Wave.Input.fg = 50 ; % 50 Hz
Wave.Input.t = Wave.Input.t_step:Wave.Input.t_step:1/Wave.Input.fg; % 1 period
Wave.Input.fs = 16050 ; % 10 kHz
Wave.Input.phi = 0/180*pi ;
Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 

% Wave.Input.I = 4.3279 ;
% Wave.Input.P = Wave.Input.I*(sqrt(3)*Wave.Input.vll) ;% 100kW
% Wave.Input.Pr = Wave.Input.I*(sqrt(3)*Wave.Input.vll) ;

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
% Wave.Input.Topology = 'Two Level';
% Wave.Input.Topology = 'Two Level - SiC';
% Wave.Input.Topology = 'Three Level NPC';
Wave.Input.Topology = 'Three Level TTYPE';

Wave.Input.Wire = 3 ; % 3 or 4 wire (3+VG) system

% Wave.Input.ACFilter = 'L' ; % just L filter 
% / the L filter for now does not work

% Wave.Input.ACFilter = 'Custom LCL' ; % LCL Filter
Wave.Input.ACFilter = 'LCL' ; % LCL Filter
% 0 max ripple / 2 min ripple / 1 min cap 
if strcmp(Wave.Input.ACFilter,'LCL')==1
    Wave.Input.kres = 0.2 ;
    Wave.Input.qfact = 10 ; % max LCL Q absorption = 15 % total P
    Wave.Input.Rc = 1e-3 ; % damping resistors
    Wave.Input.Rg = 1e-3 ; % damping resistors
    Wave.Input.Filter_selection = 2 ; % select 0 / 1 / 2
end 
if strcmp(Wave.Input.ACFilter,'Custom LCL')==1
    % custom made design 
    Wave.Input.C = 6.6e-6 ; 
    Wave.Input.Lc = 450e-6 ;
    Wave.Input.Lg = 720e-6 ;
    Wave.Input.Rc = 1e-3 ; % damping resistors
    Wave.Input.Rg = 1e-3 ; % damping resistors
end
% Wave.Input.InductorDesign = 'Minimum Cost' ;
% Wave.Input.InductorDesign =  'Minimum Losses' ;
% Wave.Input.InductorDesign =  'Minimum Weight' ;
% if you select this turn on the plotting and check what has been selected
Wave.Input.InductorDesign =  'Optimal Point' ;

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
% Wave.Input.Modulation = 'D-PWM 3'; 'MSL D-PWM'
% Wave.Input.Modulation = 'MSL D-PWM' ;

%% %%%%%%%%%%%%%%%%%%% Start Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate voltage
[ Wave ] = arm_voltage ( Wave ) ;

% fft of the voltage
[ Wave ] = volt_fft ( Wave ) ;
%%
switch Wave.Input.Application
    case 'Grid Connected'
    if strcmp(Wave.Input.ACFilter,'LCL')==1
        % LCL filter design 
        [ Wave ] = filter_design ( Wave ) ; 
    end

    % define AC ripple in the current
    [ Wave ] = current_with_ripple ( Wave ) ;
    
    case 'Motor Drive'
    % define AC ripple in the current
    [ Wave ] = current_with_ripple_MD ( Wave ) ;
    
end
%%
% process current / find mean , rms and I on off and reverse recovery 
[ Wave ] = current_processing ( Wave ) ;

% load semiconductor data
[ Wave ] = semiconductor_data ( Wave ) ;

% calculate semiconductor losses
[ Wave ] = semiconductor_losses ( Wave ) ;
%%
if strcmp(Wave.Input.Application,'Grid Connected') == 1

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
end 
%% %%%%%%%%%%%%%%%%%%%%%%%% Print some results %%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(Wave.Input.Application,'Grid Connected') == 1
    [ Wave ] = summary ( Wave ) ;
else
    [ Wave ] = summary_MD ( Wave ) ;
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%% Routines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Routine_VDC_P = 0 ;
Routine_PHI_P = 0 ;
Routine_P = 0 ;
Routine_M = 0 ;

if Routine_VDC_P == 1
    % routine for VDC - P efficiency
    [ WaveR ] = performance_routine_vdc_P ( Wave ) ;
end
if Routine_PHI_P == 1
    % routine for phi - P efficiency
    [ WaveR ] = performance_routine_phi_P ( Wave ) ;
end
if Routine_P == 1
    % routine for P efficiency
    [ WaveR ] = performance_routine_P ( Wave ) ;
end
if Routine_M == 1
    % routine for P efficiency
    [ WaveR ] = performance_routine_M ( Wave ) ;
end
