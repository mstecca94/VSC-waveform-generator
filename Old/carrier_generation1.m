function [ Wave ] = carrier_generation1 ( Wave )

t = Wave.Input.t ;
vdc = Wave.Input.vdc ;
fg = Wave.Input.fg ;

carrier_a = 0*t ;
carrier_b = 0*t ;
carrier_c = 0*t ;
M = Wave.Input.M ;
Modulation = Wave.Input.Modulation ;
Topology = Wave.Input.Topology ;

boh = Wave.Input.boh;
switch Topology
    case {'Two Level','Two Level - SiC'}
        switch Modulation
            case 'S-PWM'
                carrier_a = M*sin(2*pi*fg*t)   ;
                carrier_b = M*sin(2*pi*fg*t-2*pi/3) ;
                carrier_c = M*sin(2*pi*fg*t+2*pi/3);
            case 'Third Hamonic Injection'
                M_3 = Wave.Input.M_3 ;
                carrier_a = (M*sin(2*pi*fg*t) + M_3*sin(3*2*pi*fg*t))  ;
                carrier_b = (M*sin(2*pi*fg*t-2*pi/3) + M_3*sin(3*2*pi*fg*t)) ;
                carrier_c = (M*sin(2*pi*fg*t+2*pi/3) + M_3*sin(3*2*pi*fg*t));
            case 'C-PWM'
                for x=1:size(t,2)
                    angle_vector = t/0.02*2*pi;
                    angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
                    if angle_vector(x)>=2*pi/3 && angle_vector(x)<=pi
                       carrier_a(x) = sqrt(3)/2*M*sin(angle_vector(x)+pi/6+boh);
                       carrier_b(x) = sqrt(3)/2*M*sin(angle_vector(x)-5*pi/6+boh);
                       carrier_c(x) = 3/2*M*sin(angle_vector(x)+2*pi/3+boh);

                   elseif angle_vector(x)>=pi/3 && angle_vector(x)<=2*pi/3
                       carrier_a(x) = 3/2*M*sin(angle_vector(x)+boh);
                       carrier_b(x) = sqrt(3)/2*M*cos(angle_vector(x)+boh);
                       carrier_c(x) = -sqrt(3)/2*M*cos(angle_vector(x)+boh);

                   elseif angle_vector(x)>=0 && angle_vector(x)<=pi/3
                       carrier_a(x) = sqrt(3)/2*M*sin(angle_vector(x)-pi/6+boh);
                       carrier_b(x) = 3/2*M*sin(angle_vector(x)-2*pi/3+boh);
                       carrier_c(x) = sqrt(3)/2*M*sin(angle_vector(x)+5*pi/6+boh);

                   elseif angle_vector(x)>=-pi/3 && angle_vector(x)<=0
                       carrier_a(x) = sqrt(3)/2*M*sin(angle_vector(x)+pi/6+boh);
                       carrier_b(x) = sqrt(3)/2*M*sin(angle_vector(x)-5*pi/6+boh);
                       carrier_c(x) = 3/2*M*sin(angle_vector(x)+2*pi/3+boh);

                    elseif angle_vector(x)>=-2*pi/3 && angle_vector(x)<=-pi/3
                       carrier_a(x) = 3/2*M*sin(angle_vector(x)+boh);
                       carrier_b(x) = sqrt(3)/2*M*cos(angle_vector(x)+boh);
                       carrier_c(x) = -sqrt(3)/2*M*cos(angle_vector(x)+boh);

                   elseif angle_vector(x)>=-pi && angle_vector(x)<=-2*pi/3
                       carrier_a(x) = sqrt(3)/2*M*sin(angle_vector(x)-pi/6+boh);
                       carrier_b(x) = 3/2*M*sin(angle_vector(x)-2*pi/3+boh);
                       carrier_c(x) = sqrt(3)/2*M*sin(angle_vector(x)+5*pi/6+boh);
                    end
                end  
            case 'D-PWM'
                for x=1:size(t,2)
                    angle_vector = t/0.02*2*pi ;
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
        end
        
    case {'Three Level NPC','Three Level TTYPE'}
        
        switch Modulation
            case 'S-PWM'
                carrier_a = M*cos(2*pi*fg*t)   ;
                carrier_b = M*cos(2*pi*fg*t-2*pi/3) ;
                carrier_c = M*cos(2*pi*fg*t+2*pi/3);
            case 'Third Hamonic Injection'
                M_3 = Wave.Input.M_3 ;
                carrier_a = (M*cos(2*pi*fg*t) - M_3*cos(3*2*pi*fg*t))  ;
                carrier_b = (M*cos(2*pi*fg*t-2*pi/3) - M_3*cos(3*2*pi*fg*t)) ;
                carrier_c = (M*cos(2*pi*fg*t+2*pi/3) - M_3*cos(3*2*pi*fg*t));
            case 'C-PWM'
                for x=1:size(t,2)
                    angle_vector = t/0.02*2*pi;
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
            case 'D-PWM'
                for x=1:size(t,2)
                    angle_vector = t/0.02*2*pi;
                    angle_vector(angle_vector(:)>pi)=angle_vector(angle_vector(:)>pi)-2*pi;
                    if angle_vector(x)>=5*pi/6 && angle_vector(x)<=pi
                       carrier_a(x) =  -1;
                       carrier_b(x) =  -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
                       carrier_c(x) =  -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

                   elseif angle_vector(x)>=pi/2 && angle_vector(x)<=5*pi/6
                       carrier_a(x) = +1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
                       carrier_b(x) = +1;
                       carrier_c(x) = +1-sqrt(3)*M*sin(angle_vector(x));

                   elseif angle_vector(x)>=pi/6 && angle_vector(x)<=pi/2
                       carrier_a(x) = -1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
                       carrier_b(x) = -1+sqrt(3)*M*sin(angle_vector(x));
                       carrier_c(x) = -1;

                   elseif angle_vector(x)>=-pi/6 && angle_vector(x)<=pi/6
                       carrier_a(x) = +1;
                       carrier_b(x) = +1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
                       carrier_c(x) = +1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

                    elseif angle_vector(x)>=-pi/2 && angle_vector(x)<=-pi/6
                       carrier_a(x) = -1+sqrt(3)*M*cos(angle_vector(x)+pi/6);
                       carrier_b(x) = -1;
                       carrier_c(x) = -1-sqrt(3)*M*sin(angle_vector(x));

                   elseif angle_vector(x)>=-5*pi/6 && angle_vector(x)<=-pi/2
                       carrier_a(x) = +1-sqrt(3)*M*cos(angle_vector(x)+5*pi/6);
                       carrier_b(x) = +1+sqrt(3)*M*sin(angle_vector(x));
                       carrier_c(x) = +1;

                   elseif angle_vector(x)>=-pi && angle_vector(x)<=-5*pi/6
                       carrier_a(x) = -1;
                       carrier_b(x) = -1-sqrt(3)*M*cos(angle_vector(x)+pi/6);
                       carrier_c(x) = -1+sqrt(3)*M*cos(angle_vector(x)+5*pi/6);

                    end
                end  
        end
        
end
carrier_a = vdc/2*carrier_a ;
carrier_b = vdc/2*carrier_b ;
carrier_c = vdc/2*carrier_c ;

Wave.Carrier.carrier_a = carrier_a ;
Wave.Carrier.carrier_b = carrier_b ;
Wave.Carrier.carrier_c = carrier_c ;

