function [ Wave ] = arm_voltage ( Wave )

Wire = Wave.Input.Wire ;
t = Wave.Input.t ;
vdc = Wave.Input.vdc ;
vll = Wave.Input.vll ;
fs = Wave.Input.fs ;
fg = Wave.Input.fg ;
I = Wave.Input.I ;
phi = Wave.Input.phi ;
Topology = Wave.Input.Topology ;

[ Wave ] = carrier_generation ( Wave ) ;

carrier_a = Wave.Carrier.carrier_a ;
carrier_b = Wave.Carrier.carrier_b ;
carrier_c = Wave.Carrier.carrier_c ;

i_50Hz_a = I*sqrt(2)*sin(2*pi*fg*t-phi) ;
i_50Hz_b = I*sqrt(2)*sin(2*pi*fg*t-phi-2*pi/3) ;
i_50Hz_c = I*sqrt(2)*sin(2*pi*fg*t-phi+2*pi/3) ;

Vga = vll*sqrt(2/3)*sin(2*pi*fg*t) ;
Vgb = vll*sqrt(2/3)*sin(2*pi*fg*t-2*pi/3) ;
Vgc = vll*sqrt(2/3)*sin(2*pi*fg*t+2*pi/3) ;

Vgab =  Vga - Vgb;
Vgbc =  Vgb - Vgc;
Vgca =  Vgc - Vga;

%%
switch Topology
    case {'Two Level','Two Level - SiC'}
        pwm = vdc/2*sawtooth(2*pi*fs*t + pi/2,1/2) ;
        i_T1 = 0*t ;
        i_D1 = 0*t ;
        i_T2 = 0*t ;
        i_D2 = 0*t ;
        for x=1:size(t,2)
            if carrier_a(x)>=pwm(x)
                v_a(x) = vdc/2 ;
                if i_50Hz_a(x)>=0
                    i_T1(x) = i_50Hz_a(x) ;
                else
                    i_D1(x) = i_50Hz_a(x) ;
                end
            else
                v_a(x) = -vdc/2 ;     
                if i_50Hz_a(x)>=0
                    i_D2(x) = i_50Hz_a(x) ;
                else
                    i_T2(x) = i_50Hz_a(x) ;
                end
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
        i_T1 = 0*t ;
        i_D1 = 0*t ;
        i_T2 = 0*t ;
        i_D2 = 0*t ;
        i_T3 = 0*t ;
        i_D3 = 0*t ;
        i_T4 = 0*t ;
        i_D4 = 0*t ;
        i_D5 = 0*t ;
        i_D6 = 0*t ;
        pwm_up = 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t ,1/2) ;       
        pwm_down = - 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t ,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T2 on 
                v_a(x) = vdc/2 ;
                if i_50Hz_a(x)>=0
                    i_T1(x) = i_50Hz_a(x) ;
                    i_T2(x) = i_50Hz_a(x) ;
                else
                    i_D1(x) = i_50Hz_a(x) ;
                    i_D2(x) = i_50Hz_a(x) ;
                end
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x) % T2 T3 on and T1 off
                v_a(x) = 0 ;
                if i_50Hz_a(x)>=0
                    i_D5(x) = i_50Hz_a(x) ;
                    i_T2(x) = i_50Hz_a(x) ;
                else
                    i_T3(x) = i_50Hz_a(x) ;
                    i_D6(x) = i_50Hz_a(x) ;
                end
            end
            if carrier_a(x)<=pwm_down(x) % T3 T4 on
                v_a(x) = -vdc/2 ;
                if i_50Hz_a(x)>=0
                    i_D3(x) = i_50Hz_a(x) ;
                    i_D4(x) = i_50Hz_a(x) ;
                else
                    i_T3(x) = i_50Hz_a(x) ;
                    i_T4(x) = i_50Hz_a(x) ;
                end
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x) % T4 T1 off T2 T3 on
                v_a(x) = 0 ;
                if i_50Hz_a(x)>=0
                    i_D5(x) = i_50Hz_a(x) ;
                    i_T2(x) = i_50Hz_a(x) ;
                else
                    i_T3(x) = i_50Hz_a(x) ;
                    i_D6(x) = i_50Hz_a(x) ;
                end
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
        i_T1 = 0*t ;
        i_D1 = 0*t ;
        i_T2 = 0*t ;
        i_D2 = 0*t ;
        i_T3 = 0*t ;
        i_D3 = 0*t ;
        i_T4 = 0*t ;
        i_D4 = 0*t ;
        pwm_up = 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t,1/2) ;       
        pwm_down = - 0.5*vdc/2 + 0.5*vdc/2*sawtooth(2*pi*fs*t,1/2) ;
        for x=1:size(t,2)
            % Leg A with currents in semiconductors
            if carrier_a(x)>=pwm_up(x) && carrier_a(x)>=pwm_down(x) % T1 T3 on
                v_a(x) = vdc/2 ;
                if i_50Hz_a(x)>=0
                    i_T1(x) = i_50Hz_a(x) ;
                else
                    i_D1(x) = i_50Hz_a(x) ;
                end
            elseif carrier_a(x)<pwm_up(x) && carrier_a(x)>=pwm_down(x)% T1 off T2 T3 on
                v_a(x) = 0 ;
                if i_50Hz_a(x)>=0
                    i_D2(x) = i_50Hz_a(x) ;
                    i_T3(x) = i_50Hz_a(x) ;
                else
                    i_T2(x) = i_50Hz_a(x) ;
                    i_D3(x) = i_50Hz_a(x) ;
                end
            end
            if carrier_a(x)<=pwm_down(x) % T4 on
                v_a(x) = -vdc/2 ;
                if i_50Hz_a(x)>=0
                    i_D4(x) = i_50Hz_a(x) ;
                else
                    i_T4(x) = i_50Hz_a(x) ;
                end
            elseif carrier_a(x)<=pwm_down(x) && carrier_a(x)<=pwm_up(x)
                v_a(x) = 0 ;
                if i_50Hz_a(x)>=0
                    i_D2(x) = i_50Hz_a(x) ;
                    i_T3(x) = i_50Hz_a(x) ;
                else
                    i_T2(x) = i_50Hz_a(x) ;
                    i_D3(x) = i_50Hz_a(x) ;
                end
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

%% Line to line voltage

v_ab = v_a - v_b ;
v_bc = v_b - v_c ;
v_ca = v_c - v_a ;

%% Save 
Wave.Voltage.Vga = Vga ;
Wave.Voltage.Vgb = Vgb ;
Wave.Voltage.Vgc = Vgc ;

Wave.Voltage.Vgab = Vgab ;
Wave.Voltage.Vgbc = Vgbc ;
Wave.Voltage.Vgca = Vgca ;

Wave.Voltage.v_a = v_a ;
Wave.Voltage.v_b = v_b ;
Wave.Voltage.v_c = v_c ;

Wave.Voltage.v_ab = v_ab ;
Wave.Voltage.v_bc = v_bc ;
Wave.Voltage.v_ca = v_ca ;

Wave.Current.i_50Hz_a = i_50Hz_a ;
Wave.Current.i_50Hz_b = i_50Hz_b ;
Wave.Current.i_50Hz_c = i_50Hz_c ;

switch Topology
    case {'Two Level','Two Level - SiC'}
        Wave.Current.i_T1 = i_T1 ;
        Wave.Current.i_T2 = i_T2 ;
        Wave.Current.i_D1 = i_D1 ;
        Wave.Current.i_D2 = i_D2 ;
    case 'Three Level NPC'
        Wave.Current.i_T1 = i_T1 ;
        Wave.Current.i_T2 = i_T2 ;
        Wave.Current.i_D1 = i_D1 ;
        Wave.Current.i_D2 = i_D2 ;
        Wave.Current.i_T3 = i_T3 ;
        Wave.Current.i_T4 = i_T4 ;
        Wave.Current.i_D3 = i_D3 ;
        Wave.Current.i_D4 = i_D4 ;
        Wave.Current.i_D5 = i_D5 ;
        Wave.Current.i_D6 = i_D6 ;
    case 'Three Level TTYPE'
        Wave.Current.i_T1 = i_T1 ;
        Wave.Current.i_T2 = i_T2 ;      
        Wave.Current.i_D1 = i_D1 ;
        Wave.Current.i_D2 = i_D2 ;
        Wave.Current.i_T3 = i_T3 ;
        Wave.Current.i_T4 = i_T4 ;
        Wave.Current.i_D3 = i_D3 ;
        Wave.Current.i_D4 = i_D4 ;
end

if Wave.Input.plot_arm_volt == 1
    lw = 1.25 ;
    
    switch Topology
    case {'Two Level','Two Level - SiC'}
            figure;
            subplot(4,1,1)
            title('Carriers and PWM')
            hold on
            plot(t,carrier_a,'r','LineWidth',lw)
            plot(t,carrier_b,'g','LineWidth',lw)
            plot(t,carrier_c,'b','LineWidth',lw)
            plot(t,pwm,'k','LineWidth',lw)
            grid on

            subplot(4,1,2)
            title('Carrier Leg A')
            hold on
            plot(t,carrier_a/vdc*2,'b','LineWidth',lw)
            plot(t,Vga/vdc*2,'r','LineWidth',lw)
            plot(t,i_50Hz_a/(I*sqrt(2)),'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on

            subplot(4,1,3)
            title('Carrier Leg B')
            hold on
            plot(t,carrier_b/vdc*2,'b','LineWidth',lw)
            plot(t,Vgb/vdc*2,'r','LineWidth',lw)
            plot(t,i_50Hz_b/(I*sqrt(2)),'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on

            subplot(4,1,4)
            title('Carrier Leg C')
            hold on
            plot(t,carrier_c/vdc*2,'b','LineWidth',lw)
            plot(t,Vgc/vdc*2,'r','LineWidth',lw)
            plot(t,i_50Hz_c/(I*sqrt(2)),'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on
            
        case {'Three Level NPC','Three Level TTYPE'}
            figure;
            subplot(4,1,1)
            title('Carriers and PWM')
            hold on
            plot(t,carrier_a,'r','LineWidth',lw)
            plot(t,carrier_b,'g','LineWidth',lw)
            plot(t,carrier_c,'b','LineWidth',lw)
            plot(t,pwm_up,'k','LineWidth',lw)
            plot(t,pwm_down,'k','LineWidth',lw)
            grid on

            subplot(4,1,2)
            title('Carrier Leg A')
            hold on
            plot(t,carrier_a,'b','LineWidth',lw)
            plot(t,Vga,'r','LineWidth',lw)
            plot(t,i_50Hz_a,'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on
            

            subplot(4,1,3)
            title('Carrier Leg B')
            hold on
            plot(t,carrier_b,'b','LineWidth',lw)
            plot(t,Vgb,'r','LineWidth',lw)
            plot(t,i_50Hz_b,'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on
            

            subplot(4,1,4)
            title('Carrier Leg C')
            hold on
            plot(t,carrier_c,'b','LineWidth',lw)
            plot(t,Vgc,'r','LineWidth',lw)
            plot(t,i_50Hz_c,'g','LineWidth',lw)
            legend('Carrier','Voltage','Current')
            grid on
            
    end
    
end

end