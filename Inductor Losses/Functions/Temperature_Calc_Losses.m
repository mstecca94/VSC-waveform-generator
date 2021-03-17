% Author: Thiago Soeiro
% Date of Last Update: 13.07.2013
function [ Core ] = Temperature_Calc_Losses( Core )
%% Temperature Estimation
    P = Core.Total_Loss;
    switch Core.CoreType
        case 'Toroidal' % Toroidal Powder Cores from Changsung
            A_top = ((Core.OD+Core.ID)/2)^2 * pi;
            A_bot = ((Core.OD+Core.ID)/2)^2 * pi;
            A_side = (2*pi*(Core.OD+Core.ID)/2)*Core.HT;
        case 'UU'
            A_top = Core.c*Core.b;
            A_bot = Core.c*Core.b;
            A_side = 2*(2*Core.a*Core.b + 2*Core.a*Core.c);           
            
        case {'EE', 'EE Integrated'}
            A_top = Core.c*Core.b;
            A_bot = Core.c*Core.b;
            A_side = 2*(2*Core.a*Core.b + 2*Core.a*Core.c);  
    end
    
    % Top
    h_top = 15;
    Rth_top = 1/( h_top * A_top);
    
    % Bottom
    h_bot = 15;
    Rth_bot = 1/( h_bot * A_bot);
    
    % Side
    h_side = 15;
    Rth_side = 1/( h_side * A_side);
    
    Rth = 1/( 1/Rth_top + 1/Rth_bot + 1/Rth_side );
    
    Core.Inductor.Temp = P * Rth + Core.Tamb;

    if Core.Inductor.Temp > Core.Tmax
%         fprintf('Inductor Temperature too high!\n')
        Core.BadResult=1;
    end

end

