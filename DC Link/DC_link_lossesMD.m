function [ Wave ] = DC_link_lossesMD ( Wave ) 
%%
Cap_harmonics = abs(Wave.DClink.i_DC_cap_fft) ;
ESR = 0.24./(0.000082*2*pi.*Wave.FFT.f(:,2:end)) ;
P = Wave.Input.P ;

Cap_harmonics = abs(Wave.DClink.i_DC_cap_fft(:,2:end)) ;
Losses_h = ESR.*(Cap_harmonics./ 9 ).^2;
Losses = sum ( Losses_h ) * 9 * 2 ; % 9 parallel strings of 2 cap in series

%% Save data

Wave.DClink.Design = Design ;
Wave.DClink.HarmonicLosses = Losses_h ;
Wave.DClink.Losses = Losses ;
Wave.DClink.DCLinkEfficiency = (P-Losses)/P*100 ;

end