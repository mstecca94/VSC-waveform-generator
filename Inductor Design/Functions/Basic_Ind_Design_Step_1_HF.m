function [ Core , Converter , pareto , Result] = Basic_Ind_Design_Step_1_HF ( Converter )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                  Basic Design Converter Side Inductor
    Core.Winding.RoundWire_Stranded = 1; % For Wire Round Litz set =1
    Core.Winding.RoundWire_Solid = 0; % For Wire Round Solid set =1 
    Converter.Spec.Inductor.Core.CoreType = {'Toroidal'};
    %Converter.Spec.Inductor.Core.CoreType = [{'Toroidal'}, {'UU'}];
    %Converter.Spec.Inductor.Core.CoreType = [{'Toroidal'}, {'EE'}];
    %Converter.Spec.Inductor.Core.CoreType = [{'Toroidal'}, {'EE'}, {'UU'}];
    %Converter.Spec.Inductor.Core.CoreType = {'UU'};
    %Converter.Spec.Inductor.Core.CoreType = {'EE'};
    %Converter.Spec.Inductor.Core.MaterialType = {'Sendust 26u'};
%     Converter.Spec.Inductor.Core.MaterialType = {'High Flux 26u'};
%     Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'High Flux 60u'}, {'Sendust 26u'}, {'Sendust 60u'}];
%     Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'Sendust 26u'}];
    %Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'High Flux 60u'}];
%     Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'High Flux 60u'}, {'Mega Flux 26u'}, {'Mega Flux 50u'}];
%     Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'High Flux 60u'}, {'MPP 26u'}, {'MPP 60u'}, {'Sendust 26u'}, {'Sendust 60u'}];
    Converter.Spec.Inductor.Core.MaterialType = [{'High Flux 26u'}, {'High Flux 60u'}, {'Mega Flux 26u'}, {'Mega Flux 50u'}, {'MPP 26u'}, {'MPP 60u'}, {'Sendust 26u'}, {'Sendust 60u'}];
    Converter.Spec.Inductor.Wire.CondMat= 'CU';
%     Converter.Spec.Inductor.Wire.CondMat= 'AL';
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
    TotalMass = 9999999999;
    k_core_Typ_B=1;
    k_core_Mat_B=1;
    k_core_B = 1;
    k_stack_B = 1;
    Core.MaxCTyp = length(Converter.Spec.Inductor.Core.CoreType);
    Core.MaxCMat = length(Converter.Spec.Inductor.Core.MaterialType);
    for k_core_Typ=1:Core.MaxCTyp
        Core.CoreType = Converter.Spec.Inductor.Core.CoreType{k_core_Typ};
        switch Core.CoreType
            case 'Toroidal' % Toroidal Powder Cores from Changsung
                fileID = fopen('coreData_Toroidal.txt');
                C = textscan(fileID,'%q %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
                fclose(fileID);
                MaxCorePArt(k_core_Typ) = length(C{1});
            case 'UU' % UU Powder Cores from Changsung
                fileID = fopen('coreData_PowderCore_U-cores.txt');
                C = textscan(fileID,'%q %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
                fclose(fileID);
                MaxCorePArt(k_core_Typ) = length(C{1});
            case 'EE'
                fileID = fopen('coreData_PowderCore_E-cores.txt');
                C = textscan(fileID,'%q %f %f %f %f %f %f %f %f','Delimiter',',','TreatAsEmpty',{'NA','na'},'CommentStyle','//','CollectOutput',true);
                fclose(fileID);
                MaxCorePArt(k_core_Typ) = length(C{1});
        end
        for k_core_Mat=1:Core.MaxCMat
            Core.MaterialType = Converter.Spec.Inductor.Core.MaterialType{k_core_Mat};
%             simcnt;
            if Core.Opt.Core_auto == 1
                for k_core=1:MaxCorePArt(k_core_Typ)
                    for k_stack=1:Core.Max_Stack
                        Core.BadResult = 1;
                        Core.k_core = k_core;
                        Core.k_stack = k_stack;
                        [ Core ] = Powder_Core_design( Core );
                        
                        % Converter Side Core Loss Calculation
                        B_m = Converter.Wav.B_fluxA(1,:)/Core.N/Core.Ae;
                        time = Converter.Wav.Time(1,:);
                        ko = Core.Steimtz.ko;
                        alpha = Core.Steimtz.alpha;
                        beta = Core.Steimtz.beta;
                        [coreloss_iGSEx, num_minorloop] = coreloss_iGSE(B_m,time,ko,alpha,beta);
                        Core.Pc = 1e6*Core.Core_Volume*coreloss_iGSEx;
                        
                        % Converter Side Winding Loss Calculation
                        Core.Ipp_Fs  = 2*max(Converter.Wav.D_iLpha);
                        [ Core ] = Wdg_Loss_Analyt( Core );
                        
                        %Temperature Calculation
                        Core.Total_Loss = Core.Pw + Core.Pc;
                        [ Core ] = Temperature_Calc( Core );
                        Converter.Result.Inductor.Temp = Core.Inductor.Temp;
%                         close all;
                        % Save Some Results
                        Result(k_core,k_stack).CoreType = Core.CoreType;
                        Result(k_core,k_stack).CorePart= Core.CorePart;
                        Result(k_core,k_stack).NumberfoStack = Core.NumberfoStack;
                        Result(k_core,k_stack).MaterialType = Core.MaterialType;
                        Result(k_core,k_stack).NumberofTurns = Core.N;
                        Result(k_core,k_stack).AirGap = Core.lg;
                        Result(k_core,k_stack).Wire_Diameter = Core.Wire.d_wire;
                        Result(k_core,k_stack).Wire_Sigma = Core.Wire.sigma;
                        Result(k_core,k_stack).Wire_d_strand = Core.Wire.d_strand;
                        Result(k_core,k_stack).Wire_d_ISO = Core.Wire.d_ISO;
                        Result(k_core,k_stack).Wire_Material= Core.CondMat;
                        Result(k_core,k_stack).Wire_AWGPart = Core.Wire.AWGPart;
                        Result(k_core,k_stack).Wire_n_strand = Core.Wire.n_strand;
                        if strcmp(Converter.Spec.topology,'INT 2CH 3L_NPC')
                            Result(k_core,k_stack).Core_Weight = 2*Core.Core_Weight;
                            Result(k_core,k_stack).Wire_Weight = 2*Core.Wire_Weight;
                            Result(k_core,k_stack).Total_Weight =  2*Core.Result.Total_Weight;
                            Result(k_core,k_stack).Core_Loss = 2*Core.Pc;
                            Result(k_core,k_stack).Wire_Pskin = 2*Core.Pskin;
                            Result(k_core,k_stack).Wire_Pprox= 2*Core.Pprox;
                            Result(k_core,k_stack).Wire_Loss = 2*Core.Pw;
                            Result(k_core,k_stack).Total_Loss = 2*Core.Pw+2*Core.Pc;
                        else
                            Result(k_core,k_stack).Total_Weight =  Core.Result.Total_Weight;
                            Result(k_core,k_stack).Core_Weight = Core.Core_Weight;
                            Result(k_core,k_stack).Wire_Weight = Core.Wire_Weight;
                            Result(k_core,k_stack).Core_Loss = Core.Pc;
                            Result(k_core,k_stack).Wire_Pskin = Core.Pskin;
                            Result(k_core,k_stack).Wire_Pprox= Core.Pprox;
                            Result(k_core,k_stack).Wire_Loss = Core.Pw;
                            Result(k_core,k_stack).Total_Loss = Core.Pw+Core.Pc;
                        end
                        Result(k_core,k_stack).L_0A = Core.L_0A;
                        Result(k_core,k_stack).L_IPeak = Core.L_peak;
                        Result(k_core,k_stack).L_IShort = Core.L_short;
                        Result(k_core,k_stack).Bamx = max(B_m);                        
                        Result(k_core,k_stack).Inductor_Temp = Core.Inductor.Temp;
                        Result(k_core,k_stack).BadResult= Core.BadResult;
                        % additional data for reconstructing
                        Result(k_core,k_stack).Core_Volume= Core.Core_Volume;
                        Result(k_core,k_stack).Wire_volume= Core.Wire.CondVolume;
                        Result(k_core,k_stack).Wire_le= Core.le;
                        Result(k_core,k_stack).Wire_Ae= Core.Ae;
                        Result(k_core,k_stack).Wire_Aw= Core.Aw;
                        Result(k_core,k_stack).Core_Nmax_p= Core.Nmax_p ;
                        % additional data for FEMM 
                        Result(k_core,k_stack).Core_mir_peak = Core.mir_peak;
                        Result(k_core,k_stack).Core_InitPerm = Core.InitPerm;
                        Result(k_core,k_stack).Core_OD = Core.OD;
                        Result(k_core,k_stack).Core_ID = Core.ID ;
                        Result(k_core,k_stack).Core_HT = Core.HT ;
                        Result(k_core,k_stack).Core_e = Core.e;
%                         Result(k_core,k_stack).Core_wg = Core.wg;
                        Result(k_core,k_stack).Core_N = Core.N;
                        Result(k_core,k_stack).Core_Wire_Turn_Length = Core.Wire.Turn_Length;
                        Result(k_core,k_stack).Core_RoundWire_Stranded = Core.Winding.RoundWire_Stranded ;
                        Result(k_core,k_stack).Core_RoundWire_Solid = Core.Winding.RoundWire_Solid ;
                        Result(k_core,k_stack).Core_CondMat = Core.CondMat ;


                        if strcmp(Core.CoreType,'Toroidal') == 1
                            Result(k_core,k_stack).CrossSect= Core.Ae;
                            Result(k_core,k_stack).ExtDiam= Core.OD;
                            Result(k_core,k_stack).CoreHeight= Core.HT;
                        end
                        
                        if (Core.BadResult==0)&&(TotalMass>Core.Result.Total_Weight)
                                TotalMass = Core.Result.Total_Weight;
                                k_core_Typ_B= k_core_Typ;
                                k_core_Mat_B=k_core_Mat;
                                k_core_B = k_core;
                                k_stack_B = k_stack;                            
                        end
                    end
                end
                % saving data
                datestr=date;
%                 SaveDir = './Core_Design/Inductor_results';
%                 SaveData = [SaveDir '/simNo',num2str(simfilecnt),'_', Core.CoreType, '_',Core.MaterialType,...
%                     '_',num2str(datestr),'.mat'];
%                 save(SaveData,'Result');
                % pareto data & The Best Core EVERR!!!!
                pareto(k_core_Typ,k_core_Mat).Result = Result;
                clear Result;
            end
        end
    end
    if Core.Opt.Core_auto == 1
        Core.k_core = k_core_B;
        Core.k_stack = k_stack_B;
        Core.CoreType = Converter.Spec.Inductor.Core.CoreType{k_core_Typ_B};
        Core.MaterialType = Converter.Spec.Inductor.Core.MaterialType{k_core_Mat_B};
    end
    [ Core ] = Powder_Core_design( Core );
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
    if strcmp(Converter.Spec.topology,'INT 2CH 3L_NPC')
        Converter.Result.Inductor.Core_Weight = 2*Core.Core_Weight;
        Converter.Result.Inductor.Wire_Weight = 2*Core.Wire_Weight;
        Converter.Result.Inductor.Total_Weight =  2*Core.Result.Total_Weight;
    else
        Converter.Result.Inductor.Core_Weight = Core.Core_Weight;
        Converter.Result.Inductor.Wire_Weight = Core.Wire_Weight;
        Converter.Result.Inductor.Total_Weight =  Core.Result.Total_Weight;
    end
    Converter.Result.Inductor.L_0A = Core.L_0A;
    Converter.Result.Inductor.L_IPeak = Core.L_peak;
    Converter.Result.Inductor.L_IShort = Core.L_short;
 
    % Consider Variation of Inductor Value
    Converter.Spec.L1_val = Core.Result.Wav.L_vec(1,1);
    Converter.Spec.L1_Vvar = Core.Result.Wav.L_vec/Converter.Spec.L1_val; %Variation of Lf as function of Current
    Converter.Spec.L1_Ivar = Core.Result.Wav.IL; %Variation of Lf as function of Current
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end