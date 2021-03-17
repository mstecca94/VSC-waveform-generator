function [ Wave ] = LVRT ( Wave )
%%
fs = Wave.Input.fs ;
I = Wave.Input.I ;
LVRT_maxI = Wave.Input.LVRT_maxI ;
Lc = Wave.Input.LCL_ad(2,:) ;
Lg = Wave.Input.LCL_ad(3,:) ;
Ripple = Wave.Input.LCL_ad(5,:)/100*I ;
dt = 1/fs ;
% V = Wave.Input.vll*sqrt(2/3) ;
V = Wave.Input.vdc ;

%%
L = Lc + Lg ;
di = V*dt./L;
LVRT_I = Ripple + di ;
LVRT_I2 = Ripple + di ;
[~,a] = find(LVRT_I(LVRT_I>LVRT_maxI));
b = LVRT_I>LVRT_maxI;
xx = Wave.Input.LCL_ad(1,:);
xx(1,b) = 0 ;

Wave.Input.LCL_ad(2,b) = 0 ;
Wave.Input.LCL_ad(3,a) = 0 ;
Wave.Input.LCL_ad(4,a) = 0 ;
Wave.Input.LCL_ad(5,a) = 0 ;

Wave.Input.Lg_ad(1,b) = NaN ;
Wave.Input.Lc_ad(1,b) = NaN ;
Wave.Input.Ripple_ad(1,b) = NaN ;
Wave.Input.C_ad(1,b) = NaN ;

LVRT_I(1,b) = 0 ;

figure;
hold on
yline(LVRT_maxI);
plot(LVRT_I)
plot(LVRT_I2)
box on
grid on
legend('LVRT limit','LVRT current')
%%
% fg = Wave.Input.fg ;
% C = Wave.Input.LCL_ad(4,:) ;
% wres = Wave.Input.LCL_ad(1,:)*fs ;
% wlc=sqrt(1./(Lc.*C));
% s = 1i*2*pi*fg;
% Y11 = (s.^2 + wlc.^2) ./ (Lc.*s.*(s.^2 + wres.^2)) ;
% i50HzLVRT = abs(Wave.FFT.v_a_fft(2)*Y11);
% 
% figure;plot(Lc)
% figure;plot(C)
% %%
% figure;plot(wres)
% figure;plot(wlc)
% %%
% figure;plot(abs(Y11))
% figure;plot(i50HzLVRT)