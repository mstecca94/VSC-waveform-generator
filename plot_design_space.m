%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\EPE extension'))
ccc
%%
map=pmkmp(256,'CubicL');


figure;
load('DPWM1.mat')
scatter3(Wave.Input.C_ad/Cb,(Wave.Input.Lc_ad+Wave.Input.Lg_ad)/Lb,Wave.Input.Ripple_ad,[],...
    Wave.Input.LCL_ad(1,:),'filled','o','MarkerFaceAlpha',6/8)
load('SVPWM1.mat')
hold on
scatter3(Wave.Input.C_ad/Cb,(Wave.Input.Lc_ad+Wave.Input.Lg_ad)/Lb,Wave.Input.Ripple_ad,100,...
    Wave.Input.LCL_ad(1,:),'filled','p','MarkerFaceAlpha',6/8)
legend('DPWM','SVPWM')
xlabel('Capacitance [p.u.]')
ylabel('Total inductance [p.u]')
zlabel('Ripple [%]')
grid on
% colormap(turbo_colormap_data)
colormap(pmkmp(256,'CubicL'))
h = colorbar;
set(get(h,'label'),'string','k_{res}');
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
set(gca, 'FontName', 'cmr10')