function [ Wave ] = pareto3d ( Wave ) 

Results_Filter = Wave.Inductor.Results_Filter ;
Widx = 3 ;
Vidx = 6 ;
Lidx = 4 ;


Vol = 10000 ; 
Wei = 10000 ;
ParetoFilter = [ ] ;
iii = 1 ;
while size(Results_Filter,1)>1
    [minL , idx ] = min(Results_Filter(:,Lidx)) ;
    if  Results_Filter(idx,Vidx) <  Vol 
        ParetoFilter(iii,:) = Results_Filter(idx,:);
        iii = iii + 1 ;
        Vol = min(Vol,Results_Filter(idx,Vidx));
    end
    if  Results_Filter(idx,Widx) <  Wei 
        ParetoFilter(iii,:) = Results_Filter(idx,:);
        iii = iii + 1 ;
        Wei = min(Wei,Results_Filter(idx,Widx));
    end
    Results_Filter(idx,:) = [] ;     
end
%% Save
Wave.Inductor.ParetoFilter = ParetoFilter ;

end