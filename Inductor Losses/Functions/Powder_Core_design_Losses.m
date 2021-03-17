% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013 
function [ Core ] = Powder_Core_design_Losses( Core )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Core Selection 
switch Core.MaterialType
        % TO BE ADDED  More MPP, Sendust, Mega Flux
        
    case 'Sendust 26u'
        Core.Density.Core = 5500.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 26; 
        % Maximum Flux Density [T]
        Core.Bsmax = 1.0; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 1.23e-6;
        c = 1.697;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.048;
        kb = 4.245;
        kc = 0.0215; 
        kd = 1.990;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 1.36E-4;
        Core.Steimtz.alpha = 1.14;
        Core.Steimtz.beta = 2.048;        
        
    case 'Sendust 60u'
        Core.Density.Core = 5500.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 60;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.0; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 2.75e-6;
        c = 1.782;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.207;
        kb = 4.518;
        kc = 0.0244; 
        kd = 1.967;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 2.202E-4;
        Core.Steimtz.alpha = 1.133;
        Core.Steimtz.beta = 2.207;  
        
    case 'MPP 26u'
        Core.Density.Core = 7300.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 26; 
        % Maximum Flux Density [T]
        Core.Bsmax = 0.70; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 14.2e-8;
        c = 2.030;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.183;
        kb = 2.485;
        kc = 0.0125; 
        kd = 2.099;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 5.691E-5;
        Core.Steimtz.alpha = 1.209;
        Core.Steimtz.beta = 2.183;        
        
    case 'MPP 60u'
        Core.Density.Core = 7300.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 60;
        % Maximum Flux Density [T]
        Core.Bsmax = 0.70; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 12.7e-8;
        c = 2.412;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.183;
        kb = 2.485;
        kc = 0.0125; 
        kd = 2.099;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 5.691E-5;
        Core.Steimtz.alpha = 1.209;
        Core.Steimtz.beta = 2.183;  
        
    case 'Mega Flux 26u'
        Core.Density.Core = 6400.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 26; 
        % Maximum Flux Density [T]
        Core.Bsmax = 1.6; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 9.96e-8;
        c = 1.883;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.166;
        kb = 9.918;
        kc = 0.0519; 
        kd = 2.061;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 2.674E-4;
        Core.Steimtz.alpha = 1.187;
        Core.Steimtz.beta = 2.166;        
        
    case 'Mega Flux 50u'
        Core.Density.Core = 6400.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 50;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.6; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 7.35e-8;
        c = 2.177;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.145;
        kb = 8.874;
        kc = 0.0632;
        kd = 1.980;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 2.6E-4;
        Core.Steimtz.alpha = 1.174;
        Core.Steimtz.beta = 2.145;
        
    case 'High Flux 26u'
        Core.Density.Core = 6900.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 26; 
        % Maximum Flux Density [T]
        Core.Bsmax = 1.5; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 3.41e-8;
        c = 2.087;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.252;
        kb = 4.081;
        kc = 0.0006; 
        kd = 2.736;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 2.06E-4;
        Core.Steimtz.alpha = 1.1332;
        Core.Steimtz.beta = 2.252;        
        
    case 'High Flux 60u'
        Core.Density.Core = 6900.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 60;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.5; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 5.42e-8;
        c = 2.326;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.284;
        kb = 3.050;
        kc = 0.0023;
        kd = 2.397;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 1.59E-4;
        Core.Steimtz.alpha = 1.142;
        Core.Steimtz.beta = 2.284;
        
    case 'High Flux 125u'
        Core.Density.Core = 6900.0;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 125;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.5; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 2.09e-7;
        c = 2.386;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.165;
        kb = 1.736;
        kc = 0.1793;
        kd = 1.780;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 6.561E-6;
        Core.Steimtz.alpha = 1.448;
        Core.Steimtz.beta = 2.165;
        
    case 'High Flux 147u'
        Core.Density.Core = 6900;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 147;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.5; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 1.16e-7;
        c = 2.619;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.104;
        kb = 2.117;
        kc = 0.1131;
        kd = 1.899;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/kg], B:[T], f:[Hz]
        Core.Steimtz.ko = 5.313E-6;
        Core.Steimtz.alpha = 1.462;
        Core.Steimtz.beta = 2.104;
        
    case 'High Flux 160u'
        Core.Density.Core = 6900;  % [Kg/m^3] Core Density
        % Initial Permeability
        Core.InitPerm = 160;
        % Maximum Flux Density [T]
        Core.Bsmax = 1.5; 
        % [%] Initial Permeability Vs. DC Bias in Oe (%Perm = 1 / (a + b*H^c))
        a = 0.01;
        b = 2.5e-7;
        c = 2.475;
        Core.Perm_DC = [a, b, c];        
        % Core Loss (P = B^ka * (kb*f + kc*f^kd)) P:[mW/cm3], B:[kGauss], f:[kHz]
        ka = 2.104;
        kb = 2.117;
        kc = 0.1131;
        kd = 1.899;
        Core.matLoss = [ka, kb, kc, kd];
        % Core Loss (P = ko * (B^beta) * (f^Alpha)) P:[W/cm3], B:[T], f:[Hz]
        Core.Steimtz.ko = 5.313E-6;
        Core.Steimtz.alpha = 1.462;
        Core.Steimtz.beta = 2.104;
end
if strcmp(Core.CondMat,'CU')
    T = Core.Tmax; % Temperature winding for the worst case scenario
    sigmax = 1 / (0.01784e-6 * (1 + 3.92e-3 * (T - 20)));
    Core.Wire.sigma = sigmax;      % [S/m] Conductivty of Copper 20Deg 59.6e6; 100Deg 45.4e6
    Core.Wire.Cond_Density = 8960; % [Kg/m^3] Density of Copper
elseif strcmp(Core.CondMat,'AL')
    T = Core.Tmax; % Temperature winding for the worst case scenario
    sigmax = 1 / (0.0282e-6 * (1 + 3.9e-3 * (T - 20)));
    Core.Wire.sigma = sigmax;             % [S/m] Conductivty of Aluminium 20Deg 35e6; 100Deg 27e6
    Core.Wire.Cond_Density = 2750; % [Kg/m^3] Density of Aluminium
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inductance Calculation
 % Toroidal Powder Cores from Changsung
% DC Bias in Oe
Hpeak = 0.4e-2*pi*Core.N*Core.Ipk_Rated/Core.le;
Hshort = 0.4e-2*pi*Core.N*Core.Ipk_Short/Core.le;

% Relative Permeability
a = Core.Perm_DC(1,1);
b = Core.Perm_DC(1,2);
c = Core.Perm_DC(1,3);
Core.Rela_Perm_Peak = Core.InitPerm*( 1 / (a + b*Hpeak^c) )/100;
Core.Rela_Perm_Short = Core.InitPerm*( 1 / (a + b*Hshort^c) )/100;

% Inductance Calculations
%Core.L_0A = Core.N^2*Core.InitPerm*uo*Core.Ae/Core.le;
%Core.L_peak = Core.N^2*Core.Rela_Perm_Peak*uo*Core.Ae/Core.le;
%Core.L_short = Core.N^2*Core.Rela_Perm_Short*uo*Core.Ae/Core.le;
uo = 4*pi*1e-7; %Permeability of the Air

% Plot Inductance
Vecp = 2000;
IL_vec(Vecp,1) = 0;
L_vec(Vecp,1) = 0;
mir_v(Vecp,1) = 0;
for k = 1:Vecp
    IL_vec(k,1) = (k-1)*Core.Ipk_Short/Vecp;
    Hp = 0.4e-2*pi*Core.N*IL_vec(k,1)/Core.le;
    mir = Core.InitPerm*( 1 / (a + b*Hp^c) )/100;
    mir_v(k,1)= mir;
    L_vec(k,1) = Core.N^2*mir*uo*Core.Ae/Core.le;
end
Core.L_0A = L_vec(1,1);
Core.L_peak = pchip(IL_vec,L_vec,Core.Ipk_Rated);
Core.L_short = L_vec(Vecp,1);
Core.mir_0A = mir_v(1,1);
Core.mir_peak = pchip(IL_vec,mir_v,Core.Ipk_Rated);
Core.mir_short = mir_v(Vecp,1);
Core.Result.Wav.IL = IL_vec;
Core.Result.Wav.L_vec = L_vec;
Core.Result.Wav.mir = mir_v;    
   

    

end

