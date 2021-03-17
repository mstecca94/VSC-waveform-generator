 function [ Wave ] = AC_cap_losses_routine ( Wave ) 
%%
% f = Wave.FFT.f ;
% i_c_h = Wave.Current.i_converter_side-Wave.Current.i_grid_side;
% 
% i_c_h_fft = fft(i_c_h)/L*2;    % fff t of phase voltage --- divide by L/2 to normalize
% i_c_h_fft(1) = i_c_h_fft(1)/2;
% i_c_h_fft = i_c_h_fft(1:L/2+1);

I_c_ac = abs(rms(Wave.Current.i_converter_side - Wave.Current.i_grid_side))  ;

ESR = Wave.AC_Cap.FinalDesign (7) ;

N_parallel = Wave.AC_Cap.FinalDesign (4) ;

P_loss = 3*N_parallel.*ESR.*(I_c_ac./N_parallel).^2 ;
Efficiency = ( 100000 - P_loss ) / 100000 *100 ;

Wave.AC_Cap.I_c_ac = I_c_ac ;
Wave.AC_Cap.Efficiency = Efficiency ;
Wave.AC_Cap.Losses = P_loss ;
end
