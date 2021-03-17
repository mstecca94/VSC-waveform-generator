function [ Wave ] = current_processing ( Wave )

%%
Topology = Wave.Input.Topology ;
Add_LCL = Wave.Input.Add_LCL ;

switch Topology 
    case 'Two Level'
        I_T1_avg = mean(Wave.Current.i_T1)*2 ;
        I_T2_avg = mean(Wave.Current.i_T2)*2 ;
        I_D1_avg = mean(Wave.Current.i_D1)*2 ;
        I_D2_avg = mean(Wave.Current.i_D2)*2 ;

        I_T1_rms = rms(Wave.Current.i_T1)*sqrt(2)  ;
        I_T2_rms = rms(Wave.Current.i_T2)*sqrt(2)  ;
        I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2)  ;
        I_D2_rms = rms(Wave.Current.i_D2)*sqrt(2)  ;
                    
        Wave.SemiconductorLosses.I_T1_avg = I_T1_avg ;
        Wave.SemiconductorLosses.I_T2_avg = I_T2_avg ;
        Wave.SemiconductorLosses.I_D1_avg = I_D1_avg ;
        Wave.SemiconductorLosses.I_D2_avg = I_D2_avg ;
        
        Wave.SemiconductorLosses.I_T1_rms = I_T1_rms ;
        Wave.SemiconductorLosses.I_T2_rms = I_T2_rms ;
        Wave.SemiconductorLosses.I_D1_rms = I_D1_rms ;
        Wave.SemiconductorLosses.I_D2_rms = I_D2_rms ;
        if Add_LCL == 1
            I_T1_wr_avg = mean(Wave.CurrentWR.i_T1_wr)*2 ;
            I_T2_wr_avg = mean(Wave.CurrentWR.i_T2_wr)*2 ;
            I_D1_wr_avg = mean(Wave.CurrentWR.i_D1_wr)*2 ;
            I_D2_wr_avg = mean(Wave.CurrentWR.i_D2_wr)*2 ;

            I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2)  ;
            I_T2_wr_rms = rms(Wave.CurrentWR.i_T2_wr)*sqrt(2)  ;
            I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2)  ;
            I_D2_wr_rms = rms(Wave.CurrentWR.i_D2_wr)*sqrt(2)  ;
            
            Wave.SemiconductorLosses.I_T1_wr_avg = I_T1_wr_avg ;
            Wave.SemiconductorLosses.I_T2_wr_avg = I_T2_wr_avg ;
            Wave.SemiconductorLosses.I_D1_wr_avg = I_D1_wr_avg ;
            Wave.SemiconductorLosses.I_D2_wr_avg = I_D2_wr_avg ;
            
            Wave.SemiconductorLosses.I_T1_wr_rms = I_T1_wr_rms ;
            Wave.SemiconductorLosses.I_T2_wr_rms = I_T2_wr_rms ;
            Wave.SemiconductorLosses.I_D1_wr_rms = I_D1_wr_rms ;
            Wave.SemiconductorLosses.I_D2_wr_rms = I_D2_wr_rms ;
        end          
    case 'Three Level NPC'
        I_T1_avg = mean(Wave.Current.i_T1)*2 ;
        I_T2_avg = mean(Wave.Current.i_T2)*2 ;
        I_T3_avg = mean(Wave.Current.i_T3)*2 ;
        I_T4_avg = mean(Wave.Current.i_T4)*2 ;
        
        I_D1_avg = mean(Wave.Current.i_D1)*2 ;
        I_D2_avg = mean(Wave.Current.i_D2)*2 ;
        I_D3_avg = mean(Wave.Current.i_D3)*2 ;
        I_D4_avg = mean(Wave.Current.i_D4)*2 ;

        I_T1_rms = rms(Wave.Current.i_T1)*sqrt(2)  ;
        I_T2_rms = rms(Wave.Current.i_T2)*sqrt(2)  ;
        I_T3_rms = rms(Wave.Current.i_T3)*sqrt(2)  ;
        I_T4_rms = rms(Wave.Current.i_T4)*sqrt(2)  ;
        
        I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2)  ;
        I_D2_rms = rms(Wave.Current.i_D2)*sqrt(2)  ;
        I_D3_rms = rms(Wave.Current.i_D3)*sqrt(2)  ;
        I_D4_rms = rms(Wave.Current.i_D4)*sqrt(2)  ;
                    
        Wave.SemiconductorLosses.I_T1_avg = I_T1_avg ;
        Wave.SemiconductorLosses.I_T2_avg = I_T2_avg ;                    
        Wave.SemiconductorLosses.I_T3_avg = I_T3_avg ;
        Wave.SemiconductorLosses.I_T4_avg = I_T4_avg ;
        Wave.SemiconductorLosses.I_D1_avg = I_D1_avg ;
        Wave.SemiconductorLosses.I_D2_avg = I_D2_avg ;
        Wave.SemiconductorLosses.I_D3_avg = I_D3_avg ;
        Wave.SemiconductorLosses.I_D4_avg = I_D4_avg ;
        
        Wave.SemiconductorLosses.I_T1_rms = I_T1_rms ;
        Wave.SemiconductorLosses.I_T2_rms = I_T2_rms ;
        Wave.SemiconductorLosses.I_T3_rms = I_T3_rms ;
        Wave.SemiconductorLosses.I_T4_rms = I_T4_rms ;
        Wave.SemiconductorLosses.I_D1_rms = I_D1_rms ;
        Wave.SemiconductorLosses.I_D2_rms = I_D2_rms ;
        Wave.SemiconductorLosses.I_D3_rms = I_D3_rms ;
        Wave.SemiconductorLosses.I_D4_rms = I_D4_rms ;
        if Add_LCL == 1
            I_T1_wr_avg = mean(Wave.CurrentWR.i_T1_wr)*2 ;
            I_T2_wr_avg = mean(Wave.CurrentWR.i_T2_wr)*2 ;
            I_T3_wr_avg = mean(Wave.CurrentWR.i_T3_wr)*2 ;
            I_T4_wr_avg = mean(Wave.CurrentWR.i_T4_wr)*2 ;

            I_D1_wr_avg = mean(Wave.CurrentWR.i_D1_wr)*2 ;
            I_D2_wr_avg = mean(Wave.CurrentWR.i_D2_wr)*2 ;
            I_D3_wr_avg = mean(Wave.CurrentWR.i_D3_wr)*2 ;
            I_D4_wr_avg = mean(Wave.CurrentWR.i_D4_wr)*2 ;

            I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2)  ;
            I_T2_wr_rms = rms(Wave.CurrentWR.i_T2_wr)*sqrt(2)  ;
            I_T3_wr_rms = rms(Wave.CurrentWR.i_T3_wr)*sqrt(2)  ;
            I_T4_wr_rms = rms(Wave.CurrentWR.i_T4_wr)*sqrt(2)  ;
            
            I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2)  ;
            I_D2_wr_rms = rms(Wave.CurrentWR.i_D2_wr)*sqrt(2)  ;
            I_D3_wr_rms = rms(Wave.CurrentWR.i_D3_wr)*sqrt(2)  ;
            I_D4_wr_rms = rms(Wave.CurrentWR.i_D4_wr)*sqrt(2)  ;

            Wave.SemiconductorLosses.I_T1_wr_avg = I_T1_wr_avg ;
            Wave.SemiconductorLosses.I_T2_wr_avg = I_T2_wr_avg ;                    
            Wave.SemiconductorLosses.I_T3_wr_avg = I_T3_wr_avg ;
            Wave.SemiconductorLosses.I_T4_wr_avg = I_T4_wr_avg ;
            Wave.SemiconductorLosses.I_D1_wr_avg = I_D1_wr_avg ;
            Wave.SemiconductorLosses.I_D2_wr_avg = I_D2_wr_avg ;
            Wave.SemiconductorLosses.I_D3_wr_avg = I_D3_wr_avg ;
            Wave.SemiconductorLosses.I_D4_wr_avg = I_D4_wr_avg ;
            
            Wave.SemiconductorLosses.I_T1_wr_rms = I_T1_wr_rms ;
            Wave.SemiconductorLosses.I_T2_wr_rms = I_T2_wr_rms ;
            Wave.SemiconductorLosses.I_T3_wr_rms = I_T3_wr_rms ;
            Wave.SemiconductorLosses.I_T4_wr_rms = I_T4_wr_rms ;
            Wave.SemiconductorLosses.I_D1_wr_rms = I_D1_wr_rms ;
            Wave.SemiconductorLosses.I_D2_wr_rms = I_D2_wr_rms ;
            Wave.SemiconductorLosses.I_D3_wr_rms = I_D3_wr_rms ;
            Wave.SemiconductorLosses.I_D4_wr_rms = I_D4_wr_rms ;
        end 
    case 'Three Level TTYPE'
        I_T1_avg = mean(Wave.Current.i_T1)*2 ;
        I_T2_avg = mean(Wave.Current.i_T2)*2 ;
        I_T3_avg = mean(Wave.Current.i_T3)*2 ;
        I_T4_avg = mean(Wave.Current.i_T4)*2 ;
        
        I_D1_avg = mean(Wave.Current.i_D1)*2 ;
        I_D2_avg = mean(Wave.Current.i_D2)*2 ;
        I_D3_avg = mean(Wave.Current.i_D3)*2 ;
        I_D4_avg = mean(Wave.Current.i_D4)*2 ;
        I_D5_avg = mean(Wave.Current.i_D5)*2 ;
        I_D6_avg = mean(Wave.Current.i_D6)*2 ;

        I_T1_rms = rms(Wave.Current.i_T1)*sqrt(2)  ;
        I_T2_rms = rms(Wave.Current.i_T2)*sqrt(2)  ;
        I_T3_rms = rms(Wave.Current.i_T3)*sqrt(2)  ;
        I_T4_rms = rms(Wave.Current.i_T4)*sqrt(2)  ;
        
        I_D1_rms = rms(Wave.Current.i_D1)*sqrt(2)  ;
        I_D2_rms = rms(Wave.Current.i_D2)*sqrt(2)  ;
        I_D3_rms = rms(Wave.Current.i_D3)*sqrt(2)  ;
        I_D4_rms = rms(Wave.Current.i_D4)*sqrt(2)  ;
        I_D5_rms = rms(Wave.Current.i_D5)*sqrt(2)  ;
        I_D6_rms = rms(Wave.Current.i_D6)*sqrt(2)  ;
                    
        Wave.SemiconductorLosses.I_T1_avg = I_T1_avg ;
        Wave.SemiconductorLosses.I_T2_avg = I_T2_avg ;                    
        Wave.SemiconductorLosses.I_T3_avg = I_T3_avg ;
        Wave.SemiconductorLosses.I_T4_avg = I_T4_avg ;
        Wave.SemiconductorLosses.I_D1_avg = I_D1_avg ;
        Wave.SemiconductorLosses.I_D2_avg = I_D2_avg ;
        Wave.SemiconductorLosses.I_D3_avg = I_D3_avg ;
        Wave.SemiconductorLosses.I_D4_avg = I_D4_avg ;
        Wave.SemiconductorLosses.I_D5_avg = I_D5_avg ;
        Wave.SemiconductorLosses.I_D6_avg = I_D6_avg ;
        
        Wave.SemiconductorLosses.I_T1_rms = I_T1_rms ;
        Wave.SemiconductorLosses.I_T2_rms = I_T2_rms ;
        Wave.SemiconductorLosses.I_T3_rms = I_T3_rms ;
        Wave.SemiconductorLosses.I_T4_rms = I_T4_rms ;
        Wave.SemiconductorLosses.I_D1_rms = I_D1_rms ;
        Wave.SemiconductorLosses.I_D2_rms = I_D2_rms ;
        Wave.SemiconductorLosses.I_D3_rms = I_D3_rms ;
        Wave.SemiconductorLosses.I_D4_rms = I_D4_rms ;
        Wave.SemiconductorLosses.I_D5_rms = I_D5_rms ;
        Wave.SemiconductorLosses.I_D6_rms = I_D6_rms ;
        if Add_LCL == 1
            I_T1_wr_avg = mean(Wave.CurrentWR.i_T1_wr)*2 ;
            I_T2_wr_avg = mean(Wave.CurrentWR.i_T2_wr)*2 ;
            I_T3_wr_avg = mean(Wave.CurrentWR.i_T3_wr)*2 ;
            I_T4_wr_avg = mean(Wave.CurrentWR.i_T4_wr)*2 ;

            I_D1_wr_avg = mean(Wave.CurrentWR.i_D1_wr)*2 ;
            I_D2_wr_avg = mean(Wave.CurrentWR.i_D2_wr)*2 ;
            I_D3_wr_avg = mean(Wave.CurrentWR.i_D3_wr)*2 ;
            I_D4_wr_avg = mean(Wave.CurrentWR.i_D4_wr)*2 ;
            I_D5_wr_avg = mean(Wave.CurrentWR.i_D5_wr)*2 ;
            I_D6_wr_avg = mean(Wave.CurrentWR.i_D6_wr)*2 ;

            I_T1_wr_rms = rms(Wave.CurrentWR.i_T1_wr)*sqrt(2)  ;
            I_T2_wr_rms = rms(Wave.CurrentWR.i_T2_wr)*sqrt(2)  ;
            I_T3_wr_rms = rms(Wave.CurrentWR.i_T3_wr)*sqrt(2)  ;
            I_T4_wr_rms = rms(Wave.CurrentWR.i_T4_wr)*sqrt(2)  ;
            I_D1_wr_rms = rms(Wave.CurrentWR.i_D1_wr)*sqrt(2)  ;
            I_D2_wr_rms = rms(Wave.CurrentWR.i_D2_wr)*sqrt(2)  ;
            I_D3_wr_rms = rms(Wave.CurrentWR.i_D3_wr)*sqrt(2)  ;
            I_D4_wr_rms = rms(Wave.CurrentWR.i_D4_wr)*sqrt(2)  ;
            I_D5_wr_rms = rms(Wave.CurrentWR.i_D5_wr)*sqrt(2)  ;
            I_D6_wr_rms = rms(Wave.CurrentWR.i_D6_wr)*sqrt(2)  ;

            Wave.SemiconductorLosses.I_T1_wr_avg = I_T1_wr_avg ;
            Wave.SemiconductorLosses.I_T2_wr_avg = I_T2_wr_avg ;                    
            Wave.SemiconductorLosses.I_T3_wr_avg = I_T3_wr_avg ;
            Wave.SemiconductorLosses.I_T4_wr_avg = I_T4_wr_avg ;
            Wave.SemiconductorLosses.I_D1_wr_avg = I_D1_wr_avg ;
            Wave.SemiconductorLosses.I_D2_wr_avg = I_D2_wr_avg ;
            Wave.SemiconductorLosses.I_D3_wr_avg = I_D3_wr_avg ;
            Wave.SemiconductorLosses.I_D4_wr_avg = I_D4_wr_avg ;
            Wave.SemiconductorLosses.I_D5_wr_avg = I_D5_wr_avg ;
            Wave.SemiconductorLosses.I_D6_wr_avg = I_D6_wr_avg ;
            
            Wave.SemiconductorLosses.I_T1_wr_rms = I_T1_wr_rms ;
            Wave.SemiconductorLosses.I_T2_wr_rms = I_T2_wr_rms ;
            Wave.SemiconductorLosses.I_T3_wr_rms = I_T3_wr_rms ;
            Wave.SemiconductorLosses.I_T4_wr_rms = I_T4_wr_rms ;
            Wave.SemiconductorLosses.I_D1_wr_rms = I_D1_wr_rms ;
            Wave.SemiconductorLosses.I_D2_wr_rms = I_D2_wr_rms ;
            Wave.SemiconductorLosses.I_D3_wr_rms = I_D3_wr_rms ;
            Wave.SemiconductorLosses.I_D4_wr_rms = I_D4_wr_rms ;
            Wave.SemiconductorLosses.I_D5_wr_rms = I_D5_wr_rms ;
            Wave.SemiconductorLosses.I_D6_wr_rms = I_D6_wr_rms ;
        end
end

