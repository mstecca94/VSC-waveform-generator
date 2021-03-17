function [ Wave , WaveR1 , WaveR2 ] = performance_routine_LCL ( Wave )
%% parameters sweep
Pmax = Wave.Input.Pmax ;
P_range = Pmax*0.1:Pmax*0.1:Pmax ;
phi_range = Wave.Input.phimin:pi/12:Wave.Input.phimax ;
kres_sel = Wave.Input.kres_sel ;
routine_designs = Wave.Input.routine_designs ;
%% define standard designs to consider
% standard designs for ripple routine / here i can have multiple rows with
% same kres / depends on the sfty coeff range
sd_idx = find(Wave.Input.kres_ad_surf(1,:)==kres_sel);
Wave.Input.Lc_asd = Wave.Input.Lc_ad_surf(:,sd_idx) ;
Wave.Input.Lg_asd = Wave.Input.Lg_ad_surf(:,sd_idx) ;
Wave.Input.C_asd = Wave.Input.C_ad_surf(:,sd_idx) ;
Wave.Input.Ripple_asd = Wave.Input.Ripple_ad_surf(:,sd_idx) ;

Wave.Input.Ripple_asd(isnan(Wave.Input.Ripple_asd))=0;
%%
id = 1;
while id <=size(Wave.Input.Ripple_asd,2)
    if sum(Wave.Input.Ripple_asd(:,id))==0
        id = id + 1;
    else
        break
    end 
end
%%
% id = min(find(Wave.Input.Ripple_asd(1,:)>0)) ; % 1st column with feasible results /lowest Ltot
min_r = min(Wave.Input.Ripple_asd(:,id));
max_r = max(Wave.Input.Ripple_asd(:,id));
ripple_sd = linspace(min_r,max_r,routine_designs);

[~,b_wr1]=min(abs(Wave.Input.Ripple_asd(:,id)-ripple_sd)); % design indexes for linear ripple variations

Wave.Input.Lc_sd = Wave.Input.Lc_asd(b_wr1,id) ;
Wave.Input.Lg_sd = Wave.Input.Lg_asd(b_wr1,id) ;
Wave.Input.C_sd = Wave.Input.C_asd(b_wr1,id) ;
Wave.Input.Ripple_sd = Wave.Input.Ripple_asd(b_wr1,id) ;
%% disable all plotting otherwise too much shit
Wave.Input.plot_arm_volt = 0 ;
Wave.FFT.plot_current = 0 ;
Wave.FFT.plotting = 0 ; % 0 no plotting / 1 simplified / 2 full
Wave.Input.plot_switching_energy = 0 ; % to plot interpolated switching energies
Wave.Input.plot_transition = 0 ; % to plot turn on / off transitions
Wave.Input.Plot_Filter_design = 0 ; % to plot the AC Filter design  
Wave.Input.plot_filter_compliance = 0 ; % to plot IEEE compliance 
Wave.Input.DClinkCurrentPlotting = 0 ; % to plot DC link currents
Wave.Input.plot_ESR_vs_f = 0 ; % to plot ESR vs f interpolation
Wave.Input.DClinkDesignPlotting = 0 ; % to plot DC link designs 
Wave.Input.Plot_DC_link_Current = 0 ; % to plot the DC link current for phi / M
Wave.Input.plot_InductorDesign = 0 ; % 1 to plot  the possible inducto designs
Wave.Input.AC_cap_plotting = 0 ; % 1 to plot the AC capacitor designs
Wave.Input.plot_AC_cost_interpolation = 0 ; % to plot the cost interpolation for AC Cap 
%% routine 1 - filter / output power P
z=1;
for y = 1:size(Wave.Input.Lc_sd,1)
    Wave.Input.C = Wave.Input.C_sd(y) ; 
    Wave.Input.Lc = Wave.Input.Lc_sd(y) ;
    Wave.Input.Lg = Wave.Input.Lg_sd(y) ;
    Ripple(y) = Wave.Input.Ripple_sd(y) ;
    for x = 1:size(P_range,2)
        Wave.Input.P = P_range(x) ;% 100kW
        Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
        % generate voltage
        [ Wave ] = arm_voltage ( Wave ) ;
        % fft of the voltage
        [ Wave ] = volt_fft ( Wave ) ;
        % define AC ripple in the current
        [ Wave ] = current_with_ripple ( Wave ) ;
        % process current / find mean , rms and I on off and reverse recovery 
        [ Wave ] = current_processing ( Wave ) ;
        % calculate semiconductor losses
        [ Wave ] = semiconductor_losses ( Wave ) ;
        % semiconductor
        WaveR1.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        WaveR1.Semiconductor.Losses_C(x,y,z) = Wave.Losses.Ps_tot ;
        WaveR1.Semiconductor.Losses_S(x,y,z) = Wave.Losses.Pc_tot ;
        WaveR1.Semiconductor.Efficiency(x,y,z) = Wave.Losses.Efficiency ;
        WaveR1.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
%         x
    end
    y
end
%% routine 2 - filter / power factor
z=1;
Wave.Input.P = Pmax ;% 100kW
Wave.Input.I = Wave.Input.P/(sqrt(3)*Wave.Input.vll) ;
for y = 1:size(Wave.Input.Lc_sd,1)
    Wave.Input.C = Wave.Input.C_sd(y) ; 
    Wave.Input.Lc = Wave.Input.Lc_sd(y) ;
    Wave.Input.Lg = Wave.Input.Lg_sd(y) ;
    Ripple(y) = Wave.Input.Ripple_sd(y) ;
    for x = 1:size(phi_range,2)
    Wave.Input.phi = phi_range(x) ;
        % generate voltage
        [ Wave ] = arm_voltage ( Wave ) ;
        % fft of the voltage
        [ Wave ] = volt_fft ( Wave ) ;
        % define AC ripple in the current
        [ Wave ] = current_with_ripple ( Wave ) ;
        % process current / find mean , rms and I on off and reverse recovery 
        [ Wave ] = current_processing ( Wave ) ;
        % calculate semiconductor losses
        [ Wave ] = semiconductor_losses ( Wave ) ;
        % semiconductor
        WaveR2.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
        WaveR2.Semiconductor.Losses_C(x,y,z) = Wave.Losses.Ps_tot ;
        WaveR2.Semiconductor.Losses_S(x,y,z) = Wave.Losses.Pc_tot ;
        WaveR2.Semiconductor.Efficiency(x,y,z) = Wave.Losses.Efficiency ;
        WaveR2.Semiconductor.Losses(x,y,z) = Wave.Losses.Ptot ;
%         x
    end
    y
end
%% plotting

[X1,Y1]=meshgrid((Wave.Input.Pmax*0.2:Wave.Input.Pmax*0.1:Wave.Input.Pmax)/Wave.Input.Pmax,...
    Wave.Input.Ripple_sd);
[X2,Y2]=meshgrid(Wave.Input.phimin:pi/12:Wave.Input.phimax, Wave.Input.Ripple_sd);

[~,b_wr1]=max(WaveR1.Semiconductor.Efficiency(2:end,:),[],2) ;
y=1;
for x=2:size(Wave.Input.Pmax*0.2:Wave.Input.Pmax*0.1:Wave.Input.Pmax,2)+1
    bst_wr1(y) = WaveR1.Semiconductor.Efficiency(x,b_wr1(y)) ;
    x_wr1(y) = (Wave.Input.Pmax*0.1*x)/Wave.Input.Pmax ; 
    y_wr1(y) = Wave.Input.Ripple_sd(b_wr1(y),:) ; 
    y=y+1;
end

[~,b_wr2]=max(WaveR2.Semiconductor.Efficiency,[],2) ;
y=1;
for x=1:size(Wave.Input.phimin:pi/12:Wave.Input.phimax,2)
    bst_wr2(y) = WaveR2.Semiconductor.Efficiency(x,b_wr2(y)) ;
    x_wr2(y) = Wave.Input.phimin +pi/12*(x-1); 
    y_wr2(y) = Wave.Input.Ripple_sd(b_wr2(y),:) ; 
    y=y+1;
end

lw = 1.25 ; 
figure;
subplot(1,2,1)
contourf(X1,Y1,WaveR1.Semiconductor.Efficiency(2:end,:)')
hold on
% plot3(x_wr1,y_wr1,bst_wr1,'-x','LineWidth',lw,'color','k')
box on
grid on
xlabel({'Output Power [p.u.]';'';'(a)'})
ylabel('Ripple [%]')
colormap(pmkmp(256,'CubicL'))
h = colorbar;
set(get(h,'label'),'string','Efficieny [%]');
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
set(gca, 'FontName', 'cmr10')
ylim([min(Wave.Input.Ripple_sd) max(Wave.Input.Ripple_sd)])

subplot(1,2,2)
contourf(X2,Y2,WaveR2.Semiconductor.Efficiency')
hold on
% plot3(x_wr2,y_wr2,bst_wr2,'-x','LineWidth',lw,'color','k')
box on
grid on
xlabel({'Phase shift [rad]';'';'(b)'})
ylabel('Ripple [%]')
colormap(pmkmp(256,'CubicL'))
h = colorbar;
set(get(h,'label'),'string','Efficieny [%]');
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
set(gca, 'FontName', 'cmr10')
ylim([min(Wave.Input.Ripple_sd) max(Wave.Input.Ripple_sd)])

% %%
% lw = 1.25 ;
% 
% figure;
% hold on
% plot(Wave.Input.P_range/Wave.Input.Pmax*100,WaveR.Semiconductor.Efficiency(:,1),'Color','#ff7f0e','LineWidth',lw)
% plot(Wave.Input.P_range/Wave.Input.Pmax*100,WaveR.Semiconductor.Efficiency(:,2),'Color','#1f77b4','LineWidth',lw)
% plot(Wave.Input.P_range/Wave.Input.Pmax*100,WaveR.Semiconductor.Efficiency(:,3),'Color','#2ca02c','LineWidth',lw)
% box on
% grid on
% xlabel('Output Power [%]')
% ylabel('Efficiency [%]')
% ax = gca;
% ax.GridLineStyle = ':';
% ax.GridAlpha = 0.5;
% legend('Ripple = 76%','Ripple = 42%','Ripple = 9%')

end