function [ Wave ] = DC_link_design2 ( Wave )
%% Load data
load('cap_costs.mat')
P=Wave.Input.P;
vdc=Wave.Input.vdc;
fs=Wave.Input.fs;
Vdcmin=Wave.Input.Vdcmin;
Vdcmax=Wave.Input.Vdcmax;
grid_v_variation = Wave.Input.grid_v_variation ;
vll=Wave.Input.vll;
vph=vll/sqrt(3);

deltaP = P; % max load step
Tr = 1/fs*10 ; % 5 modulation periods
Vacmax = vph*(1+grid_v_variation)*sqrt(2) ; % +10 % voltage variation
Vacmin = vph*(1-grid_v_variation)*sqrt(2) ; % -10 % voltage variation
% define max ripple allowed
deltaVdc = Vdcmin -2*Vacmax;
Mmax = 2*Vacmax/(Vdcmin-deltaVdc/2); % max mod index
Mmin=2*Vacmin/Vdcmax; % min mod index
I_pk_max = P/(sqrt(3)*vll*(1-grid_v_variation))*sqrt(2) ; % max I ac peak

%% Design Capacitor

Cdcmin_e = deltaP*Tr/(2*Vdcmin*deltaVdc) ;
Cdcmin_r_bl = 3*Mmax*I_pk_max*(1+Mmax) / (fs*8*deltaVdc) ; 

% cdc value to guarantee 
Cdc=max([Cdcmin_e Cdcmin_r_bl])*1000000; % in uF

% capacitor current
M_trend = Mmin:0.001:Mmax;
x=1 ;
I_cap_max_trend=[];
for cosphi = 0:0.2:1 
    I_cap_max_trend(x,:) = I_pk_max .* sqrt(M_trend.* ( sqrt(3)/(4*pi) +...
        cosphi*( sqrt(3)/pi - 9/16.*M_trend))) ; 
    x = x + 1 ; 
end
I_cap_max = max(I_cap_max_trend,[],'all') ;
I_c =I_cap_max*ones(60*60,1);

%%
cap = Wave.DClink.CapacitorsDatasheet;

% current rating vector / to derate the current flowing through the caps
i_mod = transpose(0.5:0.05:1.5) ;
% i_mod=1;
cap2=[];
% create new database changing current ratings
for x=1:size(i_mod,1)
    capx = cap ;
    capx(:,5) = capx(:,5) *i_mod(x) ; 
    cap2 = [cap2 ; capx] ;   
end
cap=cap2;
% multiply for 0.4 to have ESR at around 10 kHz
cap(:,6)=cap(:,6)*0.4; 
cap(:,5)=cap(:,5)/0.4; 
% number of parallel strings to stand the currents
cap(:,end+1)=round(I_cap_max./cap(:,5));
% total capacitance
cap(:,end+1)=cap(:,1).*cap(:,end)/2;
% check if capacitance is enough 
not_enough_c = find(cap(:,end)<Cdc);
% remove not enough capacitance solutions
if isempty(not_enough_c)~=1
    cap(not_enough_c,:)=[];
end

%%
Tamb = 50 ;
% voltage derating factor
Mv=4.3-3.3*vdc/2/500;
% technology dependent parameters
Lb=7500*60*60;
Tm=98;
% ESR*Zth*(Ic/nstring)^2 - temperature rise
for xx=1:size(cap,1)
    D_T_cap(1,:) = transpose(cap(xx,6).*cap(xx,7)./1000.*((I_c./cap(xx,8)).^2));
    % hot spot temperature
    T_cap = 1.5*D_T_cap + Tamb ;
    % lifetime estimation for the given profile
    Lifetime_cap = Mv*Lb*2.^((Tm-T_cap)/10);
    % consumed lifetime in a year
    CL(xx,1)=sum(1./Lifetime_cap,2);
    maxT(xx,1)=max(T_cap);
    [~,cost_idx] = min(abs(cap_costs(1,:)-cap(xx,1))) ;
    pu_cost(xx,1) = cap_costs(2,cost_idx);
end
%%
% check if temperature is too high
too_high_T = find(maxT>95);
% remove not enough capacitance solutions
if isempty(too_high_T)~=1
    cap(too_high_T,:)=[];
    pu_cost(too_high_T,:)=[];
    CL(too_high_T,:)=[];
    maxT(too_high_T,:)=[];
end
% expected lifetime 
L_C = 1./CL ; 
% capacitor efficiency
Weight = cap(:,8)*2.*cap(:,4)/1000 ; % in kg
Volume = cap(:,8)*2.*(cap(:,2)/1000).^2.*cap(:,3)/1000 ; % in m3
Cost = cap(:,8).*2.*pu_cost/1000; % in euro
cap(:,end+1) = Weight ;
cap(:,end+1) = Volume ;
cap(:,end+1) = Cost ;
cap(:,end+1) = L_C ;
% find minimum value designs
[~,min_vol_idx] = min(Volume) ;
[~,min_cost_idx] = min(Cost) ;
[~,max_life_idx] = max(L_C) ;
% save selected design
cap_design_mc = cap(min_cost_idx,:);
cap_design_mv = cap(min_vol_idx,:);
cap_design_Ml = cap(max_life_idx,:);

Wave.DClink.cap_design_mc = cap_design_mc ;
Wave.DClink.cap_design_mv = cap_design_mv ;
Wave.DClink.cap_design_Ml = cap_design_Ml ;
Wave.DClink.Design_guide = {'C[uF]','d[mm]','l[mm]','Weight [g]','Iac,max [A]','ESRmax [mohm]',...
    'Z_th [C/W]','N parallel [n]','Tot cap [uF]','Weight [kg]','Volume [m3]','Cost [keuro]','Lifetime [h]'} ;
%%

if Wave.Input.DClinkDesignPlotting == 1 
    
    figure;
    hold on
    for x = 1:size(I_cap_max_trend,1)   
        plot(M_trend,I_cap_max_trend(x,:))
    end
    
    figure;
    hold on
    scatter(Cost,Volume,[],L_C/1000,'filled','MarkerEdgeColor',[0 0 0])
    scatter(Cost(min_vol_idx),Volume(min_vol_idx),250,L_C(min_vol_idx)/1000,'filled','d'...
        ,'filled','MarkerEdgeColor',[0 0 0])
    scatter(Cost(min_cost_idx),Volume(min_cost_idx),300,L_C(min_cost_idx)/1000,'filled','p'...
        ,'filled','MarkerEdgeColor',[0 0 0])
    scatter(Cost(max_life_idx),Volume(max_life_idx),250,L_C(max_life_idx)/1000,'filled','^'...
        ,'filled','MarkerEdgeColor',[0 0 0])
    c = colorbar;
    c.Label.String = 'Lifetime [k hours]';
    colormap(jet)
    grid on
    xlabel('Cost [k euro]')
    ylabel('Volume [m^3]')

end

end

