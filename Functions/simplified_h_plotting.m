function [] = simplified_h_plotting( Wave )

v_a_fft_amplitude = Wave.FFT.v_a_fft_amplitude ;
v_ab_fft_amplitude = Wave.FFT.v_ab_fft_amplitude ;
v_a_fft_phase = Wave.FFT.v_a_fft_phase ;
v_ab_fft_phase = Wave.FFT.v_ab_fft_phase ;

vdc = Wave.Input.vdc ;
fg = Wave.Input.fg ;
fs = Wave.Input.fs ;
f = Wave.FFT.f ;

% remove low influence harmonics
[~,b]=find(v_a_fft_amplitude/vdc*2<=0.05);
v_a_fft_phase(b)=[];
v_a_fft_amplitude(b)=[];

[~,b_ll]=find(v_ab_fft_amplitude/vdc*2<=0.05);
v_ab_fft_amplitude(b_ll)=[];
v_ab_fft_phase(b_ll)=[];


f_1=f;
f_2=f;
f_1(b)=[];
f_2(b_ll)=[];

figure;
subplot(4,1,1)
hold on
title('Phase voltage harmonics magnitude')
scatter(f_1/fg,v_a_fft_amplitude/vdc*2) 
for x = 1:size(f_1,2)
    line([f_1(x)/fg f_1(x)/fg],[0 v_a_fft_amplitude(x)/vdc*2])
end
xlabel('Harmonic number [n]')
ylabel('Magnitude [p.u.]')
xlim([0 fs*3.5/fg])
grid on

subplot(4,1,2)
hold on
title('Phase voltage harmonics phase')
scatter(f_1,v_a_fft_phase/pi*180) 
xlabel('Harmonic frequency [Hz]')
ylabel('Phase [deg]')
xlim([0 fs*3.5])
grid on

subplot(4,1,3)
hold on
title('Line-to-line voltage harmonics magnitude')
scatter(f_2/fg,v_ab_fft_amplitude/vdc*2) 
for x = 1:size(f_2,2)
    line([f_2(x)/fg f_2(x)/fg],[0 v_ab_fft_amplitude(x)/vdc*2])
end
xlabel('Harmonic number [n]')
ylabel('Magnitude [p.u.]')
xlim([0 fs*3.5/fg])
grid on

subplot(4,1,4)
hold on
title('Line-to-line voltage harmonics phase')
scatter(f_2,v_ab_fft_phase/pi*180) 
xlabel('Harmonic frequency [Hz]')
ylabel('Phase [deg]')
xlim([0 fs*3.5])
grid on
