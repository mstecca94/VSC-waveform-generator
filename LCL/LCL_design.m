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

%% define total inductance

[ flag2 ] = total_inductance_definition_LCL ( Wave ) ;

Lc = 0.1*flag2:0.005*flag2:0.9*flag2;
Lg = 0.9*flag2:-0.005*flag2:0.1*flag2;
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
    wres = Wave.Input.kres*fs*2*pi ;
    Lc = 0.1*flag2:0.005*flag2:0.9*flag2;
    Lg = 0.9*flag2:-0.005*flag2:0.1*flag2;
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
if Wave.Input.Filter_selection == 0  % highest ripple
    Wave.Input.C = C(1) ;
    Wave.Input.Lc = Lc(1) ;
    Wave.Input.Lg = Lg(1) ;
    x_pl = 1 ;
elseif Wave.Input.Filter_selection == 1 % min C
    Wave.Input.C = C(b_Cmin) ;
    Wave.Input.Lc = Lc(b_Cmin) ;
    Wave.Input.Lg = Lg(b_Cmin) ;
    x_pl = b_Cmin;
elseif Wave.Input.Filter_selection == 2 % lowest ripple
    Wave.Input.C = C(end) ;
    Wave.Input.Lc = Lc(end) ;
    Wave.Input.Lg = Lg(end) ;
    x_pl = size(Lg,2);
end

%% plotting  p.u. values
if Wave.Input.Plot_Filter_design == 1
    Lb = (vll/(2*pi*fg*I*sqrt(3)));       % base inductance
    Cb = (I^2*3/(2*pi*fg*P));       % base capacitance

    Lg_pu = Lg / Lb ;
    Lc_pu = Lc / Lb ;
    C_pu = C / Cb ;

    lw=1.5;
    figure;
    title('LCL Filter Designs')
    hold on
    plot(Lg_pu,'r','LineWidth',lw)
    plot(Lc_pu,'g','LineWidth',lw)
    plot(C_pu,'b','LineWidth',lw)
    xline(x_pl,'k','LineWidth',lw);
    xlabel('Designs [n]')
    ylabel('L-C [p.u.]')
    grid on
    legend('L_{g}','L_{c}','C','Selected Design')
end