%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('.\Functions'))
ccc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% set plotting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.plot_arm_volt = 1 ;
Wave.FFT.plotting = 1 ; % 0 no plotting / 1 simplified / 2 full
Wave.Input.plot_transition = 1 ; % to plot turn on / off transitions
Wave.Input.Plot_Filter_compliance = 1 ; % to plot the AC Filter design  

%%%%%%%%%%%%%%%%%%%%%%% set parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Wave.Input.Application = 'Grid Connected' ;
Wave.Input.nps = 2 ; % number of parallel switches 1/3

Wave.Input.vdc = 650 ; % V DC
Wave.Input.vll = 380 ; % V line-to-line
Wave.Input.Pmax = 4500 ;% kW 
Wave.Input.P = 4500 ; % kW
Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
Wave.Input.t_step = 0.5*1e-6 ; % time step
Wave.Input.fg = 50 ; % 50 Hz
Wave.Input.t = Wave.Input.t_step:Wave.Input.t_step:1/Wave.Input.fg; % 1 period
Wave.Input.fs = 16050 ; % 10 kHz
Wave.Input.phi = 0/180*pi ;
Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 

%%%%%%%%%% Topology / Modulation / N Wire selection / AC Filter %%%%%%%%%%%
% Wave.Input.Topology = 'Two Level';
Wave.Input.Topology = 'Two Level - SiC';

Wave.Input.Wire = 3 ; % 3 or 4 wire (3+VG) system

Wave.Input.C = 6.6e-6 ; 
Wave.Input.Lc = 950e-6 ;
Wave.Input.Lg = 720e-6 ;
Wave.Input.Rc = 1e-3 ; % damping resistors
Wave.Input.Rg = 1e-3 ; % damping resistors
Wave.Input.fres = 1/2/pi*sqrt((Wave.Input.Lc+Wave.Input.Lg)/Wave.Input.Lc/Wave.Input.Lg/Wave.Input.C);
Wave.Input.kres = Wave.Input.fres/Wave.Input.fs;

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

%% %%%%%%%%%%%%%%%%%%% Start Computations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate voltage
[ Wave ] = arm_voltage ( Wave ) ;

% fft of the voltage
[ Wave ] = volt_fft ( Wave ) ;

% define AC ripple in the current and check filter compliance
[ Wave ] = current_with_ripple ( Wave ) ;

% process current / find mean , rms and I on off and reverse recovery 
[ Wave ] = current_processing ( Wave ) ;

% load semiconductor data
[ Wave ] = semiconductor_data ( Wave ) ;

% calculate semiconductor losses
[ Wave ] = semiconductor_losses ( Wave ) ;

%% %%%%%%%%%%%%%%%%%%%%%%%% Print some results %%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ Wave ] = summary ( Wave ) ;
