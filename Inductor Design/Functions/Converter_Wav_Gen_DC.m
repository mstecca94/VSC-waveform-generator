function [ Converter ] = Converter_Wav_Gen_DC( Converter )
% This is the Main Function for Component Current Waveform Generation 
% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013 
f_sup = Converter.Spec.f_sup ;         %[Hz] : Grid Frequency
fsw_val  = Converter.Spec.fsw_val;     %[Hz] : Switching Frequency
PHI = Converter.Spec.PHI;
M = Converter.Spec.M ;                %[ ]  : Modulation Index

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     Pre-Calculations/Running Paramenters/Variable Initialization
D_Time = 1.0E-6;                      %[sec]: Resoultion of Graphs/Vectors
Converter.Wav.D_Time= D_Time;
%Correction factor for resolution vs switchign frequency
fsw_val = 1/(D_Time*round(1/fsw_val/D_Time));
%Correction factor for CM Voltage (issue with 2pi/3 not being integer number of 1/fs)
Converter.Spec.f_sup = fsw_val/3/round(fsw_val/3/f_sup);
Converter.Wav.Vec_p = round(1/Converter.Spec.f_sup/D_Time); %[ ]  : Number of lines in Vector

Ip = Converter.Spec.Ig*sqrt(2) ;     % [A] Peak Current

%% Create waveforms necessary for inductor design

for k=1:Converter.Wav.Vec_p 
    % Grid Period Time Definition
    Time(k)=(k-1)*D_Time;
    Converter.Wav.Time(k)= Time(k);
    thetaA(k) = atan2(sin(Time(k)*2*pi*f_sup),sin(Time(k)*2*pi*f_sup+pi/2));

end

I_DC = 3/4*Ip*M*cos(PHI) ;

for m=1:Converter.Wav.Vec_p

    Ix = abs( I_DC );

    IgA(m) = I_DC ;

    Lf= Converter.Spec.L1_val*pchip(Converter.Spec.L1_Ivar,Converter.Spec.L1_Vvar,Ix);

    B_fluxA(m) = Lf*( IgA(m) ); %Later need to be divided by (N*Ae)

    ia_rip_real(m) = 0 ;

    abs_r(m) = 0 ;

end
            
iLA = ia_rip_real + IgA;

%% 
Converter.Wav.thetaA= thetaA ;

Converter.Wav.IgA = IgA ;

Converter.Wav.D_iLpha = abs_r ;

Converter.Wav.B_fluxA = B_fluxA ;

Converter.Wav.iLA = iLA ;

end

