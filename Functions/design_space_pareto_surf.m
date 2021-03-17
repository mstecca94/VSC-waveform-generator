function [ ] = design_space_pareto_surf ( Wave ) 
%% Without LVRT
Lc = Wave.Input.Lc_ad_surf ; 
Lg = Wave.Input.Lg_ad_surf ; 
C  = Wave.Input.C_ad_surf ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
Ripple = Wave.Input.Ripple_ad_surf ;
Lt = Lc+Lg ;
[~,b] = max(Lt) ;
LtotMax = 10 ;
i = 1 ;
C(C==0)= NaN;
while size(Lt,2)>1 
    [~,b] = min(C) ; 
    if Lt(b) < LtotMax
        Lt_p(i) = Lt(1,b) ;
        Ripple_p(i) = Ripple(1,b) ;
        C_p(i) = C(1,b) ;
        kres_p(i) = kres(1,b) ;
        sft_p(i) = sftycoeff(1,b) ; 
        LtotMax = min(LtotMax,Lt(b)) ;
        i = i + 1 ;
    end      
    kres(:,b) = [] ;
    sftycoeff(:,b) = [] ;
    Lt(:,b) = [] ;
    C(:,b) = [] ;
    Ripple(:,b) = [] ;
end
Ripple = Wave.Input.Ripple_ad_surf ;
Lt = Lc+Lg ;
C  = Wave.Input.C_ad_surf ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
%%
Lt_p2_surf = [] ;
C_p2_surf = [] ;
Ripple_p2_surf = [] ;
kres_p2_surf = [] ;
for i=1:size(kres_p,2)
    Lt_p2_surf = [Lt_p2_surf Lt(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    C_p2_surf = [C_p2_surf C(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    Ripple_p2_surf = [Ripple_p2_surf Ripple(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    kres_p2_surf = [kres_p2_surf kres(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
end

figure;
scatter3(C_p2_surf,Lt_p2_surf,Ripple_p2_surf,[],'r','filled','o','MarkerFaceAlpha',6/8)
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

end
