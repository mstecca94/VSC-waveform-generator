function [ Wave ] = filter_design ( Wave ) 
%%
ACFilter = Wave.Input.ACFilter ; 

switch ACFilter
    case 'LCL'
        [ Wave ] = LCL_design ( Wave )  ;
        if Wave.Input.plot_filter_compliance == 1 
            filter_compliance ( Wave ) ;
        end
        % for now the LCL filter designs only restricts total inductance
        % and capaacitance
    case 'L'
        [ Wave ] = L_design ( Wave )  ;
end

