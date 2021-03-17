 function [ Wave ] = AC_cap_design ( Wave ) 
%%
Cf_val = Wave.Input.C ; % rated required capacitace
fs  = Wave.Input.fs;     %[Hz] : Switching Frequency

[ AC_Cap ] = AC_cap_data ( Wave ) ;

I_c_ac = abs(rms(Wave.Current.i_converter_side - Wave.Current.i_grid_side)) ;

ESR = 1e-3 ./ (2*pi*fs*AC_Cap.all_ac(:,1)*1e-6) ;
%%
N_parallel=ceil(I_c_ac./AC_Cap.all_ac(:,2));
Capacitance = AC_Cap.all_ac(:,1)./N_parallel;
Cost = 3*( AC_Cap.all_ac(:,1)*AC_Cap.ac_p1 + AC_Cap.ac_p2 ).*N_parallel ; 
Weight = 3*AC_Cap.all_ac(:,3).*N_parallel ; 

P_loss = 3*N_parallel.*ESR.*(I_c_ac./N_parallel).^2 ;
Efficiency = ( 100000 - P_loss ) / 100000 *100 ;

AC_design = [ AC_Cap.all_ac N_parallel Capacitance Cost ESR P_loss Efficiency Weight ];

AC_design(Capacitance<Cf_val*1000000,:)=[];

if isempty(AC_design)==1 
    disp('!! Warning !! No feasible AC capacitor design :(')
end

switch Wave.Input.Selected_AC_Cap_design
    case 'Minimum Cost'
        FinalDesign = AC_design(find(min(AC_design(:,6))),:);
    case 'Minimum Weight'
        FinalDesign = AC_design(find(min(AC_design(:,10))),:);
end

%% Save results 

Wave.AC_Cap.AC_design = AC_design ;

Wave.AC_Cap.C_tot = Cf_val ;

Wave.AC_Cap.FinalDesign = FinalDesign ;
Wave.AC_Cap.FinalDesignLegend = {'Single Cap','I','weight','Nstring','Capacitance',...
    'Cost','ESR','P_loss','Efficiency','Weight'} ;

%% plotting

if Wave.Input.AC_cap_plotting == 1
    figure;
    hold on
    title('AC capacitor designs')
    scatter(AC_design(:,6),AC_design(:,10),[],AC_design(:,9),'filled','MarkerEdgeColor',[0 0 0])
    scatter(FinalDesign(:,6),FinalDesign(:,10),150,FinalDesign(:,9),'filled',...
        'p','MarkerEdgeColor',[0 0 0])
    xlabel('Cost [$]')
    ylabel('Weight [kg]')
    h = colorbar ;
    ylabel(h,'Efficiency [%]')
    grid on
    colormap(jet)
end
end
