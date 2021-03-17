function [ Wave ] = volt_fft ( Wave )

t_step = Wave.Input.t_step ;
t = Wave.Input.t ;

v_a = Wave.Voltage.v_a ;
v_b = Wave.Voltage.v_b ;
v_c = Wave.Voltage.v_c ;

v_ab = Wave.Voltage.v_ab ;
v_bc = Wave.Voltage.v_bc ;
v_ca = Wave.Voltage.v_ca ;

%% Voltage fft - Phase voltage

F_samp = 1/t_step;         % Sampling frequency                    
L = size(t,2);             % Length of signal
f = F_samp*(0:(L/2))/L;    % sampled frequencies

% phase A
v_a_fft = fft(v_a)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_a_fft(1) = v_a_fft(1)/2;
v_a_fft = v_a_fft(1:L/2+1);

% phase B
v_b_fft = fft(v_b)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_b_fft(1) = v_b_fft(1)/2;
v_b_fft = v_b_fft(1:L/2+1);

% phase C
v_c_fft = fft(v_c)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_c_fft(1) = v_c_fft(1)/2;
v_c_fft = v_c_fft(1:L/2+1);

% harmonic voltage amplitude 
v_a_fft_amplitude = abs(v_a_fft);
v_b_fft_amplitude = abs(v_b_fft);
v_c_fft_amplitude = abs(v_c_fft);
% harmonic voltage phase
v_a_fft_phase = angle(v_a_fft);
v_b_fft_phase = angle(v_b_fft);
v_c_fft_phase = angle(v_c_fft);

%% Voltage fft - Line-to-line

F_samp = 1/t_step;         % Sampling frequency                    
L = size(t,2);             % Length of signal
f = F_samp*(0:(L/2))/L;    % sampled frequencies

% AB
v_ab_fft = fft(v_ab)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_ab_fft(1) = v_ab_fft(1)/2;
v_ab_fft = v_ab_fft(1:L/2+1);

% BC
v_bc_fft = fft(v_bc)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_bc_fft(1) = v_bc_fft(1)/2;
v_bc_fft = v_bc_fft(1:L/2+1);

% CA
v_ca_fft = fft(v_ca)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
v_ca_fft(1) = v_ca_fft(1)/2;
v_ca_fft = v_ca_fft(1:L/2+1);

% harmonic voltage amplitude 
v_ab_fft_amplitude = abs(v_ab_fft);
v_bc_fft_amplitude = abs(v_bc_fft);
v_ca_fft_amplitude = abs(v_ca_fft);
% harmonic voltage phase
v_ab_fft_phase = angle(v_ab_fft);
v_bc_fft_phase = angle(v_bc_fft);
v_ca_fft_phase = angle(v_ca_fft);

%%

Wave.FFT.v_a_fft = v_a_fft ;
Wave.FFT.v_b_fft = v_b_fft ;
Wave.FFT.v_c_fft = v_c_fft ;
Wave.FFT.v_ab_fft = v_ab_fft ;

Wave.FFT.v_a_fft_amplitude = v_a_fft_amplitude ;
Wave.FFT.v_a_fft_phase = v_a_fft_phase ;
Wave.FFT.v_b_fft_amplitude = v_b_fft_amplitude ;
Wave.FFT.v_b_fft_phase = v_b_fft_phase ;
Wave.FFT.v_c_fft_amplitude = v_c_fft_amplitude ;
Wave.FFT.v_c_fft_phase = v_c_fft_phase ;

Wave.FFT.v_ab_fft_amplitude = v_ab_fft_amplitude ;
Wave.FFT.v_ab_fft_phase = v_ab_fft_phase ;
Wave.FFT.v_bc_fft_amplitude = v_bc_fft_amplitude ;
Wave.FFT.v_bc_fft_phase = v_bc_fft_phase ;
Wave.FFT.v_ca_fft_amplitude = v_ca_fft_amplitude ;
Wave.FFT.v_ca_fft_phase = v_ca_fft_phase ;

Wave.FFT.f = f ;
%%
if Wave.FFT.plotting == 1 
    simplified_h_plotting( Wave )
elseif Wave.FFT.plotting == 2
    full_h_plotting( Wave )
end

end