function [ Wave , DC_Design ] = DC_link_current_DC ( Wave , DC_Design ) 
%%
phi = DC_Design.phi ;
M = DC_Design.M ;
I_pk = DC_Design.I*sqrt(2) ;
t = Wave.Input.t ;
Topology = Wave.Input.Topology ;
fg = Wave.Input.fg ;
t_rad = t*2*pi*fg ;
[ ~, b_b ] = min(abs(t_rad - 4*pi/3));
[ ~, b_c ] = min(abs(t_rad - 2*pi/3));
i_DC_batt = 3/4*M*I_pk*cos(phi)*ones(1,size(t,2));
% not so sure about the three level topologies
switch Topology
    case {'Two Level','Two Level - SiC'}
        i_a = DC_Design.i_T1_wr + DC_Design.i_D1_wr  ;
        i_b = [i_a(b_b+1:end) i_a(1:b_b) ]; 
        i_c = [i_a(b_c+1:end) i_a(1:b_c) ]; 
        i_DC = i_a + i_b + i_c ;
    case 'Three Level NPC'
        i_top_a = DC_Design.i_T1_wr + DC_Design.i_D1_wr  ;
        i_neutral_a = DC_Design.i_D5_wr + DC_Design.i_D6_wr  ;
        i_top_b = [i_top_a(b_b+1:end) i_top_a(1:b_b) ]; 
        i_top_c = [i_top_a(b_c+1:end) i_top_a(1:b_c) ]; 
        i_neutral_b = [i_neutral_a(b_b+1:end) i_neutral_a(1:b_b) ]; 
        i_neutral_c = [i_neutral_a(b_c+1:end) i_neutral_a(1:b_c) ]; 
        i_DC = i_top_a + i_top_b + i_top_c + ( i_neutral_a + i_neutral_b + i_neutral_c)/2 ;
    case 'Three Level TTYPE'
        i_top_a = DC_Design.i_T1_wr + DC_Design.i_D1_wr  ;
        i_neutral_a = DC_Design.i_T3_wr + DC_Design.i_D3_wr  ;
        i_top_b = [i_top_a(b_b+1:end) i_top_a(1:b_b) ]; 
        i_top_c = [i_top_a(b_c+1:end) i_top_a(1:b_c) ]; 
        i_neutral_b = [i_neutral_a(b_b+1:end) i_neutral_a(1:b_b) ]; 
        i_neutral_c = [i_neutral_a(b_c+1:end) i_neutral_a(1:b_c) ]; 
        i_DC = i_top_a + i_top_b + i_top_c + ( i_neutral_a + i_neutral_b + i_neutral_c)/2 ;
end
i_DC_cap = i_DC - i_DC_batt ;
L = size(t,2);             % Length of signal

% DC Link 
i_DC_fft = fft(i_DC)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
i_DC_fft(1) = i_DC_fft(1)/2;
i_DC_fft = i_DC_fft(1:L/2+1);

i_DC_cap_fft = fft(i_DC_cap)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
i_DC_cap_fft(1) = i_DC_cap_fft(1)/2;
i_DC_cap_fft = i_DC_cap_fft(1:L/2+1);


DC_Design.i_DC_avg = i_DC_batt ;
DC_Design.i_DC_cap = i_DC_cap ;
DC_Design.i_DC_cap_rms = rms(i_DC_cap) ;
DC_Design.i_DC = i_DC ;
DC_Design.i_DC_rms = rms(i_DC) ;
DC_Design.i_DC_cap_fft = i_DC_cap_fft ;
DC_Design.i_DC_fft = i_DC_fft ;
%%


end