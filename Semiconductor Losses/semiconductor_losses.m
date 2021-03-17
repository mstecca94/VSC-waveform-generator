function [ Wave ] = semiconductor_losses ( Wave ) 
%%
fg = Wave.Input.fg ;         %[Hz] : Grid Frequency
vdc = Wave.Input.vdc;            %[V]  : DC link Voltage
topology = Wave.Input.Topology ; 
Application = Wave.Input.Application ;
nps = Wave.Input.nps ;

if strcmp(topology,'Three Level NPC') || strcmp(topology,'Three Level TTYPE')
    vdc = vdc/2;
end

%%
switch topology
    case {'Two Level','Two Level - SiC'}
            
        i_t12_avg = Wave.SemiconductorLosses.I_T1_wr_avg ;
        i_d12_avg = Wave.SemiconductorLosses.I_D1_wr_avg ;

        i_t12_rms = Wave.SemiconductorLosses.I_T1_wr_avg  ;
        i_d12_rms = Wave.SemiconductorLosses.I_D1_wr_avg ;
        switch Application
            case 'Grid Connected'
                i_eon = abs(Wave.Current.TurnONCurrent)  ;
                i_err = i_eon ;
                i_eoff = abs(Wave.Current.TurnOFFCurrent)  ;
            case 'Motor Drive'
                if strcmp(topology,'Two Level') == 1
                    i_eon = abs(Wave.Current.TurnONCurrent/2)  ;
                    i_err = i_eon*2 ;
                    i_eoff = abs(Wave.Current.TurnOFFCurrent/2)  ;
                else
                    i_eon = abs(Wave.Current.TurnONCurrent/nps)  ;
                    i_err = i_eon ;
                    i_eoff = abs(Wave.Current.TurnOFFCurrent/nps)  ;
                end
        end
        U__Bt = Wave.SemiconductorParameters.U__Bt ;
        U__Bd = Wave.SemiconductorParameters.U__Bd ; 

        rt = Wave.SemiconductorParameters.rt ;
        Vt = Wave.SemiconductorParameters.Vt ;

        rd = Wave.SemiconductorParameters.rd ;
        Vd = Wave.SemiconductorParameters.Vd ;

        eon = Wave.SemiconductorParameters.eonx ;
        eoff = Wave.SemiconductorParameters.eoffx ;
        err = Wave.SemiconductorParameters.errx ;
        
        % find point e losses
        if size(i_eon,1)>0
            for x = 1:size(i_eon,1)
                [~,b]=min(abs(eon(1,:)-i_eon(x,2)));
                [~,b1]=min(abs(err(1,:)-i_err(x,2)));
                eon_T1(x,1) = eon(2,b);
                err_D1(x,1) = err(2,b1);
            end  
        else
            i_eon = 0 ;
            eon_T1 = 0 ;
            err_D1 = 0 ;
        end
        for x = 1:size(i_eoff,1)
            [~,b]=min(abs(eoff(1,:)-i_eoff(x,2)));
            eoff_T1(x,1) = eoff(2,b);
        end

        P_eon_t12=sum(eon_T1)*vdc/U__Bt*fg ;
        P_eoff_t12=sum(eoff_T1)*vdc/U__Bd*fg ;
        P_err_d12=sum(err_D1)*vdc/U__Bt*fg ;

        Ps_t12 = P_eon_t12 + P_eoff_t12 ;
        Ps_d12 = P_err_d12 ;
        switch Application
            case 'Grid Connected'
                Ps_comp=[Ps_t12 Ps_d12 Ps_t12 Ps_d12];
            case 'Motor Drive'
                if strcmp(topology,'Two Level') == 1
                    Ps_comp=[Ps_t12*2 Ps_d12 Ps_t12*2 Ps_d12];
                else
                    Ps_comp=[Ps_t12 Ps_d12 Ps_t12 Ps_d12]*nps;
                end
        end
        Ps_tot=sum(Ps_comp);
        %% Cond Losses
        Pc_t1=i_t12_rms.^2*rt+i_t12_avg*Vt;
        Pc_t2=Pc_t1;
        Pc_d1=i_d12_rms.^2*rd+i_d12_avg*Vd;
        Pc_d2=Pc_d1;
        switch Application
            case 'Grid Connected'
                Pc_comp=[Pc_t1 Pc_d1 Pc_t2 Pc_d2];
            case 'Motor Drive'
                if strcmp(topology,'Two Level') == 1
                    Pc_comp=[Pc_t1*2 Pc_d1 Pc_t2*2 Pc_d2];
                else
                    Pc_comp=[Pc_t1 Pc_d1 Pc_t2 Pc_d2]*nps;
                end
        end        
        Pc_tot=sum(Pc_comp);
        %% total losses per component
        Pt1=Pc_t1+Ps_t12;
        Pt2=Pc_t2+Ps_t12;
        Pd1=Pc_d1+Ps_d12;
        Pd2=Pc_d2+Ps_d12;
        Ptot_comp= Pc_comp + Ps_comp ;
        Ptot=(Pc_tot+Ps_tot)*3; % 3 for the 3 phases
        %% Save data
        Wave.Losses.Cond_T1 = Pc_t1 ;
        Wave.Losses.Cond_T2 = Pc_t2 ;
        Wave.Losses.Cond_D1 = Pc_d1 ;
        Wave.Losses.Cond_D2 = Pc_d2 ;
        Wave.Losses.Sw_T1 = Ps_t12 ;
        Wave.Losses.Sw_T2 = Ps_t12 ;
        Wave.Losses.Sw_D1 = Ps_d12 ;
        Wave.Losses.Sw_D2 = Ps_d12 ;
        Wave.Losses.Total_T1 = Pt1 ;
        Wave.Losses.Total_T2 = Pt2 ;
        Wave.Losses.Total_D1 = Pd1 ;
        Wave.Losses.Total_D2 = Pd2 ;

    case 'Three Level NPC'
                
        i_t14_avg = Wave.SemiconductorLosses.I_T1_wr_avg  ;
        i_t23_avg = Wave.SemiconductorLosses.I_T2_wr_avg ;
        i_d1234_avg = Wave.SemiconductorLosses.I_D1_wr_avg ;
        i_d56_avg = Wave.SemiconductorLosses.I_D5_wr_avg  ;
        
        i_t14_rms = Wave.SemiconductorLosses.I_T1_wr_rms  ;
        i_t23_rms = Wave.SemiconductorLosses.I_T2_wr_rms  ;
        i_d1234_rms = Wave.SemiconductorLosses.I_D1_wr_rms ;
        i_d56_rms = Wave.SemiconductorLosses.I_D5_wr_rms  ;
   
        rt1 = Wave.SemiconductorParameters.rt1 ;
        Vt1 = Wave.SemiconductorParameters.Vt1 ;
        
        rt2 = Wave.SemiconductorParameters.rt2 ;
        Vt2 = Wave.SemiconductorParameters.Vt2 ;
        
        rd5 = Wave.SemiconductorParameters.rd5 ;
        Vd5 = Wave.SemiconductorParameters.Vd5 ;
        
        rd1 = Wave.SemiconductorParameters.rd1 ;
        Vd1 = Wave.SemiconductorParameters.Vd1 ;
        
        % Conduction losses

        Pc_t1=i_t14_rms.^2*rt1+i_t14_avg*Vt1;
        Pc_t2=i_t23_rms.^2*rt2+i_t23_avg*Vt2;
        Pc_t3=Pc_t2;
        Pc_t4=Pc_t1;
        Pc_d1=i_d1234_rms.^2*rd1+i_d1234_avg*Vd1;
        Pc_d2=Pc_d1;
        Pc_d3=Pc_d2;
        Pc_d4=Pc_d1;
        Pc_d5=i_d56_rms.^2*rd5+i_d56_avg*Vd5;
        Pc_d6=Pc_d5;
        Pc_comp=[Pc_t1 Pc_d1 Pc_t2 Pc_d2 Pc_t3 Pc_d3  Pc_t4 Pc_d4 Pc_d5  Pc_d6];
        Pc_tot=sum(Pc_comp);
        
        % Switching losses

        i_eon_t1 = abs(Wave.Current.TurnONCurrent_T1)  ;
        i_eoff_t1 = abs(Wave.Current.TurnOFFCurrent_T1)  ; 
        i_err_d5 = abs(Wave.Current.TurnONCurrent_T1)  ;
        
        i_eon_t3 = abs(Wave.Current.TurnONCurrent_T3)  ;        
        i_eoff_t3 = abs(Wave.Current.TurnOFFCurrent_T3)  ;
        i_err_d1 = abs(Wave.Current.TurnONCurrent_T3)  ;

        U__Bt1 = Wave.SemiconductorParameters.U__Bt1 ;
        U__Bd5 = Wave.SemiconductorParameters.U__Bd5 ; 
                
        U__Bt2 = Wave.SemiconductorParameters.U__Bt2 ;
        U__Bd1 = Wave.SemiconductorParameters.U__Bd1 ; 
        
        eon_t1 = Wave.SemiconductorParameters.eon_t1x ;
        eon_t3 = Wave.SemiconductorParameters.eon_t2x ;
        eoff_t1 = Wave.SemiconductorParameters.eoff_t1x ;
        eoff_t3 = Wave.SemiconductorParameters.eoff_t2x ;
        err_d5 = Wave.SemiconductorParameters.err_d5x ;
        err_d1 = Wave.SemiconductorParameters.err_d1x ;
        
        % find point e losses
        if size(i_eon_t1,1)>0        
            for x = 1:size(i_eon_t1,1)
                [~,b]=min(abs(eon_t1(1,:)-i_eon_t1(x,2)));
                [~,b1]=min(abs(err_d5(1,:)-i_err_d5(x,2)));
                eon_T1(x,1) = eon_t1(2,b);
                err_D5(x,1) = err_d5(2,b1);
            end
        else
            eon_T1 = 0 ;
            err_D5 = 0 ;
        end
        if size(i_eoff_t1,1)>0
            for x = 1:size(i_eoff_t1,1)
                [~,b]=min(abs(eoff_t1(1,:)-i_eoff_t1(x,2)));
                eoff_T1(x,1) = eoff_t1(2,b);
            end
        else
            eoff_T1 = 0 ;
        end        
        if size(i_eon_t3,1)>0        
            for x = 1:size(i_eon_t3,1)
                [~,b]=min(abs(eon_t3(1,:)-i_eon_t3(x,2)));
                [~,b1]=min(abs(err_d1(1,:)-i_err_d1(x,2)));
                eon_T3(x,1) = eon_t3(2,b);
                err_D1(x,1) = err_d1(2,b1);
            end
        else
            eon_T3 = 0 ;
            err_D1 = 0 ;
        end
        if size(i_eoff_t3,1)>0
            for x = 1:size(i_eoff_t3,1)
                [~,b]=min(abs(eoff_t3(1,:)-i_eoff_t3(x,2)));
                eoff_T3(x,1) = eoff_t3(2,b);
            end
        else
            eoff_T3 = 0 ;
        end
        
        P_eon_t14=sum(eon_T1)*fg*vdc/U__Bt1 ;
        P_eoff_t14=sum(eoff_T1)*fg*vdc/U__Bt1 ;
        P_err_d56=sum(err_D5)*fg*vdc/U__Bd5 ;

        P_eon_t23=sum(eon_T3)*fg*vdc/U__Bt2 ;
        P_eoff_t23=sum(eoff_T3)*fg*vdc/U__Bt2 ;
        P_err_d14=sum(err_D1)*fg*vdc/U__Bd1 ;
        
        Ps_t14 = P_eon_t14 + P_eoff_t14 ;
        Ps_d56 = P_err_d56 ;

        Ps_t23 = P_eon_t23 + P_eoff_t23 ;
        Ps_d14 = P_err_d14 ;
        
        Ps_comp=[Ps_t14 Ps_t23 Ps_t23 Ps_t14 Ps_d14 0 0 Ps_d14 Ps_d56 Ps_d56];
        
        Ps_tot=sum(Ps_comp);
        
        Ptot_comp=Pc_comp + Ps_comp;

        Ptot=(Pc_tot+Ps_tot)*3;    
        % save data
        Wave.Losses.Cond_T1 = Pc_t1 ;
        Wave.Losses.Cond_T2 = Pc_t2 ;
        Wave.Losses.Cond_D1 = Pc_d1 ;
        Wave.Losses.Cond_D5 = Pc_d5 ;
        Wave.Losses.Sw_T1 = Ps_t14 ;
        Wave.Losses.Sw_T2 = Ps_t23 ;
        Wave.Losses.Sw_D1 = Ps_d14 ;
        Wave.Losses.Sw_D5 = Ps_d56 ;
        Wave.Losses.Total_T1 = Pc_t1 + Ps_t14 ;
        Wave.Losses.Total_T2 = Pc_t2 + Ps_t23 ;
        Wave.Losses.Total_D1 = Pc_d1 + Ps_d14 ;
        Wave.Losses.Total_D5 = Pc_d5 + Ps_d56 ;
        
    case 'Three Level TTYPE'
        i_t14_avg = Wave.SemiconductorLosses.I_T1_wr_avg  ;
        i_t23_avg = Wave.SemiconductorLosses.I_T2_wr_avg ;
        i_d14_avg = Wave.SemiconductorLosses.I_D1_wr_avg ;
        i_d23_avg = Wave.SemiconductorLosses.I_D2_wr_avg ;
        
        i_t14_rms = Wave.SemiconductorLosses.I_T1_wr_rms  ;
        i_t23_rms = Wave.SemiconductorLosses.I_T2_wr_rms  ;
        i_d14_rms = Wave.SemiconductorLosses.I_D1_wr_rms ;
        i_d23_rms = Wave.SemiconductorLosses.I_D2_wr_rms ;
   
        rt1 = Wave.SemiconductorParameters.rt1 ;
        Vt1 = Wave.SemiconductorParameters.Vt1 ;
        
        rt2 = Wave.SemiconductorParameters.rt2 ;
        Vt2 = Wave.SemiconductorParameters.Vt2 ;
        
        rd2 = Wave.SemiconductorParameters.rd2 ;
        Vd2 = Wave.SemiconductorParameters.Vd2 ;
        
        rd1 = Wave.SemiconductorParameters.rd1 ;
        Vd1 = Wave.SemiconductorParameters.Vd1 ;
        
        % Conduction losses

        Pc_t1=i_t14_rms.^2*rt1+i_t14_avg*Vt1;

        Pc_t2=i_t23_rms.^2*rt2+i_t23_avg*Vt2;

        Pc_t3=Pc_t2;

        Pc_t4=Pc_t1;

        Pc_d1=i_d14_rms.^2*rd1+i_d14_avg*Vd1;

        Pc_d2=i_d23_rms.^2*rd2+i_d23_avg*Vd2;

        Pc_d3=Pc_d2;

        Pc_d4=Pc_d1;

        Pc_comp=[Pc_t1 Pc_d1 Pc_t2 Pc_d2 Pc_t3 Pc_d3  Pc_t4 Pc_d4];

        Pc_tot=sum(Pc_comp);
        
        % Switching losses

        i_eon_t1 = abs(Wave.Current.TurnONCurrent_T1)  ;
        i_eoff_t1 = abs(Wave.Current.TurnOFFCurrent_T1)  ; 
        i_err_d3 = abs(Wave.Current.TurnONCurrent_T1)  ;
        
        i_eon_t3 = abs(Wave.Current.TurnONCurrent_T3)  ;        
        i_eoff_t3 = abs(Wave.Current.TurnOFFCurrent_T3)  ;
        i_err_d1 = abs(Wave.Current.TurnONCurrent_T3)  ;

        U__Bt1 = Wave.SemiconductorParameters.U__Bt1 ;
        U__Bd2 = Wave.SemiconductorParameters.U__Bd2 ; 
                
        U__Bt2 = Wave.SemiconductorParameters.U__Bt2 ;
        U__Bd1 = Wave.SemiconductorParameters.U__Bd1 ; 
        
        eon_t1 = Wave.SemiconductorParameters.eon_t1x ;
        eon_t3 = Wave.SemiconductorParameters.eon_t2x ;
        eoff_t1 = Wave.SemiconductorParameters.eoff_t1x ;
        eoff_t3 = Wave.SemiconductorParameters.eoff_t2x ;
        err_d3 = Wave.SemiconductorParameters.err_d2x ;
        err_d1 = Wave.SemiconductorParameters.err_d1x ;
        

        % find point e losses
        if size(i_eon_t1,1)>0        
            for x = 1:size(i_eon_t1,1)
                [~,b]=min(abs(eon_t1(1,:)-i_eon_t1(x,2)));
                [~,b1]=min(abs(err_d3(1,:)-i_err_d3(x,2)));
                eon_T1(x,1) = eon_t1(2,b);
                err_D3(x,1) = err_d3(2,b1);
            end
        else
            eon_T1 = 0 ;
            err_D3 = 0 ;
        end      
        if size(i_eoff_t1,1)>0               
            for x = 1:size(i_eoff_t1,1)
                [~,b]=min(abs(eoff_t1(1,:)-i_eoff_t1(x,2)));
                eoff_T1(x,1) = eoff_t1(2,b);
            end  
        else
            eoff_T1 = 0 ;
        end
        if size(i_eon_t3,1)>0        
            for x = 1:size(i_eon_t3,1)
                [~,b]=min(abs(eon_t3(1,:)-i_eon_t3(x,2)));
                [~,b1]=min(abs(err_d1(1,:)-i_err_d1(x,2)));
                eon_T3(x,1) = eon_t3(2,b);
                err_D1(x,1) = err_d1(2,b1);
            end
        else
            eon_T3 = 0 ;
            err_D1 = 0 ;
        end
        if size(i_eoff_t3,1)>0        
            for x = 1:size(i_eoff_t3,1)
                [~,b]=min(abs(eoff_t3(1,:)-i_eoff_t3(x,2)));
                eoff_T3(x,1) = eoff_t3(2,b);
            end
        else
            eoff_T3 = 0 ;
        end

        P_eon_t14=sum(eon_T1)*fg*vdc/U__Bt1 ;
        P_eoff_t14=sum(eoff_T1)*fg*vdc/U__Bt1 ;
        P_err_d23=sum(err_D3)*fg*vdc/U__Bd2 ;

        P_eon_t23=sum(eon_T3)*fg*vdc/U__Bt2 ;
        P_eoff_t23=sum(eoff_T3)*fg*vdc/U__Bt2 ;
        P_err_d14=sum(err_D1)*fg*vdc/U__Bd1 ;
        
        Ps_t14 = P_eon_t14 + P_eoff_t14 ;
        Ps_d23 = P_err_d23 ;

        Ps_t23 = P_eon_t23 + P_eoff_t23 ;
        Ps_d14 = P_err_d14 ;
        
        Ps_comp=[Ps_t14 Ps_t23 Ps_t23 Ps_t14 Ps_d14 Ps_d23 Ps_d23 Ps_d14];
        
        Ps_tot=sum(Ps_comp);
        
        Ptot_comp=Pc_comp + Ps_comp;

        Ptot=(Pc_tot+Ps_tot)*3;    
       
        % save data
        Wave.Losses.Cond_T1 = Pc_t1 ;
        Wave.Losses.Cond_T2 = Pc_t2 ;
        Wave.Losses.Cond_D1 = Pc_d1 ;
        Wave.Losses.Cond_D3 = Pc_d3 ;
        Wave.Losses.Sw_T1 = Ps_t14 ;
        Wave.Losses.Sw_T2 = Ps_t23 ;
        Wave.Losses.Sw_D1 = Ps_d14 ;
        Wave.Losses.Sw_D3 = Ps_d23 ;
        Wave.Losses.Total_T1 = Pc_t1 + Ps_t14 ;
        Wave.Losses.Total_T2 = Pc_t2 + Ps_t23 ;
        Wave.Losses.Total_D1 = Pc_d1 + Ps_d14 ;
        Wave.Losses.Total_D3 = Pc_d3 + Ps_d23 ;
end

%% Save Loss data

Wave.Losses.Pc_comp = Pc_comp ;
Wave.Losses.Ps_comp = Ps_comp ;
Wave.Losses.Ptot_comp = Ptot_comp ;

Wave.Losses.Ptot = Ptot ;
Wave.Losses.Ps_tot = Ps_tot ;
Wave.Losses.Pc_tot = Pc_tot ;
Wave.Losses.Efficiency = (Wave.Input.P - Ptot)/Wave.Input.P*100 ;
