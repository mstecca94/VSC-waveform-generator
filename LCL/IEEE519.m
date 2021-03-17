function [ IEEE_respected ] = IEEE519 ( i_a_fft_amplitude , Wave )
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
%%
compliance_check  = round(harmonics(2,1:last_harmonic) - maxH(:,2)',6) ;
compliance_check(compliance_check<=0)=0;
IEEE_respected = sum ( compliance_check ) ;
if compliance_check <= 0 
    IEEE_respected = -1 ;
end
end

