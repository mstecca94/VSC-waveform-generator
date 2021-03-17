lw = 1.25 ;
    
figure;
title('Weight - Cost - Efficiency design space')

hold on% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
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

hold on% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level') == 1 
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs/1000,'o','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level - SiC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs/1000,'p','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level NPC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs/1000,'>','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level TTYPE') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs/1000,'d','LineWidth',lw)
    end
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
title('Weight - Cost - Efficiency design space')
hold on% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
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
hold on% for zz = 1:size(ModComparison(1,1,1).Wave.Input.fs_range,2)
for zz = 1:4
for yy = 1:size(ModComparison(1,1,1).Wave.Input.Topologies,2)
for xx = 1:size(ModComparison(1,1,1).Wave.Input.ModulationStrategies,2)
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level') == 1 
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs,'o','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Two Level - SiC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs,'p','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level NPC') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs,'>','LineWidth',lw)
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Topology,'Three Level TTYPE') == 1
        scatter(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency,[],...
            ModComparison(xx,yy,zz).Wave.Input.fs,'d','LineWidth',lw)
    end
    if strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'Third Harmonic Injection 1/4') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'THI 1/4','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'Third Harmonic Injection 1/6') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'THI 1/6','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'S-PWM') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'S','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'SV-PWM') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'SV','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM MAX') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-MAX','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM MIN') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-MIN','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM 0') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-0','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM 1') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-1','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM 2') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-2','HorizontalAlignment', 'center')
    elseif strcmp(ModComparison(xx,yy,zz).Wave.Input.Modulation,'D-PWM 3') == 1
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02,'D-3','HorizontalAlignment', 'center')
    else
        text(ModComparison(xx,yy,zz).Wave.System.Cost,...
            ModComparison(xx,yy,zz).Wave.System.Efficiency+0.02...
            ,sprintf('%s',char(ModComparison(xx,yy,zz).Wave.Input.Modulation)),'HorizontalAlignment', 'center')
    end

    text(ModComparison(xx,yy,zz).Wave.System.Cost,...
        ModComparison(xx,yy).Wave.System.Efficiency-0.02...
        ,sprintf('[%.1f]',ModComparison(xx,yy,zz).Wave.System.Weight),'HorizontalAlignment', 'center')
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
