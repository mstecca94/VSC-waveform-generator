Pmax = Wave.Input.Pmax ;

vdc_range = Wave.Input.Vdcmin:40:Wave.Input.Vdcmax ;
P_range = Pmax*0.1:Pmax*0.1:Pmax ;
M_range = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 
%% 
for y = 1:size(vdc_range,2)
    Wave.Input.vdc = vdc_range(y) ; % 1kV DC
    Wave.Input.M = 2*Wave.Input.vll*sqrt(2/3)/Wave.Input.vdc; 
    for x = 1:size(P_range,2)
        
        Efficiency(x,y) = WaveR.Semiconductor.Efficiency(x,y)*WaveR.Inductor.Efficiency(x,y)*...
            WaveR.DClink.Efficiency(x,y)*WaveR.AC_Cap.Efficiency(x,y)/100/100/100;
        Losses(x,y) = WaveR.Semiconductor.Losses(x,y) + WaveR.Inductor.Losses(x,y) +...
            WaveR.DClink.Losses(x,y) + WaveR.AC_Cap.Losses(x,y);
    end
end

[X,Y]=meshgrid(vdc_range,P_range/Pmax);
%%
figure;

surf(X,Y,Efficiency)
grid on
ylabel('Output Power [p.u.]')
xlabel('DC Voltage [V]')

zlabel('Efficiency [%]')
%% 

x = Wave.Input.Vdcmin:40:Wave.Input.Vdcmax ;
y = Pmax*0.1:Pmax*0.1:Pmax ;

xx =  Wave.Input.Vdcmin:0.1:Wave.Input.Vdcmax ;
mm =  2*Wave.Input.vll*sqrt(2/3)/xx ;
yy =  Pmax*0.05:Pmax*0.001:Pmax ;
for xy = 1:size(Efficiency,1)
    zz(xy,:) = pchip(x(1,:),Efficiency(xy,:),xx) ; 
end
%%
for xy = 1:size(zz,2)
    zzz(:,xy) = pchip(y,zz(:,xy),yy) ; 
end
%%
EfficiencyVDC_P = zzz;
[XX,YY] = meshgrid( xx , yy ) ;
[XXm,YYm] = meshgrid( mm , yy ) ;
%%
figure;
surf(XX,YY,zzz)
xlabel('x')
ylabel('y')
zlabel('z')
shading interp

figure;
surf(XXm,YYm,zzz)
xlabel('x')
ylabel('y')
zlabel('z')
shading interp

%%
readme = {'x is Vdc or M - y is the output power and so the 50 Hz current'};
save('EfficiencyVDC_P','EfficiencyVDC_P','XX','YY','XXm','YYm','readme')