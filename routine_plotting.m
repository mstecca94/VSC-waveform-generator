function [ ] = routine_plotting ( ModComparison )
%%
lw = 1.25 ;
    
figure;
title('Weight - Cost - Efficiency design space')

hold on
% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level') == 1 
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'o','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level - SiC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'p','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level NPC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'>','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level TTYPE') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'d','LineWidth',lw)
    end
end
end
end
grid on
xlabel('Cost [euro]')
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Weight [kg]';
colormap(jet)
legend(char(ModComparison(1,1,1).Wave.Input.Topologies))

%%
    
figure;
title('Weight - Cost - Efficiency design space')
hold on
% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level') == 1 
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'o','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level - SiC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'p','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level NPC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'>','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level TTYPE') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'d','LineWidth',lw)
    end
    text(ModComparison(xx,yy,zz).Wave.System.Cost-100,...
        ModComparison(xx,yy,zz).Wave.System.Efficiency+0.04...
        ,sprintf('%s - %.0f kHz',char(ModComparison(xx,yy,zz).Wave.Input.Modulation),...
        ModComparison(xx,yy,zz).Wave.Input.fs/1000))
    text(ModComparison(xx,yy,zz).Wave.System.Cost-50,...
        ModComparison(xx,yy).Wave.System.Efficiency+0.02...
        ,sprintf('{%.1f kW/kg}',ModComparison(xx,yy,zz).Wave.System.PowerDensity))
end
end
end
grid on
xlabel('Cost [euro]')
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Weight';
colormap(jet)
legend(char(ModComparison(1,1,1).Wave.Input.Topologies))


%%
figure;
title('Weight - Cost - Efficiency design space')
hold on
% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level') == 1 
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'o','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level - SiC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'p','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level NPC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'>','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level TTYPE') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.System.Weight,'d','LineWidth',lw)
    end
    text(ModComparison(xx,yy,zz).Wave.System.Cost-100,...
        ModComparison(xx,yy,zz).Wave.System.Efficiency+0.04...
        ,sprintf('%s',char(ModComparison(xx,yy,zz).Wave.Input.Modulation)))
    text(ModComparison(xx,yy,zz).Wave.System.Cost-50,...
        ModComparison(xx,yy).Wave.System.Efficiency+0.02...
        ,sprintf('{%.1f kW/kg}',ModComparison(xx,yy,zz).Wave.System.PowerDensity))
end
end
end
grid on
xlabel('Cost [euro]')
ylabel('Efficiency [%]')
c = colorbar;
c.Label.String = 'Switching frequency [kHz]';
colormap(jet)
legend(char(ModComparison(1,1,1).Wave.Input.Topologies))


%% 
figure;
sgtitle('Weight - Cost - Efficiency design space')
subplot(1,2,1)
hold on
% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if mod(xx,2) == 1 
        xy = 1 ;
    else
        xy = -1 ;
    end
    scatter(ModComparison(xx,yy,zz).Wave.System.Cost,ModComparison(xx,yy,zz).Wave.System.Efficiency)
    text(ModComparison(xx,yy,zz).Wave.System.Cost-100,ModComparison(xx,yy,zz).Wave.System.Efficiency+0.04*1*sign(xy)...
        ,sprintf('%s - %.0f kHz',char(Wave.Input.ModulationStrategies(xx)),Wave.Input.fs_range(yy)/1000))
    text(ModComparison(xx,yy,zz).Wave.System.Cost-50,ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02*1*sign(xy)...
        ,sprintf('{%.1f kg}',ModComparison(xx,yy).Wave.System.Weight))
end
end
end
legend(char(ModComparison(1,1,1).Wave.Input.ModulationStrategies))
grid on
xlabel('Cost [euro]')
ylabel('Efficiency [%]')
% c = colorbar;
% c.Label.String = 'Weight [kg]';
% colormap(jet)

subplot(1,2,2)
hold on
% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if mod(xx,2) == 1 
        xy = 1 ;
    else
        xy = -1 ;
    end
    scatter(ModComparison(xx,yy).Wave.System.CostperkW,ModComparison(xx,yy).Wave.System.Efficiency)
%     ModComparison(xx,yy).Wave.System.PowerDensity,'filled')
    text(ModComparison(xx,yy).Wave.System.CostperkW-1.5,ModComparison(xx,yy).Wave.System.Efficiency+0.04*1*sign(xy)...
        ,sprintf('%s - %.0f kHz',char(Wave.Input.ModulationStrategies(xx)),Wave.Input.fs_range(yy)/1000))
    text(ModComparison(xx,yy).Wave.System.CostperkW-0.75,ModComparison(xx,yy).Wave.System.Efficiency+0.02*1*sign(xy)...
        ,sprintf('{%.1f kW/kg}',ModComparison(xx,yy,zz).Wave.System.PowerDensity))
end
end
end

legend(char(ModComparison(1,1,1).Wave.Input.ModulationStrategies))
grid on
xlabel('Cost  per kW [â‚¬/kW]')
ylabel('Efficiency [%]')
% c = colorbar;
% c.Lbel.String = 'Power density [kW/kg]';
% colormap(jet)