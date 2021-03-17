function [ Converter ] = Converter_Wav_Gen( Converter )
% This is the Main Function for Component Current Waveform Generation 
% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013 
Pref_val = Converter.Spec.Pmax;        %[VA] : Apparent Output Power
f_sup = Converter.Spec.f_sup;         %[Hz] : Grid Frequency
fsw_val  = Converter.Spec.fsw_val;     %[Hz] : Switching Frequency
PHI = Converter.Spec.PHI;
V_dc = Converter.Spec.V_dc;            %[V]  : DC link Voltage
M = Converter.Spec.M ;                 %[ ]  : Modulation Index
Ugp = Converter.Spec.Ugp;
topology = Converter.Spec.topology ; 
vdcmin = Converter.Spec.vdcmin ;      %[V]  : DC link Voltage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Pre-Calculations/Running Paramenters/Variable Initialization
D_Time = 1.0E-6;                      %[sec]: Resoultion of Graphs/Vectors
%Correction factor for resolution vs switchign frequency
fsw_val = 1/(D_Time*round(1/fsw_val/D_Time));
%Correction factor for CM Voltage (issue with 2pi/3 not being integer number of 1/fs)
% f_sup = fsw_val/3/round(fsw_val/3/f_sup);
Vec_p = round(1/f_sup/D_Time); %[ ]  : Number of lines in Vector

%% Create waveforms necessary for inductor design
for k=1:Vec_p 
    % Grid Period Time Definition
    Time(k)=(k-1)*D_Time;
    Converter.Wav.Time(k)= Time(k);
    thetaA(k) = atan2(sin(Time(k)*2*pi*f_sup),sin(Time(k)*2*pi*f_sup+pi/2));
    thetaB(k) = atan2(sin(Time(k)*2*pi*f_sup-2/3*pi),sin(Time(k)*2*pi*f_sup+pi/2-2/3*pi));
    thetaC(k) = atan2(sin(Time(k)*2*pi*f_sup+2/3*pi),sin(Time(k)*2*pi*f_sup+pi/2+2/3*pi));
end

IgA = 2*Pref_val/3/Ugp*sin(thetaA + PHI) ;
IgB = 2*Pref_val/3/Ugp*sin(thetaB + PHI) ;
IgC = 2*Pref_val/3/Ugp*sin(thetaC + PHI) ;

switch topology
    case {'2LC'}
        for m=1:Vec_p
            theta_a= thetaA(m);
            theta_b= thetaB(m);
            theta_c= thetaC(m);

            IxA = abs(IgA(m));
            IxB = abs(IgB(m));
            IxC = abs(IgC(m));
            Lf_a = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxA);
            Lf_b = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxB);
            Lf_c = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxC);
            if Converter.IndToBeDesigned == 1 %% Design the Converter side one
                abs_r_a(m) = V_dc/Lf_a/fsw_val*(1/2+M/2.*sin(theta_a)).*(1/2-M/2.*sin(theta_a));
                abs_r_b(m) = V_dc/Lf_b/fsw_val*(1/2+M/2.*sin(theta_b)).*(1/2-M/2.*sin(theta_b));
                abs_r_c(m) = V_dc/Lf_c/fsw_val*(1/2+M/2.*sin(theta_c)).*(1/2-M/2.*sin(theta_c));
                ia_rip_real_4W(m) = abs_r_a(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                ib_rip_real_4W(m) = abs_r_b(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                ic_rip_real_4W(m) = abs_r_c(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                B_fluxA(m) = Lf_a*(ia_rip_real_4W(m) + IgA(m)); %Later need to be divided by (N*Ae)                            
            else %% Design the Grid side one / NO RIPLLE Here
                B_fluxA(m) = Lf_a*( IgA(m) ); %Later need to be divided by (N*Ae)
                ia_rip_real_4W(m) = 0 ;
                ib_rip_real_4W(m) = 0 ;
                ic_rip_real_4W(m) = 0 ;
                abs_r_a(m) = 0 ;                
            end           
        end        
    case {'3L_NPC','3L_TTYPE','INT 2CH 3L_NPC'}
        for m=1:Vec_p
            theta_a= thetaA(m);
            theta_b= thetaB(m);
            theta_c= thetaC(m);

            IxA = abs(IgA(m));
            IxB = abs(IgB(m));
            IxC = abs(IgC(m));
            Lf_a = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxA);
            Lf_b = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxB);
            Lf_c = Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,IxC);
            if Converter.IndToBeDesigned == 1 %% Design the Converter side one
                abs_r_a(m) = M*V_dc/2/Lf_a/fsw_val*(abs(sin(theta_a))-M*(sin(theta_a))^2);
                abs_r_b(m) = M*V_dc/2/Lf_b/fsw_val*(abs(sin(theta_b))-M*(sin(theta_b))^2);
                abs_r_c(m) = M*V_dc/2/Lf_c/fsw_val*(abs(sin(theta_c))-M*(sin(theta_c))^2);
                ia_rip_real_4W(m) = abs_r_a(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                ib_rip_real_4W(m) = abs_r_b(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                ic_rip_real_4W(m) = abs_r_c(m)*0.5.*sawtooth(fsw_val/f_sup.*theta_a+pi/2,1/2);
                B_fluxA(m) = Lf_a*(ia_rip_real_4W(m) + IgA(m)); %Later need to be divided by (N*Ae)          
            else %% Design the Grid side one / NO RIPPLE Here
                B_fluxA(m) = Lf_a*( IgA(m) ); %Later need to be divided by (N*Ae)
                ia_rip_real_4W(m) = 0 ;
                ib_rip_real_4W(m) = 0 ;
                ic_rip_real_4W(m) = 0 ;
                abs_r_a(m) = 0 ;
            end            
        end
end
iLA_4W = ia_rip_real_4W + IgA;
iLB_4W = ib_rip_real_4W + IgB;
iLC_4W = ic_rip_real_4W + IgC;

% figure;
% hold on
% plot(iLA_4W)
% plot(iLB_4W)
% plot(iLC_4W)
% 
% figure;
% hold on
% plot(ia_rip_real_4W)
% plot(ib_rip_real_4W)
% plot(ic_rip_real_4W)

%%
% for a 3 wire system i need to remove the zero sequence component // only
% for the grid side inductance
if Converter.Spec.WireNumber == 3 && Converter.IndToBeDesigned == 1 
    alfa = sqrt(2/3) * ( iLA_4W -1/2*iLB_4W -1/2*iLC_4W ) ;
    beta = sqrt(2/3) * ( sqrt(3)/2*iLB_4W - sqrt(3)/2*iLC_4W ) ;
    zero = sqrt(2/3) * ( 1/sqrt(2)*iLA_4W +1/sqrt(2)*iLB_4W +1/sqrt(2)*iLC_4W ) ;
    figure;
    hold on
    plot(alfa)
    plot(beta)
    plot(zero)
    iLA_3W =  sqrt(2/3) * alfa  ;
%     iLA_3W =  iLA_4W - ( iLA_4W + iLB_4W + iLC_4W )/3  ;
    ir_pu_3W = (iLA_3W - IgA)/ max(iLA_3W - IgA ) ;
    switch topology
        case {'2LC'}
            % real ripple 
            Iripple_real_max=round(230/(2*sqrt(6)*fsw_val*Converter.Spec.L1_val),8);
        case {'3L_NPC','3L_TTYPE','INT 2CH 3L_NPC'}
            Iripple_real_max=round(vdcmin/(6*fsw_val*sqrt(2)*Converter.Spec.L1_val),8); % min converter inductance / 3LC
    end
    iLA = IgA + ir_pu_3W*Iripple_real_max ;   
    B_fluxA = Lf_a*iLA; %Later need to be divided by (N*Ae)
else  % 4 wire system - or LF inductor
        iLA = iLA_4W ;
end
figure;
hold on
plot(iLA_4W)
plot(iLA)
%%

envelope_up=movmax(iLA,1/fsw_val/D_Time);
envelope_up2=[ 1:1/fsw_val/D_Time:Vec_p ; envelope_up(1:1/fsw_val/D_Time:Vec_p)];
envelope_up3=pchip(envelope_up2(1,:),envelope_up2(2,:),1:Vec_p);
% envelope_up3(find(envelope_up3<0))=0;

envelope_down=movmin(iLA,1/fsw_val/D_Time);
envelope_down2=[ 1:1/fsw_val/D_Time:Vec_p ; envelope_down(1:1/fsw_val/D_Time:Vec_p)];
envelope_down3=pchip(envelope_down2(1,:),envelope_down2(2,:),1:Vec_p);
% envelope_down3(find(envelope_down3<0))=0;

figure;
hold on
plot(iLA)
plot(envelope_up3)
plot(envelope_down3)

%%
Converter.Wav.thetaA= thetaA ;
Converter.Wav.envelope_up = envelope_up3 ;
Converter.Wav.envelope_down = envelope_down3 ;
Converter.Wav.IgA = IgA ;
% Converter.Wav.D_iLpha = abs_r_a ;
Converter.Wav.D_iLpha = iLA - IgA ; % i put this and not the envelop to solve the 3/4 wire issue
Converter.Wav.B_fluxA = B_fluxA ;
Converter.Wav.iLA = iLA ;

end

