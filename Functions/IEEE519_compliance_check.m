function  IEEE519_compliance_check ( i_a_fft_amplitude , Wave )
%%
fg = Wave.Input.fg ;
hs = Wave.Input.fs/fg ;
f = Wave.FFT.f ;
harmonics  = [f/fg ; i_a_fft_amplitude/i_a_fft_amplitude(2)*100 ]; 
harmonics(:,1)=[];
last_harmonic = Wave.Input.fs/fg*15 ;

C = Wave.Input.C ;
Lc = Wave.Input.Lc ;
Lg = Wave.Input.Lg ;

wres = sqrt((Lc+Lg)/(Lg*Lc*C));
wlc=sqrt(1/(Lc*C));

control_bandwidth = max([wlc,wres])*1.3/2/pi; % assume active damping cancels h before resonance
[~,min_f] = min(abs(f-control_bandwidth));

%%
% odd harmonics
for h=3:2:last_harmonic
    if h>=3 && h<11
        maxH(h,:) = [h 4 0] ;
    elseif h>=11 && h<17
        maxH(h,:) = [h 2 0] ;
    elseif h>=17 && h<23
        maxH(h,:) = [h 1.5 0] ;
    elseif h>=23 && h<35
        maxH(h,:) = [h 0.6 0] ;
    elseif h>=35 %&& h<=50
        maxH(h,:) = [h 0.3 0] ;
    end
end
% even harmonics
for h=2:2:last_harmonic
    if h>=3 && h<11
        maxH(h,:) = [h 4*0.25 2] ;
    elseif h>=11 && h<17
        maxH(h,:) = [h 2*0.25 2] ;
    elseif h>=17 && h<23
        maxH(h,:) = [h 1.5*0.25 2] ;
    elseif h>=23 && h<35
        maxH(h,:) = [h 0.6*0.25 2] ;
    elseif h>=35% && h<=50
        maxH(h,:) = [h 0.3*0.25 2] ;
    end
end

maxH(1,:) = [ 1 100 0 ];
map = [0 0 1
       1 0 0];
lw = 1.25 ;

%%
harmonics2 = harmonics(:,harmonics(1,:)>=hs*0.8);
harmonics2 = harmonics2(:,harmonics2(2,:)>=1e-8);
%%

figure;
hold on
title('Current harmonics magnitude')
% bar(harmonics(1,2:end),harmonics(2,2:end),'FaceColor','#2ca02c','EdgeColor','#2ca02c') 
bar(harmonics2(1,2:end),harmonics2(2,2:end),'FaceColor','#2ca02c','EdgeColor','#2ca02c') 
scatter(maxH(2:2:end,1),maxH(2:2:end,2),[],maxH(2:2:end,3),'x','MarkerEdgeColor','#1F77B4')
scatter(maxH(3:2:end,1),maxH(3:2:end,2),[],maxH(3:2:end,3),'x','MarkerEdgeColor','#d62728')
ylabel('Magnitude [p.u.]')
xlim([0 last_harmonic])
grid on
set(gca, 'YScale', 'log')
colormap(map)
legend('Amplitude','Odd harmonics limits','Even harmonics limits')

end
