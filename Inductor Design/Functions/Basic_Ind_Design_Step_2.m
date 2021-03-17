function [ Core , Converter ] = Basic_Ind_Design_Step_2 ( Converter , Core )

% Converter Side Core Loss Calculation
    Core.BadResult=1; 
    B_m = Converter.Wav.B_fluxA(1,:)/Core.N/Core.Ae;
    time = Converter.Wav.Time(1,:);
    ko = Core.Steimtz.ko;
    alpha = Core.Steimtz.alpha;
    beta = Core.Steimtz.beta;
    [coreloss_iGSEx, num_minorloop] = coreloss_iGSE(B_m,time,ko,alpha,beta);
    Converter.Result.Inductor.Bmax = max(B_m);
    Core.Pc = 1e6*Core.Core_Volume*coreloss_iGSEx;
    Converter.Result.Inductor.Pcore = Core.Pc;
    
    % Converter Side Winding Loss Calculation
    Core.Ipp_Fs  = max(Converter.Wav.D_iLpha);
    [ Core ] = Wdg_Loss_Analyt( Core );
    
    % Partial Results
    if strcmp(Converter.Spec.topology,'INT 2CH 3L_NPC')
        Converter.Result.Inductor.Pw_skin = 2*Core.Pskin;
        Converter.Result.Inductor.Pw_prox = 2*Core.Pprox;
        Converter.Result.Inductor.Pwdg = 2*Core.Pw;
        Converter.Result.Inductor.Total_Loss = 2*Core.Pw+2*Core.Pc;
    else
        Converter.Result.Inductor.Pw_skin = Core.Pskin;
        Converter.Result.Inductor.Pw_prox = Core.Pprox;
        Converter.Result.Inductor.Pwdg = Core.Pw;
        Converter.Result.Inductor.Total_Loss = Core.Pw+Core.Pc;
    end
    
    %Temperature Calculation
    Core.Total_Loss = Core.Pw + Core.Pc;
    [ Core ] = Temperature_Calc( Core );
    Converter.Result.Inductor.Temp = Core.Inductor.Temp;
    
    if Converter.Result.Inductor.Temp > Core.Tmax
        fprintf('Inductor Temperature too high!\n')
        Core.BadResult=1; 
    end
    
end