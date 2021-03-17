function [ Wave , DC_Design ] = current_with_ripple_DC ( Wave , DC_Design )
%% initialize parameters
Wire = Wave.Input.Wire ;
phi_DC = DC_Design.phi ;
v_a_fft = DC_Design.v_a_fft ;
v_b_fft = DC_Design.v_b_fft ;
v_c_fft = DC_Design.v_c_fft ;

I = DC_Design.I*sqrt(2) ;
L = size( Wave.Input.t,2);             % Length of signal

fg = Wave.Input.fg ;
f = Wave.FFT.f ;

C = Wave.Input.C ;
Lc = Wave.Input.Lc ;
Lg = Wave.Input.Lg ;

wres = sqrt((Lc+Lg)/(Lg*Lc*C));
wlc=sqrt(1/(Lc*C));

control_bandwidth = max([wlc,wres])*1.3/2/pi; % assume active damping cancels h before resonance
[~,min_f] = min(abs(f-control_bandwidth));
[~,fund_f] = min(abs(f-fg));

%% transfer functions
s = 1i*2*pi*f;
Y11 = (s.^2 + wlc^2) ./ (Lc.*s.*(s.^2 + wres^2)) ;
%% Compute currents 
i1 = v_a_fft .* Y11 ;
i1(1:min_f) = 0 ;
i1(fund_f) = I*exp(1i*(phi_DC-pi/2)) ;
i1_wave = ifft(i1,L,2,'symmetric')*L/2; 

%% 3 or 4 (3+VG) system 
% basically remove zero sequence component in 3 wire systems
if Wire == 3
    i1b = v_b_fft .* Y11 ;
    i1c = v_c_fft .* Y11 ;

    i1b(1:min_f) = 0 ;
    i1c(1:min_f) = 0 ;

    i1b(fund_f) = I*exp(1i*(phi_DC-pi/2-2*pi/3)) ;
    i1c(fund_f) = I*exp(1i*(phi_DC-pi/2+2*pi/3))  ;

    i1b_wave = ifft(i1b,L,2,'symmetric')*L/2; 
    i1c_wave = ifft(i1c,L,2,'symmetric')*L/2; 

    % abc -> alfa beta 0 transformation
    i1_alfa = (2/3)*(i1_wave -1/2*i1b_wave -1/2*i1c_wave) ;    
    i1_wave = i1_alfa ;
end


%% save data
DC_Design.i_converter_side = i1_wave; 

%% reprocess current
[ Wave , DC_Design ] = current_post_LCL_DC ( Wave , DC_Design ) ;

end