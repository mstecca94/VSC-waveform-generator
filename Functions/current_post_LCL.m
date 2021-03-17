function [ Wave ] = current_post_LCL ( Wave )

t = Wave.Input.t ;
vdc = Wave.Input.vdc ;
fs = Wave.Input.fs ;
fg = Wave.Input.fg ;
I = Wave.Input.I ;
phi = Wave.Input.phi ;
Topology = Wave.Input.Topology ;

carrier_a = Wave.Carrier.carrier_a ;

i_a_wr = Wave.Current.i_converter_side ;

%%
switch Topology
    case 'Two Level'
        pwm = vdc/2*sawtooth(2*pi*fs*t+pi/2,1/2) ;
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
    case 'Two Level - SiC'
        pwm = vdc/2*sawtooth(2*pi*fs*t+pi/2,1/2) ;
        i_T1_wr = 0*t ;
        i_D1_wr = 0*t ;
        i_T2_wr = 0*t ;
        i_D2_wr = 0*t ;
        for x=1:size(t,2)
            if carrier_a(x)>=pwm(x)
                i_T1_wr(x) = i_a_wr(x) ;
            else
                i_T2_wr(x) = i_a_wr(x) ;
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
        pwm_up = 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t + pi/2,1/2) ;       
        pwm_down = - 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t + pi/2,1/2) ;
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
        pwm_up = 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t + pi,1/2) ;       
        pwm_down = - 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t + pi,1/2) ;
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

%%

switch Topology
    case {'Two Level','Two Level - SiC'}
        Wave.CurrentWR.i_T1_wr = i_T1_wr ;
        Wave.CurrentWR.i_T2_wr = i_T2_wr ;
        Wave.CurrentWR.i_D1_wr = i_D1_wr ;
        Wave.CurrentWR.i_D2_wr = i_D2_wr ;
    case 'Three Level NPC'
        Wave.CurrentWR.i_T1_wr = i_T1_wr ;
        Wave.CurrentWR.i_T2_wr = i_T2_wr ;
        Wave.CurrentWR.i_D1_wr = i_D1_wr ;
        Wave.CurrentWR.i_D2_wr = i_D2_wr ;
        Wave.CurrentWR.i_T3_wr = i_T3_wr ;
        Wave.CurrentWR.i_T4_wr = i_T4_wr ;
        Wave.CurrentWR.i_D3_wr = i_D3_wr ;
        Wave.CurrentWR.i_D4_wr = i_D4_wr ;
        Wave.CurrentWR.i_D5_wr = i_D5_wr ;
        Wave.CurrentWR.i_D6_wr = i_D6_wr ;
    case 'Three Level TTYPE'
        Wave.CurrentWR.i_T1_wr = i_T1_wr ;
        Wave.CurrentWR.i_T2_wr = i_T2_wr ;      
        Wave.CurrentWR.i_D1_wr = i_D1_wr ;
        Wave.CurrentWR.i_D2_wr = i_D2_wr ;
        Wave.CurrentWR.i_T3_wr = i_T3_wr ;
        Wave.CurrentWR.i_T4_wr = i_T4_wr ;
        Wave.CurrentWR.i_D3_wr = i_D3_wr ;
        Wave.CurrentWR.i_D4_wr = i_D4_wr ;
end

if Wave.Input.plot_arm_volt == 1
    
    lw = 1.25 ;  

    switch Topology
    case {'Two Level','Two Level - SiC'}
            
            figure;
            sgtitle('Current in semiconductor with ripple')
            hold on
            subplot(4,1,1)
            plot(t,i_T1_wr,'b','LineWidth',lw)
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,2)
            plot(t,i_T2_wr,'b','LineWidth',lw)
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,3)
            plot(t,i_D1_wr,'r','LineWidth',lw)
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,4)
            plot(t,i_D2_wr,'r','LineWidth',lw)
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
        case 'Three Level NPC'
           
            figure;
            sgtitle('Current in semiconductor with ripple')
            subplot(5,1,1)
            hold on
            plot(t,i_T1_wr,'b','LineWidth',lw)
            plot(t,i_T4_wr,'r','LineWidth',lw)
            legend('T1','T4')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(5,1,2)
            hold on
            plot(t,i_T2_wr,'b','LineWidth',lw)
            plot(t,i_T3_wr,'r','LineWidth',lw)
            legend('T2','T3')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(5,1,3)
            hold on
            plot(t,i_D1_wr,'b','LineWidth',lw)
            plot(t,i_D4_wr,'r','LineWidth',lw)
            legend('D1','D4')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(5,1,4)
            hold on
            plot(t,i_D2_wr,'b','LineWidth',lw)
            plot(t,i_D3_wr,'r','LineWidth',lw)
            legend('D2','D3')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]') 
            
            subplot(5,1,5)
            hold on
            plot(t,i_D5_wr,'b','LineWidth',lw)
            plot(t,i_D6_wr,'r','LineWidth',lw)
            legend('D5','D6')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
        case 'Three Level TTYPE'

            figure;
            sgtitle('Current in semiconductor with ripple')
            hold on
            subplot(4,1,1)
            hold on
            plot(t,i_T1_wr,'b','LineWidth',lw)
            plot(t,i_T4_wr,'r','LineWidth',lw)
            legend('T1','T4')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,2)
            hold on
            plot(t,i_T2_wr,'b','LineWidth',lw)
            plot(t,i_T3_wr,'r','LineWidth',lw)
            legend('T2','T3')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,3)
            hold on
            plot(t,i_D1_wr,'b','LineWidth',lw)
            plot(t,i_D4_wr,'r','LineWidth',lw)
            legend('D1','D4')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
            
            subplot(4,1,4)
            hold on
            plot(t,i_D2_wr,'b','LineWidth',lw)
            plot(t,i_D3_wr,'r','LineWidth',lw)
            legend('D2','D3')
            grid on
            xlabel('Time [s]')
            ylabel('Current [A]')
    end

end

end