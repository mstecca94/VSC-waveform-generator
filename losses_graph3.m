clear all
close all
clc
load('Losses3.mat')

disp('z - Frequency range analysed [kHz]:')
ModComparison(1,1,1).Wave.Input.fs_range/1000

disp('y - Phase Shift [deg]:')
ModComparison(1,1,1).Wave.Input.phi_range/pi*180

disp('x - Modulation Strategies:')
ModComparison(1,1,1).Wave.Input.ModulationStrategies


for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for yy = 1:size(ModComparison(1,1,1).Wave.Input.phi_range,2)
    Cond_SVPWM(yy,zz)= ModComparison(1,yy,zz).Wave.Losses.Pc_tot*3;
    Sw_SVPWM(yy,zz)= ModComparison(1,yy,zz).Wave.Losses.Ps_tot*3;
    Eff_SVPWM(yy,zz)= ModComparison(1,yy,zz).Wave.Losses.Efficiency;
    
    Cond_MSLDPWM(yy,zz)= ModComparison(2,yy,zz).Wave.Losses.Pc_tot*3;
    Sw_MSLDPWM(yy,zz)= ModComparison(2,yy,zz).Wave.Losses.Ps_tot*3;
    Eff_MSLDPWM(yy,zz)= ModComparison(2,yy,zz).Wave.Losses.Efficiency;
end
end

[X,Y]=meshgrid(ModComparison(1,1,1).Wave.Input.fs_range/1000,ModComparison(1,1,1).Wave.Input.phi_range/pi*180);

figure;
sgtitle('MSL D-PWM vs SV-PWM')
subplot(3,3,1)
surf(X,Y,Cond_SVPWM)
hold on
title('Conduction Losses SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,2)
surf(X,Y,Cond_MSLDPWM)
hold on
title('Conduction Losses MSL D-PWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,3)
surf(X,Y,Cond_MSLDPWM-Cond_SVPWM)
hold on
title('Conduction Losses Difference MSL-DPWM1 - SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,4)
surf(X,Y,Sw_SVPWM)
hold on
title('Switching Losses SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,5)
surf(X,Y,Sw_MSLDPWM)
hold on
title('Switching Losses MSL-DPWM1')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,6)
surf(X,Y,Sw_MSLDPWM-Sw_SVPWM)
hold on
title('Switching Losses Difference MSL-DPWM1 - SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,7)
surf(X,Y,Eff_SVPWM)
hold on
title('Efficiency SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,8)
surf(X,Y,Eff_MSLDPWM)
hold on
title('Efficiency MSL-DPWM1')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')

subplot(3,3,9)
surf(X,Y,Eff_MSLDPWM-Eff_SVPWM)
hold on
title('Efficiency Difference MSL-DPWM1 - SVPWM')
xlabel('Switching Frequency [kHz]')
ylabel('Phi [deg]')
