function [ Wave , DC_Design ] = volt_fft_DC ( Wave , DC_Design )

t = Wave.Input.t ;

v_a = DC_Design.v_a ;
v_b = DC_Design.v_b ;
v_c = DC_Design.v_c ;

%% Voltage fft - Phase voltage

L = size(t,2);             % Length of signal
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

%% Save data

DC_Design.v_a_fft = v_a_fft ;
DC_Design.v_b_fft = v_b_fft ;
DC_Design.v_c_fft = v_c_fft ;

end