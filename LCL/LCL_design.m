function [ Wave ] = LCL_design ( Wave ) 
%% load data
vll = Wave.Input.vll ; 
I = Wave.Input.I ;
P = Wave.Input.P ;

fs = Wave.Input.fs ;
fg = Wave.Input.fg ;
qfact =  Wave.Input.qfact ;
kres =  Wave.Input.kres ;
wres = kres*fs*2*pi ;
sftycoeff = Wave.Input.sftycoeff ;
%% define total inductance

[ flag2 ] = total_inductance_definition_LCL ( Wave ) ;
Ltot = flag2*sftycoeff ; 
Lc = 0.1*Ltot:0.005*Ltot:0.9*Ltot;
Lg = 0.9*Ltot:-0.005*Ltot:0.1*Ltot;

C = ( Lc + Lg ) ./ ( Lc .* Lg .* wres^2 ) ;  

Temp.C = C(end) ;
Temp.Lc = Lc(end) ;
Temp.Lg = Lg(end) ;

% [ Wave , Temp ] = current_with_ripple_LCL ( Wave , Temp ) ;
% maxR= max(abs(Temp.i_converter_side-Temp.i_grid_side))/max(Wave.Current.i_50Hz_a)*100 ;
% if maxR > Wave.Input.min_ripple_wanted
    
%% max capacitance due to Q absorption
Cmax=qfact*P/3/((vll/sqrt(3))^2*2*pi*fg) ;                        % max Cap / max Q absorption
Cmin = min(C) ;
it=1;
while Cmin >= Cmax
    if it==2
        disp('Required increase in resonance frequency')
    end
    Wave.Input.kres = Wave.Input.kres +0.025 ;
    [ flag2 ] = total_inductance_definition_LCL ( Wave ) ;
    Ltot = flag2*sftycoeff ; 
    wres = Wave.Input.kres*fs*2*pi ;
    Lc = 0.1*Ltot:0.005*Ltot:0.9*Ltot;
    Lg = 0.9*Ltot:-0.005*Ltot:0.1*Ltot;
    C = ( Lc + Lg ) ./ ( Lc .* Lg .* wres^2 ) ;
    Cmax=qfact*P/3/((vll/sqrt(3))^2*2*pi*fg) ;                        % max Cap / max Q absorption
    Cmin = min(C) ;
    it=it+1;
    if Wave.Input.kres>0.5
        disp('Reached boundary of resonance frequency - do something manually (for now =) )')
        break
    end
end
if it>=3
    fprintf('New resonance frequency factor = %.3f\n',Wave.Input.kres)
end

fprintf('Required Total Inductance = %.3f uH\n',flag2/1e-6) 

[ ~ , b ] = find(C>=Cmax);

% delete too high C designs
Lc(b) = [] ;
Lg(b) = [] ;
C(b) = [] ;
[ ~ , b_Cmin ] = min(C);

%% selected filter design
% i have 3 possible arbitrary selection points

Wave.Input.Lc_ad = Lc ;
Wave.Input.Lg_ad = Lg ;
Wave.Input.C_ad =  C ;

[ Wave ] = ripple_eval ( Wave ) ;

[~,idxxx]=min(abs(Wave.Input.Ripple_ad-(max(Wave.Input.Ripple_ad)+min(Wave.Input.Ripple_ad))/2)); % avg ripple

if Wave.Input.Filter_selection == 0  % highest ripple
    Wave.Input.C = C(1) ;
    Wave.Input.Lc = Lc(1) ;
    Wave.Input.Lg = Lg(1) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(1) ;
    x_pl = 1 ;
elseif Wave.Input.Filter_selection == 1 % min C
    Wave.Input.C = C(b_Cmin) ;
    Wave.Input.Lc = Lc(b_Cmin) ;
    Wave.Input.Lg = Lg(b_Cmin) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(b_Cmin) ;
    x_pl = b_Cmin;
elseif Wave.Input.Filter_selection == 2 % lowest ripple
    Wave.Input.C = C(end) ;
    Wave.Input.Lc = Lc(end) ;
    Wave.Input.Lg = Lg(end) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(end) ;
    x_pl = size(Lg,2);
elseif Wave.Input.Filter_selection == 3 % mid ripple ripple
    Wave.Input.C = C(idxxx) ;
    Wave.Input.Lc = Lc(idxxx) ;
    Wave.Input.Lg = Lg(idxxx) ;
    Wave.Input.Ripple = Wave.Input.Ripple_ad(idxxx) ;
    x_pl = idxxx;
end

Wave.Input.Lc_sd = [ Lc(1) Lc(idxxx) Lc(end) Lc(b_Cmin) ] ;
Wave.Input.Lg_sd = [ Lg(1) Lg(idxxx) Lg(end) Lg(b_Cmin) ] ;
Wave.Input.C_sd = [ C(1) C(idxxx) C(end) C(b_Cmin) ] ;
Wave.Input.Ripple_sd = [ Wave.Input.Ripple_ad(1) Wave.Input.Ripple_ad(idxxx) Wave.Input.Ripple_ad(end) Wave.Input.Ripple_ad(b_Cmin) ] ;

%% plotting  p.u. values
if Wave.Input.Plot_Filter_design == 1

    Lb = (vll/(2*pi*fg*I*sqrt(3)));       % base inductance
    Cb = (I^2*3/(2*pi*fg*P));       % base capacitance   
    Lg_pu = Lg / Lb ;
    Lc_pu = Lc / Lb ;
    C_pu =  C  / Cb ;
    
    lw=1.5;
    
%     f1 = figure;
%     set(f1,'defaultAxesColorOrder',[[0 0 0];[0 0 0]]);
%     title('LCL Filter Designs')
%     hold on
%     plot(Lg*1000,'r','LineWidth',lw)
%     plot(Lc*1000,'g','LineWidth',lw)
%     xlabel('Designs [n]')
%     ylabel('L [mH]')
%     
%     yyaxis right
%     plot(C*10000000,'b','LineWidth',lw)
%     ylabel('C [uF]')
%     xline(x_pl,'k','LineWidth',lw);
% 
%     grid on
%     legend('L_{g}','L_{c}','C','Selected Design')

    f2 = figure;
    set(f2,'defaultAxesColorOrder',[[0 0 0];[0 0 0]]);
    title('LCL Filter Designs')
    hold on
    plot(Lg_pu,'LineWidth',lw,'Color','#d62728')
    plot(Lc_pu,'Color','#2ca02c','LineWidth',lw)
    plot(C_pu,'Color','#1f77b4','LineWidth',lw)
    xlabel('Design [n]')
    ylabel('LCL Parameters [p.u.]')
    
    yyaxis right
    plot(Wave.Input.Ripple_ad,'Color','#ff7f0e','LineWidth',lw)
    ylabel('Peak Ripple [%]')
    xline(x_pl,'k','LineWidth',lw);

    grid on
    legend('L_{g}','L_{c}','C','Ripple','Selected Design')
%     
    figure;
%     title('LCL Filter Designs')
    hold on
    plot(flip(Lg_pu),'LineWidth',lw,'Color','#ff7f0e')
    plot(flip(Lc_pu),'Color','#2ca02c','LineWidth',lw)
    plot(flip(C_pu),'Color','#1f77b4','LineWidth',lw)
    ylabel('LCL Parameters [p.u.]')
    xlabel('Peak Current Ripple [%]')
    xticklabels(round(flip(Wave.Input.Ripple_ad(1:20:end))))
    grid on
    legend('L_{g}','L_{c}','C')
    xlim([1 size(C_pu,2)])
    box on
    ax = gca;
    ax.GridLineStyle = ':';
    ax.GridAlpha = 0.5;
end

%% Plot compliance 
if Wave.Input.plot_filter_compliance == 1 
    filter_compliance ( Wave ) ;
end