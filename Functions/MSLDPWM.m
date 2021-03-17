function [ va_mod ] = MSLDPWM ( Wave ) 
%% Define


fo=Wave.Input.fg ;
w=2*pi/fo;
PHI=Wave.Input.phi ;
phi=Wave.Input.phi/pi*180 ;
mi= Wave.Input.M ;
%%
% wt=(-pi-PHI):0.01:(pi-PHI);

t=Wave.Input.t ;
wt=t*fo*2*pi-pi;

%%

va=mi*cos(wt);
% ia=cos(wt-PHI);

if phi>=-30 && phi<=30
va_mod=1.1.*(wt<=(pi/6+PHI) & wt>=(-pi/6+PHI))+(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(pi/6+PHI) & wt<=(pi/2+PHI))...,
            +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(pi/2+PHI) & wt<=(5*pi/6+PHI))...,
            +(-1.1).*(wt>=(5*pi/6+PHI) | wt<=(-5*pi/6+PHI))...，
            +(1.1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(-5*pi/6+PHI) & wt<=(-pi/2+PHI))...,
            +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-pi/2+PHI) & wt<=(-pi/6+PHI));
elseif ( phi>30 && phi<=60 ) || (phi>=-60 && phi<-30 )
    PHI=sign(phi)*30*pi/180;
    va_mod=1.1.*(wt<=(pi/6+PHI) & wt>=(-pi/6+PHI))+(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(pi/6+PHI) & wt<=(pi/2+PHI))...,
            +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(pi/2+PHI) & wt<=(5*pi/6+PHI))...,
            +(-1.1).*(wt>=(5*pi/6+PHI) | wt<=(-5*pi/6+PHI))...，
            +(1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(-5*pi/6+PHI) & wt<=(-pi/2+PHI))...,
            +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-pi/2+PHI) & wt<=(-pi/6+PHI));
elseif 	phi>60
          va_mod=(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt<=(PHI-pi/3) & wt>=0)...,
                      +(1.1).*(wt>=(PHI-pi/3) & wt<=pi/3)...,
                      +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(pi/3) & wt<=PHI)...,
                      +(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=PHI & wt<=(2*pi/3))...,
                      +(-1.1).*(wt>=(2*pi/3) & wt<=(PHI+pi/3))...,
                      +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=((PHI+pi/3)) & wt<=(pi))...,
                      +(1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=-pi & wt<=(-pi+PHI-pi/3))...,
                      +(-1.1).*(wt>=(-pi+PHI-pi/3) & wt<=(-2*pi/3))...,
                      +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-2*pi/3) & wt<=(-2*pi/3+PHI-pi/3))...,
                      +(1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(-2*pi/3+PHI-pi/3) & wt<=(-pi/3))...,
                      +(1.1).*(wt>=(-pi/3) & wt<=(-pi/3+PHI-pi/3))...,
                      +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-pi/3+PHI-pi/3) & wt<=0)...,
              ;
else
        PHI=PHI+pi;
          va_mod=(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt<=(PHI-pi/3) & wt>=0)...,
                      +(1.1).*(wt>=(PHI-pi/3) & wt<=pi/3)...,
                      +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(pi/3) & wt<=PHI)...,
                      +(-1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=PHI & wt<=(2*pi/3))...,
                      +(-1.1).*(wt>=(2*pi/3) & wt<=(PHI+pi/3))...,
                      +(1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=((PHI+pi/3)) & wt<=(pi))...,
                      +(1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=-pi & wt<=(-pi+PHI-pi/3))...,
                      +(-1.1).*(wt>=(-pi+PHI-pi/3) & wt<=(-2*pi/3))...,
                      +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-2*pi/3) & wt<=(-2*pi/3+PHI-pi/3))...,
                      +(1-sqrt(3)*mi*cos(wt+5*pi/6)).*(wt>=(-2*pi/3+PHI-pi/3) & wt<=(-pi/3))...,
                      +(1.1).*(wt>=(-pi/3) & wt<=(-pi/3+PHI-pi/3))...,
                      +(-1+sqrt(3)*mi*cos(wt+pi/6)).*(wt>=(-pi/3+PHI-pi/3) & wt<=0)...,
              ;
end
   

% 
% plot(wt,va,'Color',[227/255 115/255 33/255],'linewidth',2)
% hold on
% plot(wt,ia,'--','Color',[107/255 31/255 115/255],'linewidth',2)
% plot(wt,va_mod,'Color',[1 204/255 51/255],'linewidth',2)
% 
% axis([-pi pi -1.1 1.1]);
% grid on
% legend('va','ia','va_{mod}');