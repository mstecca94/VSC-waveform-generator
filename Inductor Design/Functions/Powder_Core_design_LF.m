% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013 
function [ Core ] = Powder_Core_design_LF( Core )
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
Core.mir_peak = Core.InitPerm;

switch Core.CoreType
    case 'Toroidal' % Toroidal Powder Cores from Changsung
        fileID = fopen('coreData_Toroidal_LF.txt');
        C = textscan(fileID,'%q %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
        fclose(fileID);
        A = char(C{1});
        Core.MaxCorePArt = length(C{1});        
        if Core.Opt.Core_auto == 0
            for i=1:length(C{1})
                fprintf('Press %d for %s\n',i,A(i,:))
            end
            Core.co = input('\nWhich Core would you like to select?\n');
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = input('\nNumber of stack?\n');
        else
            Core.co =Core.k_core;
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = Core.k_stack;
        end
                
        %Load Core Dimensions
        Core.OD = C{1,2}(Core.co,1)*1e-3;  % [m] External Core Diameter
        Core.ID = C{1,2}(Core.co,2)*1e-3;  % [m] Internal Core Diameter
        Core.HT = Core.NumberfoStack*C{1,2}(Core.co,3)*1e-3;  % [m] Height of Core
        Core.e = 0.5*1e-3;               % [m] Winding to Core gap
        Core.Core_Volume = Core.HT*(pi*(Core.OD/2)^2 - pi*(Core.ID/2)^2);
        Core.le = (C{1,2}(Core.co,5))*0.01;% [m] Magnetic Path Length
        % [m2] Core Cross Section
        Core.Ae = Core.NumberfoStack*(C{1,2}(Core.co,6))*0.0001;
        Core.Aw = pi*((Core.ID-2*Core.e)/2)^2;%Window Area
        % [kg] Core Weight
        %Core.Core_Weightx = Core.NumberfoStack*(C{1,2}(Core.co,4))*1e-3;
        Core.Core_Weight = Core.Core_Volume*Core.Density.Core; %[kg]

    case 'UU' % UU Powder Cores from Changsung
        fileID = fopen('coreData_PowderCore_U-cores.txt');
        C = textscan(fileID,'%q %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
        fclose(fileID);
        A = char(C{1});
        Core.MaxCorePArt = length(C{1});        
        if Core.Opt.Core_auto == 0
            for i=1:length(C{1})
                fprintf('Press %d for %s\n',i,A(i,:))
            end
            Core.co = input('\nWhich Core would you like to select?\n');
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = input('\nNumber of stack?\n');
        else
            Core.co =Core.k_core;
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = Core.k_stack;
        end
        %Load Core Dimensions
        Core.a = C{1,2}(Core.co,2)*1e-3; % [m] Half of the Height of Core
        Core.b = C{1,2}(Core.co,1)*1e-3; % [m] Width of Core
        Core.c = C{1,2}(Core.co,3)*1e-3*Core.NumberfoStack; % [m] Length of Core
        Core.d = (C{1,2}(Core.co,2)-C{1,2}(Core.co,4))*1e-3; % [m] Height & Width of Core's Yoke & Limb
        Core.e = 0.5*1e-3;               % [m] Winding to Core gap-along the height
        Core.fi = 1.5*1e-3;                % [m] Inner Winding to Core gap-along the width
        Core.fo = 1.5*1e-3;                % [m] Outer Winding to Core gap-along the width
        Core.g = 3*1e-3;                 % [m] Winding to Winding gap in Window
        Core.hw= C{1,2}(Core.co,4)*1e-3; % [m] Winding to hight
        Core.le = (C{1,2}(Core.co,5))*0.01;% [m] Magnetic Path Length
        % [m2] Core Cross Section
        Core.Ae = Core.NumberfoStack*(C{1,2}(Core.co,6))*0.0001;
        Core.Aw = 2*(Core.hw-Core.e)*(Core.b-2*Core.d-Core.g-2*Core.fi);%Window Area
        Core.Core_Volume = ((2*Core.a*Core.b)-(2*(Core.a-Core.d)*(Core.b-2*Core.d)))*Core.c;
        Core.Core_Weight = Core.Core_Volume*Core.Density.Core; %[kg]
        
    case {'EE Integrated', 'EE'}
        fileID = fopen('coreData_PowderCore_E-cores.txt');
        C = textscan(fileID,'%q %f %f %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
        fclose(fileID);
        A = char(C{1});
        Core.MaxCorePArt = length(C{1});        
        if Core.Opt.Core_auto == 0
            for i=1:length(C{1})
                fprintf('Press %d for %s\n',i,A(i,:))
            end
            Core.co = input('\nWhich Core would you like to select?\n');
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = input('\nNumber of stack?\n');
        else
            Core.co =Core.k_core;
            Core.CorePart = A(Core.co,:);
            Core.NumberfoStack = Core.k_stack;
        end
        %Load Core Dimensions
        Core.a = C{1,2}(Core.co,2)*1e-3; % [m] Half of the Height of Core
        Core.b = C{1,2}(Core.co,1)*1e-3; % [m] Width of Core
        Core.c = C{1,2}(Core.co,3)*1e-3 * Core.NumberfoStack; % [m] Length of Core
        Core.d = (C{1,2}(Core.co,2)-C{1,2}(Core.co,4))*1e-3; % [m] Height & Width of Core's Yoke & Limb
        Core.e = 0.5*1e-3;                 % [m] Winding to Core gap-along the height
        Core.fi = 1.5*1e-3;                % [m] Inner Winding to Core gap-along the width
        Core.fo = 1.5*1e-3;                % [m] Outer Winding to Core gap-along the width
        Core.g = 3*1e-3;                   % [m] Winding to Winding gap in Window
        Core.di= C{1,2}(Core.co,5)*1e-3;
        Core.ml= C{1,2}(Core.co,6)*1e-3;
        Core.hw= C{1,2}(Core.co,4)*1e-3;
        Core.do = Core.b;
        Core.le = (C{1,2}(Core.co,7))*0.01;% [m] Magnetic Path Length
        % [m2] Core Cross Section
        Core.Ae = Core.NumberfoStack*(C{1,2}(Core.co,8))*0.0001;
        Core.Aw = 2*(Core.hw-Core.e)*(Core.di/2-Core.ml/2-Core.fi-Core.fo);%Window Area
        Core.Core_Volume = 2*((Core.b*Core.a)-((Core.di-Core.ml)*Core.hw))*Core.c;  
        Core.Core_Weight = Core.Core_Volume*Core.Density.Core; %[kg]        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine Number of Turns and Airgap for Lrated
uo = 4*pi*1e-7; %Permeability of the Air
if (Core.Opt.N_auto == 1)
    if strcmp(Core.CoreType,'Toroidal')
        Core.N = ceil(sqrt(Core.le*Core.LRated/(0.8*Core.InitPerm*uo*Core.Ae)));
        Core.lg = 0;
    else
        %Core.N = ceil(Core.LRated*Core.Ipk_Rated/(0.8*Core.Bsmax*Core.Ae));
        Core.N = ceil(sqrt(Core.le*Core.LRated/(0.8*Core.InitPerm*uo*Core.Ae)));
        if strcmp(Core.CoreType,'UU')
            Core.N = 2*ceil(Core.N/2);
        end
        if (Core.Opt.CalcAirGap~=1)
            Core.lg = input('What air-gap length would you like to have [m]?\n');
        else
            % Calculate Airgap
            Core.MaxAirGap = 0.01;
            [ Core ] = airgap_calc( Core );
            Core.lg = Core.d_GAP_calc;
        end
    end
else
    Core.N = input('\nNumber of Turns you Would Like to Select?\n');
    if strcmp(Core.CoreType,'Toroidal')
        Core.lg = 0;
    else
        if (Core.Opt.CalcAirGap~=1)
            Core.lg = input('What air-gap length would you like to have [m]?\n');
        else
            % Calculate Airgap
            Core.MaxAirGap = 0.01;
            [ Core ] = airgap_calc( Core );
            Core.lg = Core.d_GAP_calc;
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Winding Selection
Core.Wire.d_ISO = 0.1e-3;  % [m] Wire Isolation Distances
% Strand Part Number for Litz Wire
if (Core.Winding.RoundWire_Stranded == 1) % Litz Wire
    Core.Wire.fill = 0.8;      % [m] Fill factor of Litz Wire
    Core.e = 1e-3;            % [m] Bobine Distance to Core
    
    fileID = fopen('AWG_wire_Table.txt');
    W = textscan(fileID,'%q %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
    fclose(fileID);
    A = char(W{1});
    if Core.Opt.AWG_auto==1
        if (Core.fsMax<1e3)
            Core.Wire.wo = 28;
        elseif ((Core.fsMax>=1e3)&&(Core.fsMax<10e3))
            Core.Wire.wo = 31;
        elseif ((Core.fsMax>=10e3)&&(Core.fsMax<20e3))
            Core.Wire.wo = 34;
        elseif ((Core.fsMax>=20e3)&&(Core.fsMax<50e3))
            Core.Wire.wo = 37;
        elseif ((Core.fsMax>=50e3)&&(Core.fsMax<100e3))
            Core.Wire.wo = 39;
        elseif ((Core.fsMax>=100e3)&&(Core.fsMax<200e3))
            Core.Wire.wo = 41;
        else
            Core.Wire.wo = 41;
        end
    else
        for i=1:length(W{1})
            fprintf('Press %d for %s\n',i,A(i,:))
        end
        Core.Wire.wo = input('\nWhich wire strand would you like to select?\n');
    end
    Core.Wire.AWGPart = A(Core.Wire.wo,:);
    Core.Wire.d_strand = W{1,2}(Core.Wire.wo,2)*1e-3; %[m] Diameter of a single strand
end

% Diameter of Wire
if Core.Opt.DiamWire_auto==1
    Core.Wire.d_wire = 1.0*sqrt(Core.Aw/Core.N)-2*Core.Wire.d_ISO;
else
    Core.Wire.d_wire = input('\nWhich is the diameter of wire would you like to select[m]?\n');
end

% Core Turn Length
switch Core.CoreType
    case 'Toroidal' % Toroidal Powder Cores from Changsung
        % Wire Fitting in maximum 2 Layers
        hw_i1 = 2*pi*(Core.ID/2-Core.e-Core.Wire.d_wire/2-Core.Wire.d_ISO); % [m] largest window height for inner windings
        Nmax_p = floor(hw_i1/(Core.Wire.d_wire + 2*Core.Wire.d_ISO));
        Core.Nmax_p=Nmax_p;
        hw_i2 = 2*pi*(Core.ID/2-Core.e-3*Core.Wire.d_wire/2-3*Core.Wire.d_ISO); % [m] largest window height for inner windings
        Nmax_s = floor(hw_i2/(Core.Wire.d_wire + 2*Core.Wire.d_ISO));
        while Core.N > (Nmax_p+Nmax_s) % Approx. Maximum 2 Layers
            Core.Wire.d_wire = Core.Wire.d_wire - 0.0001;
            Nmax_p = floor(hw_i1/(Core.Wire.d_wire + 2*Core.Wire.d_ISO));
            Nmax_s = floor(hw_i2/(Core.Wire.d_wire + 2*Core.Wire.d_ISO));
        end
        %Core.Wire.Window_Utilization_ku = Core.N*(Core.Wire.d_wire+2*Core.Wire.d_ISO)^2/(Core.ID-2*Core.e)^2;
        Core.Wire.Turn_Length = Core.N*2*( (Core.OD-Core.ID)/2 + 2.5*Core.Wire.d_wire + 2e-3 + (Core.HT + 2e-3 + 2*Core.Wire.d_wire)  );
        
    case 'UU' % UU Powder Cores from Changsung
        d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
        NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
        NL = ceil(Core.N/2/NM); %Number of Layers
        while (NL*d_w>(Core.b-2*Core.d- 2*Core.fi)/2)
            Core.Wire.d_wire = Core.Wire.d_wire - 0.0001;
            d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
            NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
            NL = ceil(Core.N/2/NM);  %Number of Layers
        end
        if NL ==1
            FR1 = Core.d + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            Core.Wire.Turn_Length = Core.N*2*(FR1+SS1);
        elseif (NL==2)
            FR1 = Core.d + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            FR2 = Core.d + 2*Core.fi + 4*Core.Wire.d_wire;
            SS2 = Core.c + 2*Core.fi + 4*Core.Wire.d_wire;
            Core.Wire.Turn_Length = 2*(NM*2*(FR1+SS1)+ 2*(Core.N/2-NM)*(FR2+SS2));
        else
            FR = Core.d + (Core.b-2*Core.d)/4;
            SS = Core.c + (Core.b-2*Core.d)/4;
            Core.Wire.Turn_Length = Core.N*2*(FR+SS);
        end
        
    case 'EE' % EE Powder Cores from Changsung
        d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
        NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
        NL = ceil(Core.N/NM);  %Number of Layers
        
        while (NL*d_w>(Core.di/2-Core.ml/2 - 2*Core.fi))
            Core.Wire.d_wire = Core.Wire.d_wire - 0.0001;
            d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
            NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
            NL = ceil(Core.N/NM);  %Number of Layers
        end
                
        if NL ==1
            FR1 = Core.ml + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            Core.Wire.Turn_Length = Core.N*2*(FR1+SS1);
        elseif (NL==2)
            FR1 = Core.ml + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            FR2 = Core.ml + 2*Core.fi + 4*Core.Wire.d_wire;
            SS2 = Core.c + 2*Core.fi + 4*Core.Wire.d_wire;
            Core.Wire.Turn_Length = 2*(NM*(FR1+SS1)+ (Core.N-NM)*(FR2+SS2));
        else
            FR = Core.ml + (Core.di-Core.ml)/2;
            SS = Core.c + (Core.di-Core.ml)/2;
            Core.Wire.Turn_Length = Core.N*2*(FR+SS);
        end
        
    case 'EE Integrated' % EE Powder Cores from Changsung
        d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
        NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
        NL = ceil(Core.N/NM);  %Number of Layers
        
        while (NL*d_w>(Core.di/2-Core.ml/2 - 2*Core.fi))
            Core.Wire.d_wire = Core.Wire.d_wire - 0.0001;
            d_w = (Core.Wire.d_wire + 2*Core.Wire.d_ISO);
            NM = floor(2*(Core.hw-Core.e)/d_w); % Max. possible No. of Turns per layer
            NL = ceil(Core.N/NM);  %Number of Layers
        end
        
        if NL ==1
            FR1 = (Core.do-Core.di)/2 + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            Core.Wire.Turn_Length = 2*Core.N*2*(FR1+SS1);
        elseif (NL==2)
            FR1 = (Core.do-Core.di)/2 + 2*Core.fi + 2*Core.Wire.d_wire;
            SS1 = Core.c + 2*Core.fi + 2*Core.Wire.d_wire;
            FR2 = (Core.do-Core.di)/2 + 2*Core.fi + 4*Core.Wire.d_wire;
            SS2 = Core.c + 2*Core.fi + 4*Core.Wire.d_wire;
            Core.Wire.Turn_Length = 2*2*(NM*(FR1+SS1)+ (Core.N-NM)*(FR2+SS2));
        else
            FR = (Core.do-Core.di)/2 + (Core.di-Core.ml)/2;
            SS = Core.c + (Core.di-Core.ml)/2;
            Core.Wire.Turn_Length = 2*Core.N*2*(FR+SS);
        end
end

if (Core.Winding.RoundWire_Stranded == 1) % Litz Wire
    Core.Wire.n_strand = floor(Core.Wire.fill*(Core.Wire.d_wire)^2/Core.Wire.d_strand^2);
else
    Core.Wire.n_strand = 1;
    Core.Wire.d_strand = Core.Wire.d_wire;
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
Core.Wire.CondVolume = (Core.Wire.Turn_Length*(pi*(Core.Wire.d_strand/2)^2))*Core.Wire.n_strand;
Core.Wire_Weight = Core.Wire.Cond_Density*Core.Wire.CondVolume;
Core.Result.Total_Weight = Core.Core_Weight + Core.Wire_Weight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inductance Calculation
switch Core.CoreType
    case 'Toroidal' % Toroidal Powder Cores from Changsung
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

    case 'UU' % UU Powder Cores from Changsung
        % Plot Inductance
        % Relative Permeability
        a = Core.Perm_DC(1,1);
        b = Core.Perm_DC(1,2);
        c = Core.Perm_DC(1,3);
        Vecp = 2000;
        IL_vec(Vecp,1) = 0;
        L_vec(Vecp,1) = 0;
        mir_v(Vecp,1) = 0;
        for k = 1:Vecp
            IL_vec(k,1) = (k-1)*Core.Ipk_Short/Vecp;
            Hp = 0.4e-2*pi*Core.N*IL_vec(k,1)/Core.le;
            mir = Core.InitPerm*( 1 / (a + b*Hp^c) )/100; 
            mir_v(k,1)= mir;
            Rair_in = Rel_airgap(Core.lg,Core.d,Core.c,Core.hw,1);
            Rcent_leg = Rel_core(Core.b-2*Core.d,Core.a-Core.hw,Core.c,mir,1) + 2*( Rel_core(Core.d,Core.d,Core.c,mir,2)+ Rel_core(Core.hw,Core.d,Core.c,mir,1));
            R_m_Total = 2*(Rair_in + Rcent_leg);
            L_vec(k,1) = Core.N^2/R_m_Total;            
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
        
    case 'EE' % UU Powder Cores from Changsung
        % Plot Inductance
        % Relative Permeability
        a = Core.Perm_DC(1,1);
        b = Core.Perm_DC(1,2);
        c = Core.Perm_DC(1,3);
        Vecp = 2000;
        IL_vec(Vecp,1) = 0;
        L_vec(Vecp,1) = 0;
        mir_v(Vecp,1) = 0;
        for k = 1:Vecp
            IL_vec(k,1) = (k-1)*Core.Ipk_Short/Vecp;
            Hp = 0.4e-2*pi*Core.N*IL_vec(k,1)/Core.le;
            mir = Core.InitPerm*( 1 / (a + b*Hp^c) )/100;
            mir_v(k,1)= mir;
            Rair_in = Rel_airgap(Core.lg,Core.ml,Core.c,Core.hw,1);
            Rair_out = Rel_airgap(Core.lg,(Core.b-Core.di)/2,Core.c,Core.hw,1);
            Rcent_leg = Rel_core(Core.hw,Core.ml,Core.c,mir,1);
            Rout_leg = Rel_core(Core.ml,Core.a-Core.hw,Core.c,mir,2)/2 + Rel_core((Core.b-Core.di)/2,Core.a-Core.hw,Core.c,mir,2) + Rel_core(Core.hw,(Core.b-Core.di)/2,Core.c,mir,1) + Rel_core((Core.di-Core.ml)/2,Core.a-Core.hw,Core.c,mir,1);            
            R_m_Total = (Rair_in + 2*Rcent_leg) + 1/2*(Rair_out + 2*Rout_leg);
            L_vec(k,1) = Core.N^2/R_m_Total;            
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
        
    case 'EE Integrated'
        % Plot Inductance
        % Relative Permeability
        a = Core.Perm_DC(1,1);
        b = Core.Perm_DC(1,2);
        c = Core.Perm_DC(1,3);
        Vecp = 2000;
        IL_vec(Vecp,1) = 0;
        L_vec(Vecp,1) = 0;
        mir_v(Vecp,1) = 0;
        du = Core.a-Core.hw;
        de = (Core.do-Core.di)/2;
        uo = 4*pi*1e-7; %Air permeability
        for k = 1:Vecp
            IL_vec(k,1) = (k-1)*Core.Ipk_Short/Vecp;
            Hp = 0.4e-2*pi*Core.N*IL_vec(k,1)/Core.le;
            mir = Core.InitPerm*( 1 / (a + b*Hp^c) )/100;
            mir_v(k,1)= mir;
            %Core Reluctance
            R1 = Rel_core(2*Core.hw,de,Core.c,mir,1) + Rel_core(2*(Core.di-Core.ml)/2,du,Core.c,mir,1) + 2*Rel_core(de,du,Core.c,mir,2)+ 2*Rel_core(Core.ml,du,Core.c,mir,2)/2;
            %Air Reluctance
            Rel_m = Core.lg/(uo*Core.ml*Core.c);
            if Core.lg == 0
                Relair = 0;
            else
                sigma_y = fringing_factor(Core.lg,Core.ml,Core.hw,1);
                sigma_x = fringing_factor(Core.lg,Core.c,Core.hw,1);
                sigma= sigma_y*sigma_x;
                Relair=Rel_m*sigma;
            end            
            Rc = Rel_core(2*Core.hw+du,Core.ml,Core.c,mir,1) + Relair;
            Lself_theo = Core.N^2*(R1+Rc)/(R1*(R1+Rc)+Rc*R1);
            M12_theo = Core.N^2*(Rc)/(R1*(R1+Rc)+Rc*R1);
            L_vec(k,1) = (Lself_theo - M12_theo);          
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
%Core.BadResult=0;        
if Core.L_peak < Core.LminRated || Core.L_short < Core.LminShort
%     fprintf('Note that Lmin is not attained!\n');
    Core.BadResult=1;
else
%     fprintf('Design Fullfil Lmin Requirement!\n');
    Core.BadResult=0; 
end

end

