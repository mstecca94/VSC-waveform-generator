%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath(genpath('C:\Users\mstecca\surfdrive\Marco\Simulations\Converter\EPE 2020'))
% addpath(genpath('C:\Users\mstec\surfdrive\Marco\Simulations\Converter\EPE 2020')) % personal
ccc

HR = load('HR_8kHz.mat'); 
HR = HR.Wave ;
MR = load('MR_8kHz.mat'); 
MR = MR.Wave ;
LR = load('LR_8kHz.mat'); 
LR = LR.Wave ;

LR.Opt = [91 91];
MR.Opt = [294 336];
HR.Opt = [239 268];

RHR = load('RHR_8kHz.mat'); 
RHR = RHR.WaveR ;
RMR = load('RMR_8kHz.mat'); 
RMR = RMR.WaveR ;
RLR = load('RLR_8kHz.mat'); 
RLR = RLR.WaveR ;

% MC = load('MC_8kHz.mat'); 
% MC = MC.Wave ;

%%
figure;
hold on
plot(HR.Current.i_converter_side)
plot(MR.Current.i_converter_side)
plot(LR.Current.i_converter_side)

HR.Input.Ripple = max(HR.Current.i_converter_side-HR.Input.I*sqrt(2))/(HR.Input.I*sqrt(2))*100;
% MR.Input.Ripple = max(MR.Current.i_converter_side-MR.Input.I)/(MR.Input.I*sqrt(2))*100;
LR.Input.Ripple = max(LR.Current.i_converter_side-LR.Input.I*sqrt(2))/(LR.Input.I*sqrt(2))*100;
% rMC.Input.Ripple = max(MC.Current.i_converter_side-MC.Input.I*sqrt(2))/(MC.Input.I*sqrt(2))*100;

% Ripple = round([LR.Input.Ripple  MC.Input.Ripple MR.Input.Ripple HR.Input.Ripple]) ; 
Ripple = round([LR.Input.Ripple  MR.Input.Ripple HR.Input.Ripple]) ; 

%%
lwsc = 1.5 ; 

figure;
%     sgtitle('Inductor Designs')
subplot(1,2,1)
title('Converter Side')
hold on
scatter(LR.Inductor.Lc_Design_All(:,4),LR.Inductor.Lc_Design_All(:,1),[],round(LR.Input.Ripple)*ones(size(LR.Inductor.Lc_Design_All(:,4),1),1),'filled')
scatter(MR.Inductor.Lc_Design_All(:,4),MR.Inductor.Lc_Design_All(:,1),[],round(MR.Input.Ripple)*ones(size(MR.Inductor.Lc_Design_All(:,4),1),1),'filled')
scatter(HR.Inductor.Lc_Design_All(:,4),HR.Inductor.Lc_Design_All(:,1),[],round(HR.Input.Ripple)*ones(size(HR.Inductor.Lc_Design_All(:,4),1),1),'filled')
scatter(LR.Inductor.Lc_Design_All(LR.Opt(1),4),LR.Inductor.Lc_Design_All(LR.Opt(1),1),[],round(LR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
scatter(MR.Inductor.Lc_Design_All(MR.Opt(1),4),MR.Inductor.Lc_Design_All(MR.Opt(1),1),[],round(MR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
scatter(HR.Inductor.Lc_Design_All(HR.Opt(1),4),HR.Inductor.Lc_Design_All(HR.Opt(1),1),[],round(HR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
xlabel('Losses [W]')
ylabel('Weight [kg]')
grid on
legend(num2str(Ripple'))
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;


subplot(1,2,2)
hold on
title('Grid Side')
scatter(LR.Inductor.Lg_Design_All(:,4),LR.Inductor.Lg_Design_All(:,1),[],round(LR.Input.Ripple)*ones(size(LR.Inductor.Lg_Design_All(:,4),1),1),'filled')
scatter(MR.Inductor.Lg_Design_All(:,4),MR.Inductor.Lg_Design_All(:,1),[],round(MR.Input.Ripple)*ones(size(MR.Inductor.Lg_Design_All(:,4),1),1),'filled')
scatter(HR.Inductor.Lg_Design_All(:,4),HR.Inductor.Lg_Design_All(:,1),[],round(HR.Input.Ripple)*ones(size(HR.Inductor.Lg_Design_All(:,4),1),1),'filled')
scatter(LR.Inductor.Lg_Design_All(LR.Opt(2),4),LR.Inductor.Lg_Design_All(LR.Opt(2),1),[],round(LR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
scatter(MR.Inductor.Lg_Design_All(MR.Opt(2),4),MR.Inductor.Lg_Design_All(MR.Opt(2),1),[],round(MR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
scatter(HR.Inductor.Lg_Design_All(HR.Opt(2),4),HR.Inductor.Lg_Design_All(HR.Opt(2),1),[],round(HR.Input.Ripple),'filled','MarkerEdgeColor',[0 0 0],'LineWidth',lwsc)
xlabel('Losses [W]')
ylabel('Weight [kg]')
grid on
colormap([hex2rgb('#ff7f0e') ; hex2rgb('#2ca02c') ; hex2rgb('#1f77b4') ])
legend(num2str(Ripple'))
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;

% other colors: purple 9467bd lime bcbd22 red d62728 orange ff7f0e
% marine 17becf blue 1f77b4 green 2ca02c

%%

[HR.Current.Turn_off,HR.Current.Turn_on]= envelope(HR.Current.i_converter_side,485,'peak');
[LR.Current.Turn_off,LR.Current.Turn_on]= envelope(LR.Current.i_converter_side,485,'peak');

lw = 1.75 ;

% add ZVS region
for x=1:size(HR.Input.t,2)
    if LR.Current.Turn_on(1,x)<0
        LR.Current.Turn_on(1,x)=0;
    end
    if HR.Current.Turn_on(1,x)<0
        HR.Current.Turn_on(1,x)=0;
    end
end

istart = 200 ;
iend = 5000 ;

figure;

subplot(1,2,1)
hold on
plot(MR.SemiconductorParameters.eonx(1,istart:iend),MR.SemiconductorParameters.eonx(2,istart:iend),'Color','#ff7f0e','LineWidth',lw)
plot(MR.SemiconductorParameters.eoffx(1,istart:iend),MR.SemiconductorParameters.eoffx(2,istart:iend),'Color','#1f77b4','LineWidth',lw)
plot(MR.SemiconductorParameters.errx(1,istart:iend),MR.SemiconductorParameters.errx(2,istart:iend),'Color','#2ca02c','LineWidth',lw)
ylabel('Energy [mJ]')
xlabel('Current [A]')
grid on
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('E_{on}','E_{off}','E_{rr}')

subplot(1,2,2)
hold on
plot(HR.Input.t(1:size(HR.Input.t,2)/2)*1000,HR.Current.Turn_on(1:size(HR.Input.t,2)/2),'Color','#1f77b4','LineWidth',lw)
plot(HR.Input.t(1:size(HR.Input.t,2)/2)*1000,HR.Current.Turn_off(1:size(HR.Input.t,2)/2),'Color','#2ca02c','LineWidth',lw)
plot(LR.Input.t(1:size(HR.Input.t,2)/2)*1000,LR.Current.Turn_on(1:size(HR.Input.t,2)/2),'--','Color','#1f77b4','LineWidth',lw)
plot(LR.Input.t(1:size(HR.Input.t,2)/2)*1000,LR.Current.Turn_off(1:size(HR.Input.t,2)/2),'--','Color','#2ca02c','LineWidth',lw)
xlabel('Time [ms]')
ylabel('Current [A]')
grid on
box on
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('Turn off','Turn on')


% figure;
% hold on
% plot(MC.SemiconductorParameters.eonx(1,:),MC.SemiconductorParameters.eonx(2,:))
% plot(MC.SemiconductorParameters.eoffx(1,:),MC.SemiconductorParameters.eoffx(2,:))
% plot(MC.SemiconductorParameters.errx(1,:),MC.SemiconductorParameters.errx(2,:))

% %%
% 
% figure;
% hold on
% plot(LR.Current.i_converter_side)
% plot(LR.Current.Turn_on)
% plot(LR.Current.Turn_off)
% 
% 
% figure;
% hold on
% plot(HR.Current.i_converter_side)
% plot(HR.Current.Turn_on)
% plot(HR.Current.Turn_off)

% other colors: purple 9467bd lime bcbd22 red d62728 orange ff7f0e
% marine 17becf blue 1f77b4 green 2ca02c

%%
LR.bar = 3*[LR.Losses.Pc_tot LR.Losses.Ps_tot LR.Inductor.Lc_Design.Total_Loss LR.Inductor.Lg_Design.Total_Loss] ;
MR.bar = 3*[MR.Losses.Pc_tot MR.Losses.Ps_tot MR.Inductor.Lc_Design.Total_Loss MR.Inductor.Lg_Design.Total_Loss] ;
HR.bar = 3*[HR.Losses.Pc_tot HR.Losses.Ps_tot HR.Inductor.Lc_Design.Total_Loss HR.Inductor.Lg_Design.Total_Loss] ;

LR.bar2 = 3*[LR.Losses.Pc_tot LR.Losses.Ps_tot LR.Inductor.Lc_Design.Total_Loss ...
    LR.Inductor.Lg_Design.Total_Loss LR.AC_Cap.FinalDesign(8)] ;
MR.bar2 = 3*[MR.Losses.Pc_tot MR.Losses.Ps_tot MR.Inductor.Lc_Design.Total_Loss ...
    MR.Inductor.Lg_Design.Total_Loss MR.AC_Cap.FinalDesign(8)] ;
HR.bar2 = 3*[HR.Losses.Pc_tot HR.Losses.Ps_tot HR.Inductor.Lc_Design.Total_Loss ...
    HR.Inductor.Lg_Design.Total_Loss HR.AC_Cap.FinalDesign(8)] ;

br = [LR.bar ; MR.bar ; HR.bar];
br2 = [LR.bar2 ; MR.bar2 ; HR.bar2];
% 
% figure;
% subplot(1,2,1)
% b = bar(br,0.5,'stacked', 'FaceColor','flat');
% b(1).CData = hex2rgb('#ff7f0e');
% b(2).CData = hex2rgb('#2ca02c');
% b(3).CData = hex2rgb('#1f77b4');
% b(4).CData = hex2rgb('#9467bd');
% ylabel('Losses [kW]')
% xlabel('Peak Ripple Current [%]')
% set(gca, 'XTickLabel', {'9' '42' '76'})
% box on
% grid on 
% ax = gca;
% ax.GridLineStyle = ':';
% ax.GridAlpha = 0.5;
% legend('Conduction','Switching','Lc','Lg')

figure;
subplot(1,2,1)
b = bar(br2,0.5,'stacked', 'FaceColor','flat');
b(1).CData = hex2rgb('#ff7f0e');
b(2).CData = hex2rgb('#2ca02c');
b(3).CData = hex2rgb('#1f77b4');
b(4).CData = hex2rgb('#9467bd');
b(5).CData = hex2rgb('#bcbd22');
ylabel('Losses [kW]')
xlabel('Peak Ripple Current [%]')
set(gca, 'XTickLabel', {'9' '42' '76'})
box on
grid on 
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('Conduction','Switching','Lc','Lg','C')

subplot(1,2,2)
hold on
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RLR.Converter.Efficiency,'Color','#ff7f0e','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RMR.Converter.Efficiency,'Color','#2ca02c','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RHR.Converter.Efficiency,'Color','#1f77b4','LineWidth',lw)
box on
grid on
xlabel('Output Power [%]')
ylabel('Efficiency [%]')
% ylim([94 99])
% yticks([94 95 96 97 98 99]) ;
% yticklabels({'94','95','96','97','98','99'})
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('9','42','76')
xlim([10 100])
%%
figure;
subplot(1,3,1)
b = bar(br,0.5,'stacked', 'FaceColor','flat');
b(1).CData = hex2rgb('#ff7f0e');
b(2).CData = hex2rgb('#2ca02c');
b(3).CData = hex2rgb('#1f77b4');
b(4).CData = hex2rgb('#9467bd');
ylabel('Losses [kW]')
xlabel('Peak Ripple Current [%]')
set(gca, 'XTickLabel', {'9%' '42%' '76%'})
box on
grid on 
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('Conduction','Switching','Lc','Lg')

subplot(1,3,2)
hold on
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RHR.Converter.Efficiency,'Color','#ff7f0e','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RMR.Converter.Efficiency,'Color','#2ca02c','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RLR.Converter.Efficiency,'Color','#1f77b4','LineWidth',lw)
box on
grid on
xlabel('Output Power [%]')
ylabel('Efficiency [%]')
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('Ripple = 76%','Ripple = 42%','Ripple = 9%')

subplot(1,3,3)
hold on
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RHR.Inductor.Losses,'Color','#ff7f0e','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RMR.Inductor.Losses,'Color','#2ca02c','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RLR.Inductor.Losses,'Color','#1f77b4','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RHR.Semiconductor.Losses,'--','Color','#ff7f0e','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RMR.Semiconductor.Losses,'--','Color','#2ca02c','LineWidth',lw)
plot(MR.Input.P_range(2:end)/MR.Input.Pmax*100,RLR.Semiconductor.Losses,'--','Color','#1f77b4','LineWidth',lw)
box on
grid on
xlabel('Output Power [%]')
ylabel('Losses [kW]')
ax = gca;
ax.GridLineStyle = ':';
ax.GridAlpha = 0.5;
legend('76%','42%','9%')



% other colors: purple 9467bd lime bcbd22 red d62728 orange ff7f0e
% marine 17becf blue 1f77b4 green 2ca02c

%%
% for x=1:3
%     for y = 1:size(LR.bar,2)
%         if x==1
%             stackData(x,y,:)=HR.bar(y) ; 
%         elseif x==2
%             stackData(x,y,:)=MR.bar(y) ; 
%         else
%             stackData(x,y,:)=LR.bar(y) ; 
%         end
%     end
% end
% 
% stackData()
% groupLabels = {'HR','MR','LR'} ;
% colors = [1 0 0 ; 0 1 0; 0 0 1] ;
% plotBarStackGroups(stackData, groupLabels , colors);