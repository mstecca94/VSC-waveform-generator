function [ Wave ] = current_processing ( Wave )

%%
Topology = Wave.Input.Topology ;
Add_LCL = Wave.Input.Add_LCL ;
Application = Wave.Input.Application ;
nps = Wave.Input.nps ;
switch Topology 
    case {'Two Level','Two Level - SiC'}
        switch Application
            case 'Grid Connected'
                Wave.SemiconductorLosses.I_T1_avg =  mean(abs(Wave.Current.i_T1))*2 ;
                Wave.SemiconductorLosses.I_D1_avg = mean(abs(Wave.Current.i_D1))*2 ;

                Wave.SemiconductorLosses.I_T1_rms = rms(Wave.Current.i_T1)*sqrt(2) ;
                Wave.SemiconductorLosses.I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2) ;
                if Add_LCL == 1
                    Wave.SemiconductorLosses.I_T1_wr_avg = mean(abs(Wave.CurrentWR.i_T1_wr))*2 ;
                    Wave.SemiconductorLosses.I_D1_wr_avg = mean(abs(Wave.CurrentWR.i_D1_wr))*2 ;

                    Wave.SemiconductorLosses.I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2) ;
                    Wave.SemiconductorLosses.I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2) ;
                end   
            case 'Motor Drive'
                if strcmp(Topology,'Two Level') == 1
                    Wave.SemiconductorLosses.I_T1_avg =  mean(abs(Wave.Current.i_T1/2))*2 ;
                    Wave.SemiconductorLosses.I_D1_avg = mean(abs(Wave.Current.i_D1))*2 ;

                    Wave.SemiconductorLosses.I_T1_rms = rms(Wave.Current.i_T1/2)*sqrt(2) ;
                    Wave.SemiconductorLosses.I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2) ;
                    if Add_LCL == 1
                        Wave.SemiconductorLosses.I_T1_wr_avg = mean(abs(Wave.CurrentWR.i_T1_wr/2))*2 ;
                        Wave.SemiconductorLosses.I_D1_wr_avg = mean(abs(Wave.CurrentWR.i_D1_wr))*2 ;

                        Wave.SemiconductorLosses.I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr/2)*sqrt(2) ;
                        Wave.SemiconductorLosses.I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2) ;
                    end 
                else % this is the sic mosfet
                    Wave.SemiconductorLosses.I_T1_avg =  mean(abs(Wave.Current.i_T1/nps)) ;
                    Wave.SemiconductorLosses.I_D1_avg = mean(abs(Wave.Current.i_D1/nps)) ;

                    Wave.SemiconductorLosses.I_T1_rms = rms(Wave.Current.i_T1/nps) ;
                    Wave.SemiconductorLosses.I_D1_rms = rms(Wave.Current.i_D1/nps) ;
                    if Add_LCL == 1
                        Wave.SemiconductorLosses.I_T1_wr_avg = mean(abs(Wave.CurrentWR.i_T1_wr/nps)) ;
                        Wave.SemiconductorLosses.I_D1_wr_avg = mean(abs(Wave.CurrentWR.i_D1_wr/nps)) ;

                        Wave.SemiconductorLosses.I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr/nps) ;
                        Wave.SemiconductorLosses.I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr/nps) ;
                    end 
                end
        end       
    case 'Three Level TTYPE'
        Wave.SemiconductorLosses.I_T1_avg = mean(abs(Wave.Current.i_T1))*2 ;
        Wave.SemiconductorLosses.I_T2_avg = mean(abs(Wave.Current.i_T2))*2 ;
        
        Wave.SemiconductorLosses.I_D1_avg = mean(Wave.Current.i_D1)*2  ;
        Wave.SemiconductorLosses.I_D2_avg = mean(Wave.Current.i_D2)*2 ;
        
        Wave.SemiconductorLosses.I_T1_rms = rms(abs(Wave.Current.i_T1))*sqrt(2) ;
        Wave.SemiconductorLosses.I_T2_rms = rms(abs(Wave.Current.i_T2))*sqrt(2) ;
        
        Wave.SemiconductorLosses.I_D1_rms = rms(abs(Wave.Current.i_D1))*sqrt(2) ;
        Wave.SemiconductorLosses.I_D2_rms = rms(abs(Wave.Current.i_D2))*sqrt(2) ;
        if Add_LCL == 1
            Wave.SemiconductorLosses.I_T1_wr_avg = mean(abs(Wave.CurrentWR.i_T1_wr))*2  ;
            Wave.SemiconductorLosses.I_T2_wr_avg = mean(abs(Wave.CurrentWR.i_T2_wr))*2 ;
            Wave.SemiconductorLosses.I_D1_wr_avg = mean(abs(Wave.CurrentWR.i_D1_wr))*2 ;
            Wave.SemiconductorLosses.I_D2_wr_avg = mean(abs(Wave.CurrentWR.i_D2_wr))*2 ;
            
            Wave.SemiconductorLosses.I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_T2_wr_rms = rms(Wave.CurrentWR.i_T2_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_D2_wr_rms = rms(Wave.CurrentWR.i_D2_wr)*sqrt(2) ;
        end 
    case 'Three Level NPC'                    
        Wave.SemiconductorLosses.I_T1_avg = mean(abs(Wave.Current.i_T1))*2 ;
        Wave.SemiconductorLosses.I_T2_avg = mean(abs(Wave.Current.i_T2))*2 ;
        
        Wave.SemiconductorLosses.I_D1_avg = mean(abs(Wave.Current.i_D1))*2  ;
        Wave.SemiconductorLosses.I_D2_avg = mean(abs(Wave.Current.i_D2))*2  ;
        
        Wave.SemiconductorLosses.I_D5_avg = mean(abs(Wave.Current.i_D5))*2 ;
        Wave.SemiconductorLosses.I_D6_avg = mean(abs(Wave.Current.i_D6))*2 ;
        
        Wave.SemiconductorLosses.I_T1_rms = rms(Wave.Current.i_T1)*sqrt(2)  ;
        Wave.SemiconductorLosses.I_T2_rms = rms(Wave.Current.i_T2)*sqrt(2)  ;
        
        Wave.SemiconductorLosses.I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2)  ;
        Wave.SemiconductorLosses.I_D2_rms = rms(Wave.Current.i_D2)*sqrt(2)  ;
        
        Wave.SemiconductorLosses.I_D5_rms = rms(Wave.Current.i_D5)*sqrt(2) ;
        Wave.SemiconductorLosses.I_D6_rms = rms(Wave.Current.i_D6)*sqrt(2) ;
        if Add_LCL == 1
            Wave.SemiconductorLosses.I_T1_wr_avg = mean(abs(Wave.CurrentWR.i_T1_wr))*2 ;
            Wave.SemiconductorLosses.I_T2_wr_avg = mean(abs(Wave.CurrentWR.i_T2_wr))*2 ; 
            
            Wave.SemiconductorLosses.I_D1_wr_avg = mean(abs(Wave.CurrentWR.i_D1_wr))*2 ;
            Wave.SemiconductorLosses.I_D2_wr_avg = mean(abs(Wave.CurrentWR.i_D2_wr))*2 ;
            
            Wave.SemiconductorLosses.I_D5_wr_avg = mean(abs(Wave.CurrentWR.i_D5_wr))*2 ;
            Wave.SemiconductorLosses.I_D6_wr_avg = mean(abs(Wave.CurrentWR.i_D6_wr))*2 ;
            
            Wave.SemiconductorLosses.I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_T2_wr_rms = rms(Wave.CurrentWR.i_T2_wr)*sqrt(2) ;
            
            Wave.SemiconductorLosses.I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_D2_wr_rms = rms(Wave.CurrentWR.i_D2_wr)*sqrt(2) ;
            
            Wave.SemiconductorLosses.I_D5_wr_rms = rms(Wave.CurrentWR.i_D5_wr)*sqrt(2) ;
            Wave.SemiconductorLosses.I_D6_wr_rms = rms(Wave.CurrentWR.i_D6_wr)*sqrt(2) ;
        end
end

% evaluate i on and off 
[ Wave ] = find_transitions ( Wave ) ;

end
