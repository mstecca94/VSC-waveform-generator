function [ Wave ] = DC_capacitors_data ( Wave )

fileID = fopen('capacitors_500C_CD2.txt') ; 
cap = textscan(fileID,'%f %f %f %f %f %f %f','Delimiter',',','CommentStyle','//','CollectOutput',true);
%% from personal PC
cap = cell2table(cap);
cap = cap.cap{1,1};
%% from Work 
% cap = table2array(cap);
%%
cap = sortrows(cap,1);

ESR_vs_f_data = [10.099313310222355, 6.433550350871315
13.719524380481175, 4.837900750880528
23.860657312836672, 2.844080263186878
42.32621581966674, 1.7383524045183123
66.0301812311646, 1.2253009247769895
89.69943335965363, 0.9579667161928321
160.69730140046408, 0.6247701102697676
293.6372572186785, 0.47610788481080124
736.1270719115215, 0.36768765988940477
1809.3006100086536, 0.32328167803409436
5056.647279003488, 0.30332975153674185
10403.210399941043, 0.32391946231300384
27673.244858866972, 0.35510142485017204
75082.11203591626, 0.37443466635340017
180930.0610008652, 0.3422707796297244
490893.3224135209, 0.33388018277045933];

f_range = 10:10:100000;
f_range2 = Wave.FFT.f;
ESR_vs_f =[ f_range ; pchip(ESR_vs_f_data(:,1),ESR_vs_f_data(:,2),f_range)];
ESR_vs_f2 =[ f_range2 ; pchip(ESR_vs_f_data(:,1),ESR_vs_f_data(:,2),f_range2)];

Wave.DClink.ESR_vs_f2 = ESR_vs_f2 ;
Wave.DClink.ESR_vs_f = ESR_vs_f ;
Wave.DClink.CapacitorsDatasheet = cap ;
%%

if Wave.Input.plot_ESR_vs_f == 1
    figure;
    A = imread ('ESR_vs_f.PNG') ;
    subplot(1,2,1)
    title('ESR vs f')
    hold on
    scatter(ESR_vs_f_data(:,1),ESR_vs_f_data(:,2))
    plot(ESR_vs_f(1,:),ESR_vs_f(2,:))
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    xlabel('Frequency [Hz]')
    ylabel('Ratio to 120Hz Value')
    grid on

    subplot(1,2,2)
    image(A)
    xticks([])
    yticks([])
end

end