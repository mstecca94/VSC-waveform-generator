function [ Wave , DC_Design ] = current_post_LCL_DC ( Wave , DC_Design )

t = Wave.Input.t ;
fs = Wave.Input.fs ;
Topology = Wave.Input.Topology ;
carrier_a = DC_Design.carrier_a ;
i_a_wr = DC_Design.i_converter_side ;

%%
switch Topology
    case {'Two Level','Two Level - SiC'}
        pwm = 0.5*sawtooth(2*pi*fs*t+pi/2,1/2) ;
        i_T1_wr = 0*t ;
        i_D1_wr = 0*t ;
        i_T2_wr = 0*t ;
        i_D2_wr = 0*t ;
        for x=1:size(t,2)
            if carrier_a(x)>=pwm(x)
                if i_a_wr(x)>=0
                    i_T1_wr(x) = i_a_wr(x) ;
                else
                    i_D1_wr(x) = i_a_wr(x) ;
                end
            else
                if i_a_wr(x)>=0
                    i_D2_wr(x) = i_a_wr(x) ;
                else
                    i_T2_wr(x) = i_a_wr(x) ;
                end
            end
        end
    case 'Three Level NPC'
        i_T1_wr = 0*t ;
        i_D1_wr = 0*t ;
        i_T2_wr = 0*t ;
        i_D2_wr = 0*t ;
        i_T3_wr = 0*t ;
        i_D3_wr = 0*t ;
        i_T4_wr = 0*t ;
        i_D4_wr = 0*t ;
        i_D5_wr = 0*t ;
        i_D6_wr = 0*t ;
        pwm_up = 0.25 + 0.25*sawtooth(2*pi*fs*t + pi/2,1/2) ;       
        pwm_down = - 0.25+ 0.25*sawtooth(2*pi*fs*t + pi/2,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T2 on 
                if i_a_wr(x)>=0
                    i_T1_wr(x) = i_a_wr(x) ;
                    i_T2_wr(x) = i_a_wr(x) ;
                else
                    i_D1_wr(x) = i_a_wr(x) ;
                    i_D2_wr(x) = i_a_wr(x) ;
                end
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x) % T2 T3 on and T1 off
                if i_a_wr(x)>=0
                    i_D5_wr(x) = i_a_wr(x) ;
                    i_T2_wr(x) = i_a_wr(x) ;
                else
                    i_T3_wr(x) = i_a_wr(x) ;
                    i_D6_wr(x) = i_a_wr(x) ;
                end
            end
            if carrier_a(x)<=pwm_down(x) % T3 T4 on
                if i_a_wr(x)>=0
                    i_D3_wr(x) = i_a_wr(x) ;
                    i_D4_wr(x) = i_a_wr(x) ;
                else
                    i_T3_wr(x) = i_a_wr(x) ;
                    i_T4_wr(x) = i_a_wr(x) ;
                end
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x) % T4 T1 off T2 T3 on
                if i_a_wr(x)>=0
                    i_D5_wr(x) = i_a_wr(x) ;
                    i_T2_wr(x) = i_a_wr(x) ;
                else
                    i_T3_wr(x) = i_a_wr(x) ;
                    i_D6_wr(x) = i_a_wr(x) ;
                end
            end
        end
        
    case 'Three Level TTYPE'
        i_T1_wr = 0*t ;
        i_D1_wr = 0*t ;
        i_T2_wr = 0*t ;
        i_D2_wr = 0*t ;
        i_T3_wr = 0*t ;
        i_D3_wr = 0*t ;
        i_T4_wr = 0*t ;
        i_D4_wr = 0*t ;
        pwm_up = 0.25 + 0.25*sawtooth(2*pi*fs*t + pi/2,1/2) ;       
        pwm_down = - 0.25+ 0.25*sawtooth(2*pi*fs*t + pi/2,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T3 on
                if i_a_wr(x)>=0
                    i_T1_wr(x) = i_a_wr(x) ;
                else
                    i_D1_wr(x) = i_a_wr(x) ;
                end
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x)% T1 off T2 T3 on
                if i_a_wr(x)>=0
                    i_D2_wr(x) = i_a_wr(x) ;
                    i_T3_wr(x) = i_a_wr(x) ;
                else
                    i_T2_wr(x) = i_a_wr(x) ;
                    i_D3_wr(x) = i_a_wr(x) ;
                end
            end
            if carrier_a(x)<=pwm_down(x) % T4 on
                if i_a_wr(x)>=0
                    i_D4_wr(x) = i_a_wr(x) ;
                else
                    i_T4_wr(x) = i_a_wr(x) ;
                end
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x)
                if i_a_wr(x)>=0
                    i_D2_wr(x) = i_a_wr(x) ;
                    i_T3_wr(x) = i_a_wr(x) ;
                else
                    i_T2_wr(x) = i_a_wr(x) ;
                    i_D3_wr(x) = i_a_wr(x) ;
                end
            end
        end
end

%% Save data

switch Topology
    case {'Two Level','Two Level - SiC'}
        DC_Design.i_T1_wr = i_T1_wr ;
        DC_Design.i_T2_wr = i_T2_wr ;
        DC_Design.i_D1_wr = i_D1_wr ;
        DC_Design.i_D2_wr = i_D2_wr ;
    case 'Three Level NPC'
        DC_Design.i_T1_wr = i_T1_wr ;
        DC_Design.i_T2_wr = i_T2_wr ;
        DC_Design.i_D1_wr = i_D1_wr ;
        DC_Design.i_D2_wr = i_D2_wr ;
        DC_Design.i_T3_wr = i_T3_wr ;
        DC_Design.i_T4_wr = i_T4_wr ;
        DC_Design.i_D3_wr = i_D3_wr ;
        DC_Design.i_D4_wr = i_D4_wr ;
        DC_Design.i_D5_wr = i_D5_wr ;
        DC_Design.i_D6_wr = i_D6_wr ;
    case 'Three Level TTYPE'
        DC_Design.i_T1_wr = i_T1_wr ;
        DC_Design.i_T2_wr = i_T2_wr ;      
        DC_Design.i_D1_wr = i_D1_wr ;
        DC_Design.i_D2_wr = i_D2_wr ;
        DC_Design.i_T3_wr = i_T3_wr ;
        DC_Design.i_T4_wr = i_T4_wr ;
        DC_Design.i_D3_wr = i_D3_wr ;
        DC_Design.i_D4_wr = i_D4_wr ;
end

end