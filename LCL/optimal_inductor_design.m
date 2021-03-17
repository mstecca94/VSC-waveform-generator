function [ Wave ] = optimal_inductor_design ( Wave )
%%
load('PowderCore_CostWeight.mat')

p=1;
for z = 1:size(Wave.Inductor.Lc.Pareto,2)
    for y = 1:size(Wave.Inductor.Lc.Pareto(z).Result,2)
        for x = 1:size(Wave.Inductor.Lc.Pareto(z).Result,1)
        Result_Lc(p,1) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Total_Weight ;
        Result_Lc(p,2) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight ;
        Result_Lc(p,3) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_Weight ;

        Result_Lc(p,4) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Total_Loss ;
        Result_Lc(p,5) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Loss ;
        Result_Lc(p,6) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_Loss ;

        Result_Lc(p,7) = Wave.Inductor.Lc.Pareto(z).Result(x,y).BadResult ;
        
% %         % in FEMM higher diameters do not work
% %         if Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_Diameter>0.021
% %             Result_Lc(p,7) = 1;
% %         end
% %             
        % core material and cost
        if strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'High Flux 26u')
                Result_Lc(p,8) = 1 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Highflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'High Flux 60u')
                Result_Lc(p,8) = 1 ;
                Result_Lc(p,9) = Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Highflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'Mega Flux 26u')
                Result_Lc(p,8) = 2 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Megaflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'Mega Flux 50u')
                Result_Lc(p,8) = 2 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Megaflux_1_w*1000 ;
           elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'MPP 26u')
                Result_Lc(p,8) = 3 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*MPP_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'MPP 60u')
                Result_Lc(p,8) = 3 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*MPP_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'Sendust 26u')
                Result_Lc(p,8) = 4 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Sendust_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType,'Sendust 60u')
                Result_Lc(p,8) = 4 ;
                Result_Lc(p,9)= Wave.Inductor.Lc.Pareto(z).Result(x,y).Core_Weight*Sendust_1_w*1000 ;
            else
                Wave.Inductor.Lc.Pareto(z).Result(x,y).MaterialType
        end
        % winding cost
        wire_coeff = Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_Diameter.^2/4*0.8*pi*1000000./...
            Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_n_strand ;
        Result_Lc(p,10) =  Wave.Inductor.Lc.Pareto(z).Result(x,y).Wire_Weight*15/(0.45 + wire_coeff) ;
        Result_Lc(p,11)  = Result_Lc(p,10)  + Result_Lc(p,9) ;
        Result_Lc(p,12)  = z ;
        Result_Lc(p,13)  = y ;
        Result_Lc(p,14)  = x ;
        
        p=p+1;
        end
    end
end

p=1;
for z = 1:size(Wave.Inductor.Lg.Pareto,2)
    for y = 1:size(Wave.Inductor.Lg.Pareto(z).Result,2)
        for x = 1:size(Wave.Inductor.Lg.Pareto(z).Result,1)
        Result_Lg(p,1) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Total_Weight ;
        Result_Lg(p,2) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight ;
        Result_Lg(p,3) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_Weight ;

        Result_Lg(p,4) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Total_Loss ;
        Result_Lg(p,5) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Loss ;
        Result_Lg(p,6) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_Loss ;

        Result_Lg(p,7) = Wave.Inductor.Lg.Pareto(z).Result(x,y).BadResult ;
% %         % in FEMM higher diameters do not work
% %         if Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_Diameter>0.021
% %             Result_Lg(p,7) = 1;
% %         end
% %             
                
        % core material and cost
        if strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'High Flux 26u')
                Result_Lg(p,8) = 1 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Highflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'High Flux 60u')
                Result_Lg(p,8) = 1 ;
                Result_Lg(p,9) = Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Highflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'Mega Flux 26u')
                Result_Lg(p,8) = 2 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Megaflux_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'Mega Flux 50u')
                Result_Lg(p,8) = 2 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Megaflux_1_w*1000 ;
           elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'MPP 26u')
                Result_Lg(p,8) = 3 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*MPP_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'MPP 60u')
                Result_Lg(p,8) = 3 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*MPP_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'Sendust 26u')
                Result_Lg(p,8) = 4 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Sendust_1_w*1000 ;
            elseif strcmp(Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType,'Sendust 60u')
                Result_Lg(p,8) = 4 ;
                Result_Lg(p,9)= Wave.Inductor.Lg.Pareto(z).Result(x,y).Core_Weight*Sendust_1_w*1000 ;
            else
                Wave.Inductor.Lg.Pareto(z).Result(x,y).MaterialType
        end
        % winding cost
        wire_coeff = Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_Diameter.^2/4*0.8*pi*1000000./...
            Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_n_strand ;
        Result_Lg(p,10) =  Wave.Inductor.Lg.Pareto(z).Result(x,y).Wire_Weight*15/(0.45 + wire_coeff) ;
        Result_Lg(p,11)  = Result_Lg(p,10)  + Result_Lg(p,9) ;
        Result_Lg(p,12)  = z ;
        Result_Lg(p,13)  = y ;
        Result_Lg(p,14)  = x ;
        
        p=p+1;
        end
    end
end
%% eliminate bad results
Result_Lc2=Result_Lc(Result_Lc(:,7)~=1,:);
Result_Lg2=Result_Lg(Result_Lg(:,7)~=1,:);

switch Wave.Input.InductorDesign 
    case 'Minimum Cost'
        [~,b]=min(Result_Lc2(:,11));
        [~,b2]=min(Result_Lg2(:,11));
        Lc_Design = Wave.Inductor.Lc.Pareto(Result_Lc2(b,12)).Result(Result_Lc2(b,14),Result_Lc2(b,13)); 
        Lg_Design = Wave.Inductor.Lg.Pareto(Result_Lg2(b2,12)).Result(Result_Lg2(b2,14),Result_Lg2(b2,13)); 
    case 'Minimum Losses'
        [~,b]=min(Result_Lc2(:,4));
        [~,b2]=min(Result_Lg2(:,4));
        Lc_Design = Wave.Inductor.Lc.Pareto(Result_Lc2(b,12)).Result(Result_Lc2(b,14),Result_Lc2(b,13)); 
        Lg_Design = Wave.Inductor.Lg.Pareto(Result_Lg2(b2,12)).Result(Result_Lg2(b2,14),Result_Lg2(b2,13)); 
    case 'Minimum Weight'
        [~,b]=min(Result_Lc2(:,1));
        [~,b2]=min(Result_Lg2(:,1));
        Lc_Design = Wave.Inductor.Lc.Pareto(Result_Lc2(b,12)).Result(Result_Lc2(b,14),Result_Lc2(b,13)); 
        Lg_Design = Wave.Inductor.Lg.Pareto(Result_Lg2(b2,12)).Result(Result_Lg2(b2,14),Result_Lg2(b2,13));
    case 'Optimal Point'
%         prova = Result_Lc2 ;
%         prova(:,4)=Result_Lc2(:,4)*10;
%         prova(:,15)=Result_Lc2(:,4)/max(Result_Lc2(:,4));
%         prova(:,16)=Result_Lc2(:,1)/max(Result_Lc2(:,1));
%         prova(:,17)=Result_Lc2(:,11)/max(Result_Lc2(:,11));
%         prova(:,18)=prova(:,15) + prova(:,16);
        Optimality_Lc=(Result_Lc2(:,4)/max(Result_Lc2(:,4))) .*...
            (Result_Lc2(:,1)/max(Result_Lc2(:,1)));
        Optimality_Lg=(Result_Lg2(:,4)/max(Result_Lg2(:,4))) .*...
            (Result_Lg2(:,1)/max(Result_Lg2(:,1)));

%         [~,pr_b]=min(prova(:,18));
        [~,b]=min(Optimality_Lc);
        [~,b2]=min(Optimality_Lg);
        Lc_Design = Wave.Inductor.Lc.Pareto(Result_Lc2(b,12)).Result(Result_Lc2(b,14),Result_Lc2(b,13)); 
        Lg_Design = Wave.Inductor.Lg.Pareto(Result_Lg2(b2,12)).Result(Result_Lg2(b2,14),Result_Lg2(b2,13)); 
end
Wave.Inductor.Design_spec_legend = {'Total Weight','Core Weight','Wire Weight','Total Losses',...
    'core Weight','Wire Weight','Bad Result','Material Type','Core Cost','Wire Cost','Total Cost',...
    'z','y','x','-> Wave.Inductor.Lg.Pareto(z).Result(x,y)'} ;
Wave.Inductor.Material_legend = {'HF 26','HF 60','MF 26','MF 50','MPP 26','MPP 60','Snd 26','Snd 60'} ;
Wave.Inductor.Lg_Design = Lg_Design ;
Wave.Inductor.Lc_Design_spec = Result_Lc2(b,:) ;
Wave.Inductor.Lc_Design = Lc_Design ;
Wave.Inductor.Lg_Design_spec = Result_Lg2(b2,:) ;

%%
if Wave.Input.plot_InductorDesign == 1 
    figure;
    sgtitle('Inductor Designs')
    subplot(1,2,1)
    title('Converter Side')
    hold on
    scatter(Result_Lc2(:,4),Result_Lc2(:,1),[],Result_Lc2(:,11),'filled')
    scatter(Result_Lc2(b,4),Result_Lc2(b,1),200,Result_Lc2(b,11),'p','filled')
    xlabel('Losses [W]')
    ylabel('Weight [kg]')
    grid on
    colormap(jet)
    colorbar
    legend('All Designs','Selected Design')

    subplot(1,2,2)
    hold on
    title('Grid Side')
    scatter(Result_Lg2(:,4),Result_Lg2(:,1),[],Result_Lg2(:,11),'filled')
    scatter(Result_Lg2(b2,4),Result_Lg2(b2,1),200,Result_Lg2(b2,11),'p','filled')
    xlabel('Losses [W]')
    ylabel('Weight [kg]')
    grid on
    colormap(jet)
    colorbar
    legend('All Designs','Selected Design')
    


end

% %%
% prova = Result_Lc2 ;
% prova(:,4)=prova(:,4)*10;
% prova(:,15)=prova(:,4)/max(prova(:,4));
% prova(:,16)=prova(:,1)/max(prova(:,1));
% prova(:,17)=prova(:,11)/max(prova(:,11));
% prova(:,18)=prova(:,15) + prova(:,16);
% prova(:,19)=prova(:,15) .* prova(:,16);
% 
% [~,pr_b]=min(prova(:,18));
% [~,pr_b2]=min(prova(:,19));
% 
% figure;
%     sgtitle('Inductor Designs')
%     subplot(1,2,1)
%     title('Abs')
%     hold on
%     scatter(prova(:,4),prova(:,1),[],prova(:,11),'filled')
%     scatter(prova(b,4),prova(b,1),200,prova(b,11),'p','filled')
%     xlabel('Losses [W]')
%     ylabel('Weight [kg]')
%     grid on
%     colormap(jet)
%     colorbar
%     legend('All Designs','Selected Design')
% 
%     subplot(1,2,2)
%     hold on
%     title('Pu')
%     scatter(prova(:,15),prova(:,16),[],prova(:,17),'filled')
%     scatter(prova(pr_b,15),prova(pr_b,16),200,prova(pr_b,17),'p','filled')
%     scatter(prova(pr_b2,15),prova(pr_b2,16),200,prova(pr_b2,17),'^','filled')
%     xlabel('Losses [W]')
%     ylabel('Weight [kg]')
%     grid on
%     colormap(jet)
%     colorbar
%     legend('All Designs','Selected Design')
%     
%     

end