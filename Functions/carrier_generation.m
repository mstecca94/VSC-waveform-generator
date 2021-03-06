function [ Wave ] = carrier_generation ( Wave )

t = Wave.Input.t ;
phi = Wave.Input.phi ;
vdc = Wave.Input.vdc ;
fg = Wave.Input.fg ;
tmax = 1/Wave.Input.fg ;
carrier_a = 0*t ;
carrier_b = 0*t ;
carrier_c = 0*t ;
M = Wave.Input.M ;
Modulation = Wave.Input.Modulation ;
%%
switch Modulation
    case 'MSL D-PWM'
        [ va_mod ] = MSLDPWM ( Wave ) ; 
        carrier_a = va_mod ;
        angle_vector = t/tmax*2*pi-pi;
        angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
%         [~,a]=min(abs(angle_vector(:)-pi/2));
%         carrier_a = [carrier_a(a:end) carrier_a(1:a-1) ] ;
        [~,b]=min(abs(angle_vector(:)-pi/3));
        [~,c]=min(abs(angle_vector(:)+pi/3));
        carrier_b = [carrier_a(b:end) carrier_a(1:b-1) ] ;
        carrier_c = [carrier_a(c:end) carrier_a(1:c-1) ] ;
    case 'S-PWM'
        carrier_a = M*sin(2*pi*fg*t)   ;
        carrier_b = M*sin(2*pi*fg*t-2*pi/3) ;
        carrier_c = M*sin(2*pi*fg*t+2*pi/3);
    case 'Third Harmonic Injection 1/4'
        M_3 = M/4 ;
        carrier_a = (M*sin(2*pi*fg*t) + M_3*sin(3*2*pi*fg*t))  ;
        carrier_b = (M*sin(2*pi*fg*t-2*pi/3) + M_3*sin(3*2*pi*fg*t)) ;
        carrier_c = (M*sin(2*pi*fg*t+2*pi/3) + M_3*sin(3*2*pi*fg*t));
    case 'Third Harmonic Injection 1/6'
        M_3 = M/6 ;
        carrier_a = (M*sin(2*pi*fg*t) + M_3*sin(3*2*pi*fg*t))  ;
        carrier_b = (M*sin(2*pi*fg*t-2*pi/3) + M_3*sin(3*2*pi*fg*t)) ;
        carrier_c = (M*sin(2*pi*fg*t+2*pi/3) + M_3*sin(3*2*pi*fg*t));
    case 'SV-PWM'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=2*pi/3 && angle_vector(x)<=pi
               carrier_a(x) = sqrt(3)/2*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = sqrt(3)/2*M*cos(angle_vector(x)-5*pi/6);
               carrier_c(x) = 3/2*M*cos(angle_vector(x)+2*pi/3);

           elseif angle_vector(x)>=pi/3 && angle_vector(x)<=2*pi/3
               carrier_a(x) = 3/2*M*cos(angle_vector(x));
               carrier_b(x) = sqrt(3)/2*M*sin(angle_vector(x));
               carrier_c(x) = -sqrt(3)/2*M*sin(angle_vector(x));

           elseif angle_vector(x)>=0 && angle_vector(x)<=pi/3
               carrier_a(x) = sqrt(3)/2*M*cos(angle_vector(x)-pi/6);
               carrier_b(x) = 3/2*M*cos(angle_vector(x)-2*pi/3);
               carrier_c(x) = sqrt(3)/2*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=0
               carrier_a(x) = sqrt(3)/2*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = sqrt(3)/2*M*cos(angle_vector(x)-5*pi/6);
               carrier_c(x) = 3/2*M*cos(angle_vector(x)+2*pi/3);

            elseif angle_vector(x)>=-2*pi/3 && angle_vector(x)<=-pi/3
               carrier_a(x) = 3/2*M*cos(angle_vector(x));
               carrier_b(x) = sqrt(3)/2*M*sin(angle_vector(x));
               carrier_c(x) = -sqrt(3)/2*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-2*pi/3
               carrier_a(x) = sqrt(3)/2*M*cos(angle_vector(x)-pi/6);
               carrier_b(x) = 3/2*M*cos(angle_vector(x)-2*pi/3);
               carrier_c(x) = sqrt(3)/2*M*cos(angle_vector(x)+5*pi/6);
            end
        end 
    case 'D-PWM MIN'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=2*pi/3 && angle_vector(x)<=pi
               carrier_a(x) =  -1.1;
               carrier_b(x) =  -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) =  -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=0 && angle_vector(x)<=2*pi/3
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=-2/3*pi && angle_vector(x)<=0
               carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = -1.1;
               carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-2*pi/3
               carrier_a(x) = -1.1;
               carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

            end
        end 
    case 'D-PWM MAX'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=pi/3 && angle_vector(x)<=pi
               carrier_a(x) =  +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) =  +1;
               carrier_c(x) =  +1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=pi/3
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-pi/3
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;

            end
        end 
    case 'D-PWM 0'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=2*pi/3 && angle_vector(x)<=pi
               carrier_a(x) =  -1.1;
               carrier_b(x) =  -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) =  -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=pi/3 && angle_vector(x)<=2*pi/3
               carrier_a(x) = +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = +1.1;
               carrier_c(x) = +1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=0 && angle_vector(x)<=pi/3
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=0
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

            elseif angle_vector(x)>=-2*pi/3 && angle_vector(x)<=-pi/3
               carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = -1.1;
               carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-2*pi/3
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;

            end
        end 
    case 'D-PWM 1'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=5*pi/6 && angle_vector(x)<=pi
               carrier_a(x) =  -1.1;
               carrier_b(x) =  -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) =  -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=pi/2 && angle_vector(x)<=5*pi/6
               carrier_a(x) = +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = +1.1;
               carrier_c(x) = +1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=pi/6 && angle_vector(x)<=pi/2
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=-pi/6 && angle_vector(x)<=pi/6
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

            elseif angle_vector(x)>=-pi/2 && angle_vector(x)<=-pi/6
               carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = -1.1;
               carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-5*pi/6 && angle_vector(x)<=-pi/2
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-5*pi/6
               carrier_a(x) = -1.1;
               carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

            end
        end
    case 'D-PWM 2'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=2*pi/3 && angle_vector(x)<=pi
               carrier_a(x) =  +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) =  +1.1;
               carrier_c(x) =  +1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=pi/3 && angle_vector(x)<=2*pi/3
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=0 && angle_vector(x)<=pi/3
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=0
               carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = -1.1;
               carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

            elseif angle_vector(x)>=-2*pi/3 && angle_vector(x)<=-pi/3
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-2*pi/3
               carrier_a(x) = -1.1;
               carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

            end
        end
    case 'D-PWM 3'
        for x=1:size(t,2)
            angle_vector = t/tmax*2*pi ;
            angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
            if angle_vector(x)>=5*pi/6 && angle_vector(x)<=pi
               carrier_a(x) =  +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) =  +1.1;
               carrier_c(x) =  +1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=2*pi/3 && angle_vector(x)<=5*pi/6
               carrier_a(x) = -1.1;
               carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=pi/2 && angle_vector(x)<=2*pi/3
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=pi/3 && angle_vector(x)<=pi/2
               carrier_a(x) = +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = +1.1;
               carrier_c(x) = +1-sqrt(3)*M*sin(angle_vector(x));

            elseif angle_vector(x)>=pi/6 && angle_vector(x)<=pi/3
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=0 && angle_vector(x)<=pi/6
               carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = -1.1;

           elseif angle_vector(x)>=-pi/6 && angle_vector(x)<=0
               carrier_a(x) =  -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) =  -1.1;
               carrier_c(x) =  -1-sqrt(3)*M*sin(angle_vector(x));

           elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=-pi/6
               carrier_a(x) = +1.1;
               carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=-pi/2 && angle_vector(x)<=-pi/3
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;

           elseif angle_vector(x)>=-2*pi/3 && angle_vector(x)<=-pi/2
               carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_b(x) = -1.1;
               carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

            elseif angle_vector(x)>=-5*pi/6 && angle_vector(x)<=-2*pi/3
               carrier_a(x) = -1.1;
               carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
               carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

           elseif angle_vector(x)>=-pi && angle_vector(x)<=-5*pi/6
               carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
               carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
               carrier_c(x) = +1.1;
               
            end
        end        
end

%%

switch Modulation
    case {'SV-PWM','D-PWM MIN','D-PWM MAX','D-PWM 0','D-PWM 1','D-PWM 2','D-PWM 3','MSL D-PWM'}
        [~,a]=min(abs(angle_vector(:)+pi/2));
        carrier_a = [carrier_a(a:end) carrier_a(1:a-1) ] ;
        carrier_b = [carrier_b(a:end) carrier_b(1:a-1) ] ;
        carrier_c = [carrier_c(a:end) carrier_c(1:a-1) ] ;
end

carrier_a = vdc/2*carrier_a ;
carrier_b = vdc/2*carrier_b ;
carrier_c = vdc/2*carrier_c ;

%%
Wave.Carrier.carrier_a = carrier_a ;
Wave.Carrier.carrier_b = carrier_b ;
Wave.Carrier.carrier_c = carrier_c ;

