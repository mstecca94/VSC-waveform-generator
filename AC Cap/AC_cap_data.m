function [ AC_Cap ] = AC_cap_data ( Wave ) 

% B3237X Series

% fot = fast on terminal
% M6 - M6 screw terminals
% M10 - M10 screw terminals
% ct - clampt terminals

ac_cap_fot= [30  15  0.17
    40 15 0.17 
    50  15  0.19 
    60  15  0.19 
    70  15  0.30
    75  15 0.30 
    80  15 0.30 
    100  15 0.30 
    120  15  0.33 
    140  15 0.35
    150  15  0.35 
    160  15 0.45 ];

ac_cap_M6 = [
    50  23 0.28 
    60  24 0.28 
    70  25  0.28 
    75  25.5  0.28 
    80  26  0.31 
    100  27.5  0.31 
    130  28  0.40
    150  30 0.48
    200  30 0.48 ];

ac_cap_M10 = [150  41.5 0.65
    200  45   0.65
    250  45   0.75
    300  60   0.95
    330  60   1.05
    400  60   1.25
    500  60   1.30
    600  60   1.55];

ac_cap_ct = [100  38 0.55
    120  40 0.55
    150  42.5  0.60
    200  44.5 0.65
    250  45  0.75
    300  46  0.80
    330  47.5  1.05
    400  50  1.05 
    500  50 1.55
    ];

ac_cap_cost = [
    200  30    0.48 28.69430
    100  27.5  0.31 24.26483
    150  30    0.48 28.58817
    200  45   0.65 31.69690
    300  60   0.95 53.74867
    600  60   1.55 64.73400];

ac_cap_cost_fit=fit(ac_cap_cost(:,1),ac_cap_cost(:,4),'poly1');%,'Lower',[-Inf,0],'Upper',[Inf,0]);

capacitance=50:600 ; 

ac_p1 = ac_cap_cost_fit.p1;
ac_p2 = ac_cap_cost_fit.p2;
ac_cap_cost_fit_function = ac_p1*capacitance + ac_p2 ;

all_ac = sortrows([ac_cap_fot ; ac_cap_M6 ; ac_cap_M10 ; ac_cap_ct ] ) ;

%% linear regression

y = all_ac(:,3);

% no q factor
x_f = all_ac(:,1);
x_c = all_ac(:,2);
b_f = x_f\y ;
b_c = x_c\y ;
y1_f = x_f*b_f ;
y1_c = x_c*b_c ;

rsq_f = 1 - sum((y - y1_f).^2)/sum((y - mean(y)).^2);
rsq_c = 1 - sum((y - y1_c).^2)/sum((y - mean(y)).^2);

% yes q fatcor

X_f = [ones(length(x_f),1) x_f];
X_c = [ones(length(x_c),1) x_c];
B_f = X_f\y ;
B_c = X_c\y ;

Y1_f = X_f*B_f ;
Y1_c = X_c*B_c ;

RSQ_f = 1 - sum((y - y1_f).^2)/sum((y - mean(y)).^2);
RSQ_c = 1 - sum((y - y1_c).^2)/sum((y - mean(y)).^2);

%% plot

if Wave.Input.plot_AC_cost_interpolation == 1 
    figure;
    hold on
    scatter(ac_cap_fot(:,1),ac_cap_fot(:,3),[],'filled')
    scatter(ac_cap_M6(:,1),ac_cap_M6(:,3),[],'filled')
    scatter(ac_cap_M10(:,1),ac_cap_M10(:,3),[],'filled')
    scatter(ac_cap_ct(:,1),ac_cap_ct(:,3),[],'filled')
    plot(x_f,y1_f)
    plot(x_f,Y1_f,'--')
    xlabel('Capacitance [\muF]')
    ylabel('Weight [kg]')
    grid on
    
    figure;
    hold on
    scatter(ac_cap_cost(:,1),ac_cap_cost(:,4))
    plot(capacitance,ac_cap_cost_fit_function)
    xlabel('Capacitance [\muF]')
    ylabel('Cost [$]')
    grid on
end
% % figure;
% % hold on
% % scatter(all_ac(:,1),all_ac(:,3),[],'filled')
% % xlabel('Capacitance [\u F]')
% % ylabel('Weight [kg]')
% % grid on 
% 
% 
% figure;
% hold on
% scatter(ac_cap_fot(:,2),ac_cap_fot(:,3),[],'filled')
% scatter(ac_cap_M6(:,2),ac_cap_M6(:,3),[],'filled')
% scatter(ac_cap_M10(:,2),ac_cap_M10(:,3),[],'filled')
% scatter(ac_cap_ct(:,2),ac_cap_ct(:,3),[],'filled')
% plot(x_c,y1_c)
% plot(x_c,Y1_c,'--')
% xlabel('Current [A]')
% ylabel('Weight [kg]')
% grid on

%%

% cost factors
AC_Cap.ac_p1 = ac_p1 ;
AC_Cap.ac_p2 = ac_p2 ;

% weight factors
AC_Cap.B_f = B_f ;
AC_Cap.B_c = B_c ;
AC_Cap.b_f = b_f ;
AC_Cap.b_c = b_c ;
AC_Cap.all_ac = all_ac ;

end