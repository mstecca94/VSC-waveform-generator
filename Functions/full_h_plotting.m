function [] = full_h_plotting( Wave )

v_a_fft_phase = Wave.FFT.v_a_fft_phase ;
v_a_fft_amplitude = Wave.FFT.v_a_fft_amplitude ;
v_ab_fft_phase = Wave.FFT.v_ab_fft_phase ;
v_ab_fft_amplitude = Wave.FFT.v_ab_fft_amplitude ;

vdc = Wave.Input.vdc ;
fg = Wave.Input.fg ;
fs = Wave.Input.fs ;
f = Wave.FFT.f ;

figure;
subplot(4,1,1)
hold on
title('Phase voltage harmonics magnitude')
plot(f/fg,v_a_fft_amplitude/vdc*2) 
xlabel('Harmonic number [n]')
ylabel('Magnitude [p.u.]')
xlim([0 fs*3.5/fg])
grid on
set(gca, 'YScale', 'log')

subplot(4,1,2)
hold on
title('Phase voltage harmonics phase')
scatter(f/fg,(v_a_fft_phase-v_a_fft_phase(1))/pi*180) 
xlabel('Harmonic number [n]')
ylabel('Phase [deg]')
xlim([0 fs*3.5/fg])
grid on

subplot(4,1,3)
hold on
title('Line-to-line voltage harmonics magnitude')
plot(f/fg,v_ab_fft_amplitude/vdc*2) 
xlabel('Harmonic number [n]')
ylabel('Magnitude [p.u.]')
xlim([0 fs*3.5/fg])
grid on
set(gca, 'YScale', 'log')

subplot(4,1,4)
hold on
title('Line-to-line voltage harmonics phase')
scatter(f/fg,(v_ab_fft_phase-v_ab_fft_phase(1))/pi*180) 
xlabel('Harmonic number [n]')
ylabel('Phase [deg]')
xlim([0 fs*3.5/fg])
grid on