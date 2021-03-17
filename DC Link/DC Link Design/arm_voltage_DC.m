function [ Wave , DC_Design ] = arm_voltage_DC ( Wave , DC_Design )

t = Wave.Input.t ;
vdc = DC_Design.vdc ;
fs = Wave.Input.fs ;
Topology = Wave.Input.Topology ;

[ DC_Design ] = carrier_generation_DC ( Wave , DC_Design ) ;

carrier_a = DC_Design.carrier_a ;
carrier_b = DC_Design.carrier_b ;
carrier_c = DC_Design.carrier_c ;

%%
switch Topology
    case {'Two Level','Two Level - SiC'}
        pwm = sawtooth(2*pi*fs*t + pi/2,1/2) ;
        for x=1:size(t,2)
            if carrier_a(x)>=pwm(x)
                v_a(x) = vdc/2 ;
            else
                v_a(x) = -vdc/2 ;     
            end
            if carrier_b(x)>=pwm(x)
                v_b(x) = vdc/2 ;
            else
                v_b(x) = -vdc/2 ;
            end    
            if carrier_c(x)>=pwm(x)
                v_c(x) = vdc/2 ;
            else
                v_c(x) = -vdc/2 ;
            end
        end
    case 'Three Level NPC'
        pwm_up = 0.5 + 0.5*sawtooth(2*pi*fs*t + pi/2,1/2) ;       
        pwm_down = - 0.5* + 0.5*sawtooth(2*pi*fs*t + pi/2,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T2 on 
                v_a(x) = vdc/2 ;
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x) % T2 T3 on and T1 off
                v_a(x) = 0 ;
            end
            if carrier_a(x)<=pwm_down(x) % T3 T4 on
                v_a(x) = -vdc/2 ;
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x) % T4 T1 off T2 T3 on
                v_a(x) = 0 ;
            end
            % Leg B
            if carrier_b(x)>=pwm_up(x)
                v_b(x) = vdc/2 ;
            else
                v_b(x) = 0 ;
            end
            if carrier_b(x)<=pwm_down(x)
                v_b(x) = -vdc/2 ;
            elseif carrier_b(x)<=pwm_down(x) && carrier_b(x)<=pwm_up(x)
                v_b(x) = 0 ;
            end
            % Leg C
            if carrier_c(x)>=pwm_up(x)
                v_c(x) = vdc/2 ;
            else
                v_c(x) = 0 ;
            end
            if carrier_c(x)<=pwm_down(x)
                v_c(x) = -vdc/2 ;
            elseif carrier_c(x)<=pwm_down(x) && carrier_c(x)<=pwm_up(x)
                v_c(x) = 0 ;
            end
        end     
    case 'Three Level TTYPE'
        pwm_up = 0.5 + 0.5*sawtooth(2*pi*fs*t + pi/2,1/2) ;       
        pwm_down = - 0.5* + 0.5*sawtooth(2*pi*fs*t + pi/2,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T3 on
                v_a(x) = vdc/2 ;
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x)% T1 off T2 T3 on
                v_a(x) = 0 ;
            end
            if carrier_a(x)<=pwm_down(x) % T4 on
                v_a(x) = -vdc/2 ;
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x)
                v_a(x) = 0 ;
            end
            % Leg B
            if carrier_b(x)>=pwm_up(x)
                v_b(x) = vdc/2 ;
            else
                v_b(x) = 0 ;
            end
            if carrier_b(x)<=pwm_down(x)
                v_b(x) = -vdc/2 ;
            elseif carrier_b(x)<=pwm_down(x) && carrier_b(x)<=pwm_up(x)
                v_b(x) = 0 ;
            end
            % Leg C
            if carrier_c(x)>=pwm_up(x)
                v_c(x) = vdc/2 ;
            else
                v_c(x) = 0 ;
            end
            if carrier_c(x)<=pwm_down(x)
                v_c(x) = -vdc/2 ;
            elseif carrier_c(x)<=pwm_down(x) && carrier_c(x)<=pwm_up(x)
                v_c(x) = 0 ;
            end
        end
end

DC_Design.v_a = v_a ;
DC_Design.v_b = v_b ;
DC_Design.v_c = v_c ;
% 
% switch Topology 
%     case {'Two Level','Two Level - SiC'}
%             lw=1.25;
%             figure;
%             title('Carriers and PWM')
%             hold on
%             plot(t,carrier_a,'r','LineWidth',lw)
%             plot(t,carrier_b,'g','LineWidth',lw)
%             plot(t,carrier_c,'b','LineWidth',lw)
%             plot(t,pwm,'k','LineWidth',lw)
%             grid on
%     case {'Three Level NPC','Three Level TTYPE'}
%             lw=1.25;
%             figure;
%             title('Carriers and PWM')
%             hold on
%             plot(t,carrier_a,'r','LineWidth',lw)
%             plot(t,carrier_b,'g','LineWidth',lw)
%             plot(t,carrier_c,'b','LineWidth',lw)
%             plot(t,pwm_up,'k','LineWidth',lw)
%             plot(t,pwm_down,'k','LineWidth',lw)
%             grid on
% end
end