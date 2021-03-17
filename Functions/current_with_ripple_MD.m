function [ Wave ] = current_with_ripple_MD ( Wave )
%% initialize parameters
Wire = Wave.Input.Wire ;
phi = Wave.Input.phi ;
fg = Wave.Input.fg ;
v_a_fft = Wave.FFT.v_a_fft ;
v_b_fft = Wave.FFT.v_b_fft ;
v_c_fft = Wave.FFT.v_c_fft ;

i_50Hz_a = Wave.Current.i_50Hz_a ;
I = Wave.Input.I*sqrt(2) ;
L = size( Wave.Input.t,2);             % Length of signal

t = Wave.Input.t ;
f = Wave.FFT.f ;

Lm = Wave.Input.Lm ;
Rm = Wave.Input.Rm ;
[~,fund_f] = min(abs(f-fg));

%% transfer functions
s = 1i*2*pi*f;
Y21 = 1 ./ (s*Lm + Rm) ;

%% Compute currents 
i2 = v_a_fft .* Y21 ;

i2(fund_f) = I*exp(1i*(-phi-pi/2)) ;

i2_wave = ifft(i2,L,2,'symmetric')*L/2; 

%% 3 or 4 (3+VG) system 
% basically remove zero sequence component in 3 wire systems
if Wire == 3
    i2b = v_b_fft .* Y21 ;
    i2c = v_c_fft .* Y21 ;

    i2b(fund_f) = I*exp(1i*(-phi-pi/2-2*pi/3)) ;
    i2c(fund_f) = I*exp(1i*(-phi-pi/2+2*pi/3))  ;
 
    i2b_wave = ifft(i2b,L,2,'symmetric')*L/2; 
    i2c_wave = ifft(i2c,L,2,'symmetric')*L/2; 

    % abc -> alfa beta 0 transformation
    i2_alfa = (2/3)*(i2_wave -1/2*i2b_wave -1/2*i2c_wave) ;
    
    i2_wave = i2_alfa ;

end

%% save data

Wave.Current.i_converter_side = i2_wave;
Wave.Current.i_grid_side = i2_wave;

%% reprocess current
[ Wave ] = current_post_LCL ( Wave ) ;

%% plot
if Wave.FFT.plot_current == 1 
    if Wire == 3
        figure;
        title(sprintf('Non dumped filter currents %.0f wire system',Wire))
        hold on
        plot(t,i2_wave)
        plot(t,i_50Hz_a)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Machine current','Sinusoidal Current')
    else
        figure;
        sgtitle(sprintf('Filter currents %.0f wire system',Wire))
        title('Non dumped filter currents')
        hold on
        plot(t,i2_wave)
        plot(t,i_50Hz_a)
        xlabel('Time [s]')
        ylabel('Current [A]')
        grid on
        legend('Machine current','Sinusoidal Current')   
    end
end

end