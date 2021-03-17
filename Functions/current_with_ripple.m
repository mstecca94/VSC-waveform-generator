function [ Wave ] = current_with_ripple ( Wave )
%% initialize parameters
Wire = Wave.Input.Wire ;
phi = Wave.Input.phi ;
v_a_fft = Wave.FFT.v_a_fft ;
v_b_fft = Wave.FFT.v_b_fft ;
v_c_fft = Wave.FFT.v_c_fft ;

i_50Hz_a = Wave.Current.i_50Hz_a ;
I = Wave.Input.I*sqrt(2) ;
L = size( Wave.Input.t,2);             % Length of signal

t = Wave.Input.t ;
fg = Wave.Input.fg ;
f = Wave.FFT.f ;

C = Wave.Input.C ;
Lc = Wave.Input.Lc ;
Lg = Wave.Input.Lg ;

Rc = Wave.Input.Rc ;
Rg = Wave.Input.Rg ;

wres = sqrt((Lc+Lg)/(Lg*Lc*C));
wlc=sqrt(1/(Lc*C));

control_bandwidth = max([wlc,wres])*1.3/2/pi; % assume active damping cancels h before resonance
[~,min_f] = min(abs(f-control_bandwidth));
[~,fund_f] = min(abs(f-fg));

%% transfer functions
s = 1i*2*pi*f;

Y21 = wres^2 ./ ((Lg+Lc).*s.*(s.^2 + wres^2)) ;
Y11 = (s.^2 + wlc^2) ./ (Lc.*s.*(s.^2 + wres^2)) ;

Z1 = Rc + s*Lc ;
Z2 = Rg + s*Lg ;
ZC = 1 ./ (s*C) ;
Ztot = ( Z2.*ZC+Z1.*Z2+Z1.*ZC ) ./ ( Z2 + ZC ) ;
Zpar = ( Z2.*ZC ) ./ ( Z2 + ZC ) ;

Y21_dmpd = Zpar ./ Z2 ./ ( Ztot )  ;
Y11_dmpd = 1 ./ Ztot ;

%% Compute currents 
i1 = v_a_fft .* Y11 ;
i2 = v_a_fft .* Y21 ;

i1_dmpd = v_a_fft .* Y11_dmpd ;
i2_dmpd = v_a_fft .* Y21_dmpd ;

i1(1:min_f) = 0 ;
i2(1:min_f) = 0 ;
i1_dmpd(1:min_f) = 0 ;
i2_dmpd(1:min_f) = 0 ;

i1(fund_f) = I*exp(1i*(-phi-pi/2)) ;
i2(fund_f) = I*exp(1i*(-phi-pi/2)) ;
i1_dmpd(fund_f) = I*exp(1i*(-phi-pi/2))  ;
i2_dmpd(fund_f) = I*exp(1i*(-phi-pi/2))  ;

i1_wave = ifft(i1,L,2,'symmetric')*L/2; 
i2_wave = ifft(i2,L,2,'symmetric')*L/2; 
i1_wave_dmpd = ifft(i1_dmpd,L,2,'symmetric')*L/2; 
i2_wave_dmpd = ifft(i2_dmpd,L,2,'symmetric')*L/2; 

%% 3 or 4 (3+VG) system 
% basically remove zero sequence component in 3 wire systems
if Wire == 3
    i1_wave_o=i1_wave;    
    i1b = v_b_fft .* Y11 ;
    i1c = v_c_fft .* Y11 ;
    i2b = v_b_fft .* Y21 ;
    i2c = v_c_fft .* Y21 ;

    i1b(1:min_f) = 0 ;
    i2b(1:min_f) = 0 ;
    i1c(1:min_f) = 0 ;
    i2c(1:min_f) = 0 ;

    i1b(fund_f) = I*exp(1i*(-phi-pi/2-2*pi/3)) ;
    i2b(fund_f) = I*exp(1i*(-phi-pi/2-2*pi/3)) ;
    i1c(fund_f) = I*exp(1i*(-phi-pi/2+2*pi/3))  ;
    i2c(fund_f) = I*exp(1i*(-phi-pi/2+2*pi/3))  ;

    i1b_wave = ifft(i1b,L,2,'symmetric')*L/2; 
    i1c_wave = ifft(i1c,L,2,'symmetric')*L/2; 
    i2b_wave = ifft(i2b,L,2,'symmetric')*L/2; 
    i2c_wave = ifft(i2c,L,2,'symmetric')*L/2; 

    % abc -> alfa beta 0 transformation
    i1_alfa = (2/3)*(i1_wave -1/2*i1b_wave -1/2*i1c_wave) ;
    i2_alfa = (2/3)*(i2_wave -1/2*i2b_wave -1/2*i2c_wave) ;
    
    i1_wave = i1_alfa ;
    i2_wave = i2_alfa ;
    
% % % % % %     figure to check the transformation
% % % % %     figure;
% % % % %     hold on
% % % % %     plot(i1_wave)
% % % % %     plot(i1_wave_o)
% % % % %     plot(i1b_wave)
% % % % %     plot(i1c_wave)
end


%% save data
Wave.Current.i_converter_side = i1_wave; 
Wave.Current.i_grid_side = i2_wave;

Wave.Current.i_converter_side_dmpd = i1_wave_dmpd ; 
Wave.Current.i_grid_side_dmpd = i2_wave_dmpd ; 


%% reprocess current
[ Wave ] = current_post_LCL ( Wave ) ;

%% plot
if Wave.FFT.plot_current == 1 
    if Wire == 3
        figure;
        title(sprintf('Non dumped filter currents %s wire system',Wire))
        hold on
        plot(t,i1_wave)
        plot(t,i2_wave)
        plot(t,i_50Hz_a)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Converter side current','Grid Side current','Sinusoidal Current')
    else
        figure;
        subplot(4,1,1)
        sgtitle(sprintf('Filter currents %s wire system',Wire))
        title('Non dumped filter currents')
        hold on
        plot(t,i1_wave)
        plot(t,i2_wave)
        plot(t,i_50Hz_a)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Converter side current','Grid Side current','Sinusoidal Current')

        subplot(4,1,2)
        title('Dumped filter currents')
        hold on
        plot(t,i1_wave_dmpd)
        plot(t,i2_wave_dmpd)
        plot(t,i_50Hz_a)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Converter side current','Grid Side current','Sinusoidal Current')

        subplot(4,1,3)
        title('Converter side current')
        hold on
        plot(t,i1_wave)
        plot(t,i1_wave_dmpd)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Non dumped','Dumped')

        subplot(4,1,4)
        hold on
        title('Grid side current')
        plot(t,i2_wave)
        plot(t,i2_wave_dmpd)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Non dumped','Dumped')
    end
end

end