function [ ] = design_space_pareto ( Wave ) 
%% Without LVRT
Lc = Wave.Input.Lc_ad_nLVRT ; 
Lg = Wave.Input.Lg_ad_nLVRT ; 
C  = Wave.Input.C_ad_nLVRT ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
Ripple = Wave.Input.Ripple_ad_nLVRT ;
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
Ripple = Wave.Input.Ripple_ad_nLVRT ;
Lt = Lc+Lg ;
C  = Wave.Input.C_ad_nLVRT ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
%%
Lt_p2_nLVRT = [] ;
C_p2_nLVRT = [] ;
Ripple_p2_nLVRT = [] ;
kres_p2_nLVRT = [] ;
for i=1:size(kres_p,2)
    Lt_p2_nLVRT = [Lt_p2_nLVRT Lt(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    C_p2_nLVRT = [C_p2_nLVRT C(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    Ripple_p2_nLVRT = [Ripple_p2_nLVRT Ripple(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    kres_p2_nLVRT = [kres_p2_nLVRT kres(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
end
%% With LVRT
Lc = Wave.Input.Lc_ad ; 
Lg = Wave.Input.Lg_ad ; 
C  = Wave.Input.C_ad ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
Ripple = Wave.Input.Ripple_ad ;
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
Ripple = Wave.Input.Ripple_ad ;
Lt = Lc+Lg ;
C  = Wave.Input.C_ad ; 
kres = Wave.Input.kres_ad ; 
sftycoeff = Wave.Input.sftycoeff_ad ;
%%
Lt_p2 = [] ;
C_p2 = [] ;
Ripple_p2 = [] ;
kres_p2 = [] ;
for i=1:size(kres_p,2)
    Lt_p2 = [Lt_p2 Lt(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    C_p2 = [C_p2 C(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    Ripple_p2 = [Ripple_p2 Ripple(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
    kres_p2 = [kres_p2 kres(1,sftycoeff == sft_p(i) & kres == kres_p(i))] ;
end
%% Detect the ones that are excluded by the LVRT
Code = zeros(size(C_p2_nLVRT)) ; 
for p = 1:size(C_p2_nLVRT,2)
    if sum((C_p2_nLVRT(p)==C_p2).*(Lt_p2_nLVRT(p)==Lt_p2).*(Ripple_p2_nLVRT(p)==Ripple_p2))
        Code(p) = 1 ;
    else
        Code(p) = 0 ;
    end 
end
%% Plotting
vll = Wave.Input.vll ; 
P = Wave.Input.P ;
I = Wave.Input.I ;
fg = Wave.Input.fg ;

Lb = (vll/(2*pi*fg*I*sqrt(3)));  % base inductance
Cb = (I^2*3/(2*pi*fg*P));        % base capacitance   

figure;
scatter3(C_p2_nLVRT/Cb,Lt_p2_nLVRT/Lb,Ripple_p2_nLVRT,[],Code,'filled','o','MarkerFaceAlpha',6/8)
hold on
xlabel('Capacitance [p.u.]')
ylabel('Total inductance [p.u]')
zlabel('Ripple [%]')
grid on
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
set(gca, 'FontName', 'cmr10')
title('LCL Filter design space')
legend('Without LVRT','With LVRT')
colormap(pmkmp(2,'CubicL'))

    
%%

figure;
scatter3(C_p2_nLVRT/Cb,Lt_p2_nLVRT/Lb,Ripple_p2_nLVRT,[],'r','filled','o','MarkerFaceAlpha',6/8)
hold on
scatter3(C_p2/Cb,Lt_p2/Lb,Ripple_p2,[],'b','filled','o','MarkerFaceAlpha',6/8)
xlabel('Capacitance [p.u.]')
ylabel('Total inductance [p.u]')
zlabel('Ripple [%]')
grid on
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
set(gca, 'FontName', 'cmr10')
title('LCL Filter design space')
legend('Without LVRT','With LVRT')

end
