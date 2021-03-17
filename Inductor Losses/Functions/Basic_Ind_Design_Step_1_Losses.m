function [ Core , Converter , pareto , Result] = Basic_Ind_Design_Step_1_Losses ( Converter , Core )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                  Basic Design Converter Side Inductor
    Core.Winding.RoundWire_Stranded = 1; % For Wire Round Litz set =1
    Core.Winding.RoundWire_Solid = 0; % For Wire Round Solid set =1 
    Converter.Spec.Inductor.Wire.Opt.Core_auto = 1; %Auto Select Core
    Converter.Spec.Inductor.Wire.Opt.AWG_auto = 1; %Auto Select Litz strand
    Converter.Spec.Inductor.Wire.Opt.N_auto = 1; %Auto Select Number of Turns
    Converter.Spec.Inductor.Wire.Opt.CalcAirGap=1;%Auto Select AirGap
    Converter.Spec.Inductor.Wire.Opt.DiamWire_auto=1; %Auto Select Wire Diameter
    Converter.Spec.Inductor.fsN = Converter.Spec.f_sup;  % [Hz] Grid Frequency
    Converter.Spec.Inductor.fsMax = Converter.Spec.fsw_val;  % [Hz] Switching Frequency
    Converter.Spec.Inductor.LRated = Converter.Spec.L1_val; % Inductance at 0A
    Converter.Spec.Inductor.LminRated = 0.8*Converter.Spec.Inductor.LRated; % Minimum Inductance at the Peak Current with Nominal Load (Rated Uin, Po)
    Converter.Spec.Inductor.Ipk_Rated = 2*Converter.Spec.Pmax/3/Converter.Spec.Ugp;
    Converter.Spec.Inductor.LminShort = 0.6*Converter.Spec.Inductor.LRated; % Minimum Inductance at the Peak Current with Highest allowed Current
    Converter.Spec.Inductor.Ipk_Short = 3.0*Converter.Spec.Pmax/3/Converter.Spec.Ugp;
    Converter.Spec.Inductor.Ipp_Fs  = 2*max(Converter.Wav.D_iLpha); %Peak-to-peak current at switching Freq
    Converter.Spec.Inductor.Tamb = Converter.Spec.Tamb; % Ambient Temperature
    Converter.Spec.Inductor.Tmax = 150;  % Inductor Temperature
    % Adapt Inputs
    Core.Yes_Plot = 0;
    Core.Max_Stack = 10;                          % Maximum Number of Stacked Cores
    Core.LRated = Converter.Spec.Inductor.LRated; % Inductance at 0A
    Core.LminRated = Converter.Spec.Inductor.LminRated; % Minimum Inductance at the Peak Current with Nominal Load (Rated Uin, Po)
    Core.Ipk_Rated = Converter.Spec.Inductor.Ipk_Rated;
    Core.LminShort = Converter.Spec.Inductor.LminShort; % Minimum Inductance at the Peak Current with Highest allowed Current
    Core.Ipk_Short = Converter.Spec.Inductor.Ipk_Short;
    Core.Ipp_Fs  = Converter.Spec.Inductor.Ipp_Fs; %Peak-to-peak current at switching Freq
    Core.Tamb = Converter.Spec.Inductor.Tamb; % Ambient Temperature
    Core.Tmax = Converter.Spec.Inductor.Tmax;  % Inductor Temperature
    Core.CondMat= Converter.Spec.Inductor.Wire.CondMat;
    Core.Opt.Core_auto = Converter.Spec.Inductor.Wire.Opt.Core_auto; %Auto Select Core
    Core.Opt.AWG_auto = Converter.Spec.Inductor.Wire.Opt.AWG_auto; %Auto Select Litz strand
    Core.Opt.N_auto = Converter.Spec.Inductor.Wire.Opt.N_auto; %Auto Select Number of Turns
    Core.Opt.CalcAirGap= Converter.Spec.Inductor.Wire.Opt.CalcAirGap;%Auto Select Number of Turns
    Core.Opt.DiamWire_auto=Converter.Spec.Inductor.Wire.Opt.DiamWire_auto; %Auto Select Wire Diameter
    Core.fsN = Converter.Spec.Inductor.fsN;  % [Hz] Grid Frequency
    Core.fsMax = Converter.Spec.Inductor.fsMax;  % [Hz] Switching Frequency
    
    % Call Basic Design Function 

%     Core.k_core = k_core;
%     Core.k_stack = k_stack;
    [ Core ] = Powder_Core_design_Losses( Core ); % OK

    % Converter Side Core Loss Calculation
    B_m = Converter.Wav.B_fluxA(1,:)/Core.N/Core.Ae;
    time = Converter.Wav.Time(1,:);
    ko = Core.Steimtz.ko;
    alpha = Core.Steimtz.alpha;
    beta = Core.Steimtz.beta;
    [coreloss_iGSEx, num_minorloop] = coreloss_iGSE_Losses(B_m,time,ko,alpha,beta); % OK
    Core.Pc = 1e6*Core.Core_Volume*coreloss_iGSEx;

    % Converter Side Winding Loss Calculation
    Core.Ipp_Fs  = 2*max(Converter.Wav.D_iLpha);
    [ Core ] = Wdg_Loss_Analyt_Losses( Core ); % OK
                        
    %Temperature Calculation
    Core.Total_Loss = Core.Pw + Core.Pc;
    [ Core ] = Temperature_Calc_Losses( Core ); % OK
    Converter.Result.Inductor.Temp = Core.Inductor.Temp;
%                         close all;
    % Save Some Results
    Result.CoreType = Core.CoreType;
    Result.CorePart= Core.CorePart;
    Result.NumberfoStack = Core.NumberfoStack;
    Result.MaterialType = Core.MaterialType;
    Result.NumberofTurns = Core.N;
    Result.AirGap = Core.lg;
    Result.Wire_Diameter = Core.Wire.d_wire;
    Result.Wire_Sigma = Core.Wire.sigma;
    Result.Wire_d_strand = Core.Wire.d_strand;
    Result.Wire_d_ISO = Core.Wire.d_ISO;
    Result.Wire_Material= Core.CondMat;
    Result.Wire_AWGPart = Core.Wire.AWGPart;
    Result.Wire_n_strand = Core.Wire.n_strand;

    Result.Total_Weight =  Core.Result.Total_Weight;
    Result.Core_Weight = Core.Core_Weight;
    Result.Wire_Weight = Core.Wire_Weight;
    Result.Core_Loss = Core.Pc;
    Result.Wire_Pskin = Core.Pskin;
    Result.Wire_Pprox= Core.Pprox;
    Result.Wire_Loss = Core.Pw;
    Result.Total_Loss = Core.Pw+Core.Pc;

    Result.L_0A = Core.L_0A;
    Result.L_IPeak = Core.L_peak;
    Result.L_IShort = Core.L_short;
    Result.Bamx = max(B_m);                        
    Result.Inductor_Temp = Core.Inductor.Temp;
    % additional data for FEMM 
    Result.Core_mir_peak = Core.mir_peak;
    Result.Core_InitPerm = Core.InitPerm;
    Result.Core_OD = Core.OD;
    Result.Core_ID = Core.ID ;
    Result.Core_HT = Core.HT ;
    Result.Core_e = Core.e;
%                         Result.Core_wg = Core.wg;
    Result.Core_N = Core.N;
    Result.Core_Wire_Turn_Length = Core.Wire.Turn_Length;
    Result.Core_RoundWire_Stranded = Core.Winding.RoundWire_Stranded ;
    Result.Core_RoundWire_Solid = Core.Winding.RoundWire_Solid ;
    Result.Core_CondMat = Core.CondMat ;

    Result.CrossSect= Core.Ae;
    Result.ExtDiam= Core.OD;
    Result.CoreHeight= Core.HT;

    pareto.Result = Result;

    Core.CoreType = Converter.Spec.Inductor.Core.CoreType;
    Core.MaterialType = Converter.Spec.Inductor.Core.MaterialType;
    
    [ Core ] = Powder_Core_design_Losses ( Core ); % OK
    % Save Some Results
    Converter.Result.Inductor.CoreType = Core.CoreType;
    Converter.Result.Inductor.CorePart= Core.CorePart;
    Converter.Result.Inductor.NumberfoStack = Core.NumberfoStack;
    Converter.Result.Inductor.MaterialType = Core.MaterialType;
    Converter.Result.Inductor.NumberofTurns = Core.N;
    Converter.Result.Inductor.AirGap = Core.lg;
    Converter.Result.Inductor.Wire_Diameter = Core.Wire.d_wire;
    Converter.Result.Inductor.Wire_Material= Core.CondMat;
    Converter.Result.Inductor.Wire_AWGPart = Core.Wire.AWGPart;
    Converter.Result.Inductor.Wire_n_strand = Core.Wire.n_strand;

    Converter.Result.Inductor.Core_Weight = Core.Core_Weight;
    Converter.Result.Inductor.Wire_Weight = Core.Wire_Weight;
    Converter.Result.Inductor.Total_Weight =  Core.Result.Total_Weight;

    Converter.Result.Inductor.L_0A = Core.L_0A;
    Converter.Result.Inductor.L_IPeak = Core.L_peak;
    Converter.Result.Inductor.L_IShort = Core.L_short;
 
    % Consider Variation of Inductor Value
    Converter.Spec.L1_val = Core.Result.Wav.L_vec(1,1);
    Converter.Spec.L1_Vvar = Core.Result.Wav.L_vec/Converter.Spec.L1_val; %Variation of Lf as function of Current
    Converter.Spec.L1_Ivar = Core.Result.Wav.IL; %Variation of Lf as function of Current
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end