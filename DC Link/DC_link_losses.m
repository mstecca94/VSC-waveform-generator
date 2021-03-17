function [ Wave ] = DC_link_losses ( Wave ) 
%%
Cap_harmonics = abs(Wave.DClink.i_DC_cap_fft) ;
ESR_vs_f2 = Wave.DClink.ESR_vs_f2 ;
P = Wave.Input.P ;


if Wave.Input.DesignDClink == 1
    switch Wave.Input.DC_Design 
        case 'Minimum Cost'
            Design = Wave.DClink.cap_design_mc ; 
        case 'Minimum Volume'
            Design = Wave.DClink.cap_design_mv ; 
        case 'Maximum Lifetime'
            Design = Wave.DClink.cap_design_Ml ;
    end
else
    % this is a minimum cost design valid for SPWM (should work also in all other cases)
    load('PreMadeDesign_DC.mat') 
    Design = DC_Cap.Design ;
    Wave.DClink.Design_guide = DC_Cap.Legend ;
end

Losses_h = Design(6)/1000*ESR_vs_f2(2,:).*(Cap_harmonics./Design(8)).^2;
Losses = sum ( Losses_h ) * Design(8) * 2 ;

%% Save data

Wave.DClink.Design = Design ;
Wave.DClink.HarmonicLosses = Losses_h ;
Wave.DClink.Losses = Losses ;
Wave.DClink.DCLinkEfficiency = (P-Losses)/P*100 ;

end