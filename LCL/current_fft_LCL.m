function [ i_a_fft_amplitude ] = current_fft_LCL( Ltot , Wave , kres )
%% initialize parameters
ACFilter = Wave.Input.ACFilter ;
Wire = Wave.Input.Wire ;
phi = Wave.Input.phi ;
v_a_fft = Wave.FFT.v_a_fft ;
v_b_fft = Wave.FFT.v_b_fft ;
v_c_fft = Wave.FFT.v_c_fft ;

I = Wave.Input.I*sqrt(2) ;
L = size( Wave.Input.t,2);             % Length of signal

t = Wave.Input.t ;
fg = Wave.Input.fg ;
fs = Wave.Input.fs ;
f = Wave.FFT.f ;
%%
switch ACFilter
    case {'Custom LCL','LCL'} % LCL filter
%         kres =  Wave.Input.kres ;
        wres = kres*fs*2*pi ;
        control_bandwidth = wres*1.3/2/pi; % assume active damping cancels h before resonance
        [~,min_f] = min(abs(f-control_bandwidth));
        [~,fund_f] = min(abs(f-fg));
        %% transfer functions
        s = 1i*2*pi*f;
        Y21 = wres^2 ./ (Ltot.*s.*(s.^2 + wres^2)) ;
        %% Compute currents 
        i2 = v_a_fft .* Y21 ;
        i2(1:min_f) = 0 ;
        i2(fund_f) = I*exp(1i*(phi-pi/2)) ;
        i2a_wave = ifft(i2,L,2,'symmetric')*L/2; 
        %% 3 or 4 (3+VG) system 
        % basically remove zero sequence component in 3 wire systems
        if Wire == 3
            % phase b
            i2b = v_b_fft .* Y21 ;
            i2b(1:min_f) = 0 ;
            i2b(fund_f) = I*exp(1i*(phi-pi/2-2*pi/3))  ;
            i2b_wave = ifft(i2b,L,2,'symmetric')*L/2; 
            % phase c
            i2c = v_c_fft .* Y21 ;
            i2c(1:min_f) = 0 ;
            i2c(fund_f) = I*exp(1i*(phi-pi/2+2*pi/3))  ;
            i2c_wave = ifft(i2c,L,2,'symmetric')*L/2; 
            % abc -> alfa beta 0 transformation
            i2_alfa = (2/3)*(i2a_wave -1/2*i2b_wave -1/2*i2c_wave) ;
            i2a_wave = i2_alfa ;    
        end
        %% Line-to-line Current fft
        L = size(t,2);             % Length of signal
        % phase A
        i_a_fft = fft(i2a_wave)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
        i_a_fft(1) = i_a_fft(1)/2;
        i_a_fft = i_a_fft(1:L/2+1);

        % harmonic current amplitude 
        i_a_fft_amplitude = abs(i_a_fft);
        % remove switching f harmonics  that gets cancelled in line-to-line
        [~,sw_f] = min(abs(f-fs));
        i_a_fft_amplitude(sw_f) = 0 ;
    case 'L' % just and L filter
        [~,fund_f] = min(abs(f-fg));
        % transfer functions
        s = 1i*2*pi*f;
        Y21 = 1 ./ (s*Ltot) ;
        %% Compute currents 
        i2 = v_a_fft .* Y21 ;
        i2(fund_f) = I*exp(1i*(phi-pi/2)) ;
        i2(1) = 0 ; % remove DC component that creats shit 
        i2a_wave = ifft(i2,L,2,'symmetric')*L/2; 
        %% 3 or 4 (3+VG) system 
        % basically remove zero sequence component in 3 wire systems
        if Wire == 3
            % phase b
            i2b = v_b_fft .* Y21 ;
            i2b(fund_f) = I*exp(1i*(phi-pi/2-2*pi/3))  ;
            i2b(1) = 0 ;
            i2b_wave = ifft(i2b,L,2,'symmetric')*L/2; 
            % phase c
            i2c = v_c_fft .* Y21 ;
            i2c(fund_f) = I*exp(1i*(phi-pi/2+2*pi/3))  ;
            i2c(1) = 0 ;
            i2c_wave = ifft(i2c,L,2,'symmetric')*L/2; 
            % abc -> alfa beta 0 transformation
            i2_alfa = (2/3)*(i2a_wave -1/2*i2b_wave -1/2*i2c_wave) ;
            i2a_wave = i2_alfa ;    
        end
        %% Line-to-line Current fft
        L = size(t,2);             % Length of signal
        % phase A
        i_a_fft = fft(i2a_wave)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
        i_a_fft(1) = i_a_fft(1)/2;
        i_a_fft = i_a_fft(1:L/2+1);

        % harmonic current amplitude 
        i_a_fft_amplitude = abs(i_a_fft);
        % remove switching f harmonics  that gets cancelled in line-to-line
        [~,sw_f] = min(abs(f-fs));
        i_a_fft_amplitude(sw_f) = 0 ;
end
end