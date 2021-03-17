function [] = filter_compliance ( Wave )
%%
Ltot = Wave.Input.Lc + Wave.Input.Lg ;
[ i_a_fft_amplitude ] = current_fft( Ltot , Wave ) ;
IEEE519_compliance_check ( i_a_fft_amplitude , Wave ) ;

end