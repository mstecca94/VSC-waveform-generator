function [ Wave ] = LCL_design_space ( Wave )
vll = Wave.Input.vll ; 
P = Wave.Input.P ;
I = Wave.Input.I ;
fg = Wave.Input.fg ;
kres_range = Wave.Input.kres_range ;
sftycoeff_range = Wave.Input.sftycoeff_range ;
%%
Wave.Input.LCL_ad = [];
Wave.Input.Lc_ad = [];
Wave.Input.Lg_ad = [];
Wave.Input.C_ad = [];
Wave.Input.kres_ad = [];
Wave.Input.sftycoeff_ad = [];
for sftycoeff = sftycoeff_range
    Wave.Input.sftycoeff = sftycoeff ;
    for kres = kres_range
%         Wave.Input.kres = kres ;
        [ Temp ] = LCL_design2 ( Wave , kres , sftycoeff ); 
        Wave.Input.LCL_ad = [Wave.Input.LCL_ad Temp' ] ;
        Wave.Input.Lc_ad = [Wave.Input.Lc_ad Temp(:,2)' ]; 
        Wave.Input.Lg_ad = [Wave.Input.Lg_ad Temp(:,3)' ]; 
        Wave.Input.C_ad = [Wave.Input.C_ad Temp(:,4)' ]; 
        Wave.Input.kres_ad = [Wave.Input.kres_ad ones(1,size(Temp(:,4),1))*kres ]; 
        Wave.Input.sftycoeff_ad = [Wave.Input.sftycoeff_ad...
            ones(1,size(Temp(:,4),1))*sftycoeff ]; 
        lgt = size(Temp',2);
    end
end
%%
[ Wave ] = ripple_eval ( Wave ) ;
Wave.Input.LCL_ad(5,:) = Wave.Input.Ripple_ad ;
Wave.Input.LCL_ad_nLVRT = Wave.Input.LCL_ad ;
Wave.Input.Lc_ad_nLVRT = Wave.Input.Lc_ad ; 
Wave.Input.Lg_ad_nLVRT = Wave.Input.Lg_ad ; 
Wave.Input.C_ad_nLVRT = Wave.Input.C_ad ; 
Wave.Input.Ripple_ad_nLVRT = Wave.Input.Ripple_ad ; 
% remove designs not respecting the LVRT
[ Wave ] = LVRT ( Wave ) ;
% variables for surf plotting
Wave.Input.kres_ad_surf = reshape(Wave.Input.LCL_ad(1,:),lgt,[]);
Wave.Input.Ripple_ad_surf = reshape(Wave.Input.LCL_ad(5,:),lgt,[]);
Wave.Input.Lc_ad_surf = reshape(Wave.Input.Lc_ad,lgt,[]);
Wave.Input.Lg_ad_surf = reshape(Wave.Input.Lg_ad,lgt,[]);
Wave.Input.C_ad_surf = reshape(Wave.Input.C_ad,lgt,[]);



%%
[ ~ , x_pl_max ] = max(Wave.Input.Ripple_ad);
Ccc = Wave.Input.C_ad ;
Ccc(Ccc == 0 ) = NaN ;
[ ~ , x_pl_mC ] = min(Ccc); % min non zero value
[ ~ , x_pl_min ] = min(Wave.Input.Ripple_ad);
[ ~ , x_pl_avgR ] = min(abs(Wave.Input.Ripple_ad-(max(Wave.Input.Ripple_ad)+...
    min(Wave.Input.Ripple_ad))/2)); % avg ripple

if Wave.Input.Filter_selection == 0  % highest ripple
    Wave.Input.C = Wave.Input.C_ad(x_pl_max) ;
    Wave.Input.Lc = Wave.Input.Lc_ad(x_pl_max) ;
    Wave.Input.Lg = Wave.Input.Lg_ad(x_pl_max) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(x_pl_max) ;
    Wave.Input.kres = Wave.Input.kres_ad(x_pl_max) ;
    Wave.Input.sftycoeff = Wave.Input.sftycoeff_ad(x_pl_max) ;
    x_pl = x_pl_max ;
elseif Wave.Input.Filter_selection == 1 % min C
    Wave.Input.C = Wave.Input.C_ad(x_pl_mC) ;
    Wave.Input.Lc = Wave.Input.Lc_ad(x_pl_mC) ;
    Wave.Input.Lg = Wave.Input.Lg_ad(x_pl_mC) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(x_pl_mC) ;
    Wave.Input.kres = Wave.Input.kres_ad(x_pl_mC) ;
    Wave.Input.sftycoeff = Wave.Input.sftycoeff_ad(x_pl_mC) ;
    x_pl = x_pl_mC ;
elseif Wave.Input.Filter_selection == 2 % lowest ripple
    Wave.Input.C = Wave.Input.C_ad(x_pl_min) ;
    Wave.Input.Lc = Wave.Input.Lc_ad(x_pl_min) ;
    Wave.Input.Lg = Wave.Input.Lg_ad(x_pl_min) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(x_pl_min) ;
    Wave.Input.kres = Wave.Input.kres_ad(x_pl_min) ;
    Wave.Input.sftycoeff = Wave.Input.sftycoeff_ad(x_pl_min) ;
    x_pl = x_pl_min ;
elseif Wave.Input.Filter_selection == 3 % mid ripple ripple
    Wave.Input.C = Wave.Input.C_ad(x_pl_avgR) ;
    Wave.Input.Lc = Wave.Input.Lc_ad(x_pl_avgR) ;
    Wave.Input.Lg = Wave.Input.Lg_ad(x_pl_avgR) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(x_pl_avgR) ;
    Wave.Input.kres = Wave.Input.kres_ad(x_pl_avgR) ;
    Wave.Input.sftycoeff = Wave.Input.sftycoeff_ad(x_pl_avgR) ;
    x_pl = x_pl_avgR ;
end

Wave.Input.Lc_pd = [ Wave.Input.Lc_ad(x_pl_max) Wave.Input.Lc_ad(x_pl_mC) ...
    Wave.Input.Lc_ad(x_pl_min) Wave.Input.Lc_ad(x_pl_avgR) ] ;
Wave.Input.Lg_pd = [ Wave.Input.Lg_ad(x_pl_max) Wave.Input.Lg_ad(x_pl_mC) ...
    Wave.Input.Lg_ad(x_pl_min) Wave.Input.Lg_ad(x_pl_avgR) ] ;
Wave.Input.C_pd = [ Wave.Input.C_ad(x_pl_max) Wave.Input.C_ad(x_pl_mC) ...
    Wave.Input.C_ad(x_pl_min) Wave.Input.C_ad(x_pl_avgR) ] ;
Wave.Input.Ripple_pd = [ Wave.Input.Ripple_ad(x_pl_max) Wave.Input.Ripple_ad(x_pl_mC)...
    Wave.Input.Ripple_ad(x_pl_min) Wave.Input.Ripple_ad(x_pl_avgR) ] ;


%% plotting  p.u. values
if Wave.Input.Plot_Filter_design == 1%%
    Lb = (vll/(2*pi*fg*I*sqrt(3)));  % base inductance
    Cb = (I^2*3/(2*pi*fg*P));        % base capacitance   
    figure;
    
    subplot(1,2,1)
    scatter3(Wave.Input.C_ad/Cb,(Wave.Input.Lc_ad+Wave.Input.Lg_ad)/Lb,Wave.Input.Ripple_ad,...
        [],Wave.Input.LCL_ad(1,:),'filled','o','MarkerFaceAlpha',6/8)
    hold on
    scatter3(Wave.Input.C/Cb,(Wave.Input.Lc+Wave.Input.Lg)/Lb,Wave.Input.Ripple,[],...
        Wave.Input.LCL_ad(1,x_pl),'MarkerEdgeColor',[0 0 0])
    xlabel('Capacitance [p.u.]')
    ylabel('Total inductance [p.u]')
    zlabel('Ripple [%]')
    grid on
    colormap(pmkmp(256,'CubicL'))
    h = colorbar;
    set(get(h,'label'),'string','k_{res}');
    box on
    ax = gca;
    ax.GridLineStyle = ':';
    ax.GridAlpha = 0.5;
    set(gca, 'FontName', 'cmr10')
    title('LCL Filter design space')
    
    subplot(1,2,2)
    scatter3(Wave.Input.C_ad_nLVRT/Cb,(Wave.Input.Lc_ad_nLVRT+Wave.Input.Lg_ad_nLVRT)/Lb,...
        Wave.Input.Ripple_ad_nLVRT,...
    [],Wave.Input.LCL_ad_nLVRT(1,:),'filled','o','MarkerFaceAlpha',6/8)
    hold on
    xlabel('Capacitance [p.u.]')
    ylabel('Total inductance [p.u]')
    zlabel('Ripple [%]')
    grid on
    colormap(pmkmp(256,'CubicL'))
    h = colorbar;
    set(get(h,'label'),'string','k_{res}');
    box on
    ax = gca;
    ax.GridLineStyle = ':';
    ax.GridAlpha = 0.5;
    set(gca, 'FontName', 'cmr10')
    title('LCL Filter design space')

%     figure;
%     surf(Wave.Input.C_ad_surf/Cb,(Wave.Input.Lc_ad_surf+Wave.Input.Lg_ad_surf)/Lb,...
%         Wave.Input.Ripple_ad_surf,Wave.Input.kres_ad_surf,'EdgeColor','interp','FaceColor','interp')
%     xlabel('Capacitance [p.u.]')
%     ylabel('Total inductance [p.u]')
%     zlabel('Ripple [%]')
%     grid on
%     colormap(pmkmp(256,'CubicL'))
%     h = colorbar;
%     set(get(h,'label'),'string','k_{res}');
%     box on
%     ax = gca;
%     ax.GridLineStyle = ':';
%     ax.GridAlpha = 0.5;
%     set(gca, 'FontName', 'cmr10')
%     title('LCL Filter design space')
end
%% Plot compliance 
if Wave.Input.plot_filter_compliance == 1 
    filter_compliance ( Wave ) ;
end
end