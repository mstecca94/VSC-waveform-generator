function [ Wave ] = DC_link_currentMD ( Wave ) 
%%
phi = Wave.Input.phi ;
M = Wave.Input.M ;
I_pk = Wave.Input.I*sqrt(2) ;
t = Wave.Input.t ;
Topology = Wave.Input.Topology ;
fg = Wave.Input.fg ;
fs = Wave.Input.fs ;
f = Wave.FFT.f ;
t_rad = t*2*pi*fg ;
[ ~ , b_b ] = min(abs(t_rad - 4*pi/3));
[ ~ , b_c ] = min(abs(t_rad - 2*pi/3));
i_DC_batt = 3/4*M*I_pk*cos(phi)*ones(1,size(t,2));
% not so sure about the three level topologies
switch Topology
    case {'Two Level','Two Level - SiC'}
        i_a = Wave.CurrentWR.i_T1_wr + Wave.CurrentWR.i_D1_wr  ;
        i_b = [i_a(b_b+1:end) i_a(1:b_b) ]; 
        i_c = [i_a(b_c+1:end) i_a(1:b_c) ]; 
        i_DC = i_a + i_b + i_c ;
    case 'Three Level NPC'
        i_top_a = Wave.CurrentWR.i_T1_wr + Wave.CurrentWR.i_D1_wr  ;
        i_neutral_a = Wave.CurrentWR.i_D5_wr + Wave.CurrentWR.i_D6_wr  ;
        i_top_b = [i_top_a(b_b+1:end) i_top_a(1:b_b) ]; 
        i_top_c = [i_top_a(b_c+1:end) i_top_a(1:b_c) ]; 
        i_neutral_b = [i_neutral_a(b_b+1:end) i_neutral_a(1:b_b) ]; 
        i_neutral_c = [i_neutral_a(b_c+1:end) i_neutral_a(1:b_c) ]; 
        i_DC = i_top_a + i_top_b + i_top_c + ( i_neutral_a + i_neutral_b + i_neutral_c)/2 ;
    case 'Three Level TTYPE'
        i_top_a = Wave.CurrentWR.i_T1_wr + Wave.CurrentWR.i_D1_wr  ;
        i_neutral_a = Wave.CurrentWR.i_T3_wr + Wave.CurrentWR.i_D3_wr  ;
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

Wave.DClink.i_DC_cap = i_DC_cap ;
Wave.DClink.i_DC = i_DC ;
Wave.DClink.i_DC_cap_fft = i_DC_cap_fft ;
Wave.DClink.i_DC_fft = i_DC_fft ;

%%

if Wave.Input.DClinkCurrentPlotting == 1
    figure;
    hold on
    title('DC link current harmonics magnitude')
    plot(f/fg,abs(i_DC_fft)./abs(i_DC_fft(1)))
    xlabel('Harmonic number [n]')
    ylabel('Magnitude [p.u.]')
    xlim([0 fs*5.5/fg])
    grid on
%     %%
%     figure;
%     hold on
%     plot(t,i_DC)
%     plot(t,i_DC_batt)
%     plot(t,i_DC_cap)
%     
    switch Topology
        case {'Two Level','Two Level - SiC'}
            lw = 1.25 ;
            figure;
            hold on
            plot(t,i_a,'r','LineWidth',lw)
            plot(t,i_b,'g','LineWidth',lw)
            plot(t,i_c,'b','LineWidth',lw)
            plot(t,i_DC,'k','LineWidth',lw*0.75)
            xlabel('Time [s]')
            ylabel('Current [A]')
            legend('ph A','ph B','ph C','I_{dc}')
            grid on
        case {'Three Level NPC','Three Level TTYPE'}
            lw = 1.25;
            figure;
            hold on
            plot(t,(i_top_a+i_neutral_a),'r','LineWidth',lw)
            plot(t,(i_top_b+i_neutral_b),'g','LineWidth',lw)
            plot(t,(i_top_c+i_neutral_c),'b','LineWidth',lw)
            plot(t,i_DC,'k','LineWidth',lw*0.75)
            xlabel('Time [s]')
            ylabel('Current [A]')
            legend('ph A','ph B','ph C','I_{dc}')
            grid on
    end
end

end