% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013
function [Ivec] = Current_FFT(waveform,Core)

t = waveform(:,1)-min(waveform(:,1));
I_grid = waveform(:,2);
Ts = t(2)-t(1);               % Sampling period
Fs = 1/Ts;
N=length(I_grid);             % Number of samples
f=round((0:N-1)*(Fs/N));      % Frequency Range
X =fft(I_grid,N)/N*2;         % FFT of a given current signal  %%% Divide by N/2 to get it normalised // RMS of FFT signal => sqrt(X(1)^2+sum(abs(X(2:N/2)).^2)/2);
X(1)=(X(1)/2);
% Core.I1max = abs(X(2));
Ph_X = unwrap(angle(X(1:N/2))); 
Xa = sort(X(1:N/2),'descend');

for i= 1:Core.Number_of_Harmonics
    fr(i) = find(Xa(i)==X(1:N/2));
end
fr = sort(fr);

if Core.Opt.Plot==1
    %Core.fig=Core.fig+1; figure(Core.fig); clf; 
    figure
    stem(f(fr),abs(X(fr)));
    ax = gca;
    ax.Position = [0.04 0.11 0.95 0.84];
    ax.YScale = 'log';
    ax.XTickMode = 'manual';
    ax.XTick = [f(fr)];
    ax.XTickLabelMode = 'manual';
    ax.XTickLabel = [f(fr)];
    ax.XTickLabelRotation = 90;
    ax.TickLength = [0.005 0];
    ax.TickDir = 'out';
    hold off
    title('FFT Plot')
    xlabel('Frequency')
    ylabel('Current Magnitude')
    grid on
    grid minor
    
    %display(f(fr(:)));
    
    figure, plot(t*1e6,I_grid);
    title('Inductor Current')
    xlabel('Time [us]')
    ylabel('Current[A]')
    grid

end


for i= 1:Core.Number_of_Harmonics
    Ivec(i) = struct('X',X(fr(i)),'AmpX',abs(X(fr(i))),'Ph',Ph_X(fr(i)),'f',f(fr(i)));
end

end