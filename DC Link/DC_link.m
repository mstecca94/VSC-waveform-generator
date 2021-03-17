function [ Wave ] = DC_link ( Wave )

% load DC capacitors data
[ Wave ] = DC_capacitors_data ( Wave ) ;
%%
% design dc link only if activated
if Wave.Input.DesignDClink == 1
    % design DC link capacitors / this has to be adjusted for more modulations
    [ Wave ] = DC_link_design ( Wave ) ;
end

% find DC Link current / in this point
[ Wave ] = DC_link_current ( Wave ) ;

% evaluate DC link losses
[ Wave ] = DC_link_losses ( Wave )  ;

end
