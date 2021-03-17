function  IEEE519_compliance_check ( i_a_fft_amplitude , Wave )
%%
fg = Wave.Input.fg ;
f = Wave.FFT.f ;
harmonics  = [f/fg ; i_a_fft_amplitude/i_a_fft_amplitude(2)*100 ]; 
harmonics(:,1)=[];
last_harmonic = 200 ;
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
figure;
hold on
title('Current harmonics magnitude')
scatter(harmonics(1,1:2:end),harmonics(2,1:2:end)) 
scatter(harmonics(1,2:2:end),harmonics(2,2:2:end))
% plot(harmonics(1,1:2:end),harmonics(2,1:2:end),'b','LineWidth',lw) 
% plot(harmonics(1,2:2:end),harmonics(2,2:2:end),'r','LineWidth',lw)
scatter(maxH(:,1),maxH(:,2),[],maxH(:,3),'filled')
xlabel('Harmonic number [n]')
ylabel('Magnitude [p.u.]')
xlim([0 last_harmonic])
grid on
set(gca, 'YScale', 'log')
colormap(map)
legend('Odd harmonics','Even harmonics')

end
