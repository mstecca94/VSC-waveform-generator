function [ Wave ] = semiconductor_data ( Wave )
%% here I can add different switches and switch to compare them
topology =  Wave.Input.Topology  ; 

switch Wave.Input.Application
    case 'Motor Drive'
    switch topology
        case 'Two Level - SiC' % Cree CAS300M12BM2 Module 
            %%%%%%%%% datasheet data
            if Wave.Input.Exp == 1 
                %% IGBT parameters
                Wave.SemiconductorParameters.U__Bt = 600;
                Wave.SemiconductorParameters.rt = 0.17;
                Wave.SemiconductorParameters.Vt = 0.0;
                %% Diode parameters
                Wave.SemiconductorParameters.U__Bd = 600;
                Wave.SemiconductorParameters.rd = 0.17;
                Wave.SemiconductorParameters.Vd = 0.0;
                %% Switching functions 

                % E reverse recovery - in the eon
                err= [ 0 ,0 ];
                % E turn on
                eon = [0, 0 
                    0.01, 0.000015
                    3, 0.000051
                    6, 0.000083611
                    9, 0.0001121
                    12, 0.000153514
                    15, 0.0001895
                ];
                % E turn off
%                 eoff = [0, 0
%                     0.1, 0.000015
%                     3, 0.000025
%                     6, 0.000035
%                     9, 0.00005
%                     12, 0.00008623
%                     15, 0.0001172
%                 ];
                
                eoff = [0, 0
                    0.01, 0.000015
                    3, 0.000025
                    6, 0.000035
                    9, 0.00005
                    12, 0.00008623
                    15, 0.0001172
                ];


                Wave.SemiconductorParameters.eon=sort(eon);
                Wave.SemiconductorParameters.eoff=sort(eoff);
                Wave.SemiconductorParameters.err=sort(err);

                eonx= [0:0.1:25 ; pchip(eon(:,1),eon(:,2),0:0.1:25)];
                eoffx= [0:0.1:25 ; pchip(eoff(:,1),eoff(:,2),0:0.1:25)];
                errx=[0:0.1:25  ; (0:0.1:25)*0];

                Wave.SemiconductorParameters.eonx=eonx;
                Wave.SemiconductorParameters.eoffx=eoffx;
                Wave.SemiconductorParameters.errx=errx;

                Wave.SemiconductorParameters.cost = 3*6.36*3 ;
                Wave.SemiconductorParameters.Module = '3x Cree C3M0120090J' ;
                Wave.SemiconductorParameters.weight = 3*0.015*3 ;
            else
                %%%%%%%%% datasheet data
                %% IGBT parameters
                Wave.SemiconductorParameters.U__Bt = 600;
                Wave.SemiconductorParameters.rt = 0.17;
                Wave.SemiconductorParameters.Vt = 0.0;
                %% Diode parameters
                Wave.SemiconductorParameters.U__Bd = 600;
                Wave.SemiconductorParameters.rd = 0.17;
                Wave.SemiconductorParameters.Vd = 0.0;

                %% Switching functions 

                % E reverse recovery - in the eon
                err= [ 0 ,0 ];
                % E turn off
                eoff=[0.1, 0.000009
                    1.1764705882352935, 0.000009355021751465844
                    2.593582887700535, 0.00001035610502605016
                    3.9572192513368973, 0.00001071272589714048
                    5.802139037433155, 0.000013010987499355168
                    8.074866310160427, 0.000014998710387399602
                    9.62566844919786, 0.000017289406262358773
                    11.443850267379677, 0.000019908523479546724
                    13.315508021390372, 0.00002381518991694895
                    14.839572192513366, 0.000027069828223601634
                    16.310160427807485, 0.000030644634351840696
                    17.593582887700528, 0.000033893082518011584
                    19.278074866310156, 0.00003811647781006586
                    20.534759358288767, 0.000042007324999570136
                    22.21925133689839, 0.00004751689392506488
                    23.20855614973262, 0.00005043623295562013
                    0, 0
                    ];


                % E turn on
                eon=[0.1, 0.00004
                    1.6844919786096249, 0.00004345169111198997
                    2.7272727272727266, 0.00004669394913767901
                    4.25133689839572, 0.000051556304486132345
                    5.748663101604278, 0.00005577488522447854
                    7.941176470588235, 0.00006386986949120482
                    9.786096256684491, 0.00007034819540210118
                    11.764705882352938, 0.00007875922073009267
                    12.967914438502671, 0.00008522103959970423
                    14.545454545454543, 0.00009201403098509206
                    16.55080213903743, 0.00010171191773991092
                    18.021390374331546, 0.00010978833158519181
                    19.57219251336898, 0.0001191529824440738
                    21.042780748663098, 0.00012787248310607493
                    22.21925133689839, 0.00013497670099901988
                    23.235294117647058, 0.00014175524872328353
                    0, 0 
                    ];

                Wave.SemiconductorParameters.eon=sort(eon);
                Wave.SemiconductorParameters.eoff=sort(eoff);
                Wave.SemiconductorParameters.err=sort(err);

                eonx= [0:0.1:25 ; pchip(eon(:,1),eon(:,2),0:0.1:25)];
                eoffx= [0:0.1:25 ; pchip(eoff(:,1),eoff(:,2),0:0.1:25)];
                errx=[0:0.1:25  ; (0:0.1:25)*0];

                Wave.SemiconductorParameters.eonx=eonx;
                Wave.SemiconductorParameters.eoffx=eoffx;
                Wave.SemiconductorParameters.errx=errx;

                Wave.SemiconductorParameters.cost = 3*6.36*3 ;
                Wave.SemiconductorParameters.Module = '3x Cree C3M0120090J' ;
                Wave.SemiconductorParameters.weight = 3*0.015*3 ;
            end
        case 'Two Level' % Infineon FF300R12KE4 Module 

            %% IGBT parameters
            Wave.SemiconductorParameters.U__Bt = 600;
            Wave.SemiconductorParameters.rt = 0.0043;
            Wave.SemiconductorParameters.Vt = 0.8391608391608392;
            %% Diode parameters
            Wave.SemiconductorParameters.U__Bd = 600;
            Wave.SemiconductorParameters.rd = 0.0030;
            Wave.SemiconductorParameters.Vd = 0.7736254773291813;

            %% Switching functions 

            % E reverse recovery
            err=[
            0, 0
            ];

            % E turn off
            eoff=[
            0, 0
            ];


            % E turn on
            eon=[
            0, 0 
            ];
            Wave.SemiconductorParameters.eon=sort(eon);
            Wave.SemiconductorParameters.eoff=sort(eoff);
            Wave.SemiconductorParameters.err=sort(err);

            eonx= [0:0.1:25 ; pchip(eon(:,1),eon(:,2),0:0.1:25)];
            eoffx=[0:0.1:25  ; pchip(eoff(:,1),eoff(:,2),0:0.1:25)];
            errx= [0:0.1:25 ; pchip(err(:,1),err(:,2),0:0.1:25)];

            Wave.SemiconductorParameters.eonx=eonx;
            Wave.SemiconductorParameters.eoffx=eoffx;
            Wave.SemiconductorParameters.errx=errx;

            Wave.SemiconductorParameters.cost = (6.03+2*3.1)*3 ;
            Wave.SemiconductorParameters.weight = 3*0.015*3 ;
            Wave.SemiconductorParameters.Module = '2x IGBT IXYS IXGA30N120B3 / 1x SiC Schottky diode Infineon IDK20G120C5' ;

    end

    case 'Grid Connected'
    %%%%%%%%%%%%%%%%%%%%%%%%
    switch topology
        case 'Two Level - SiC' % Cree CAS300M12BM2 Module 

            %% IGBT parameters
            Wave.SemiconductorParameters.U__Bt = 600;
            Wave.SemiconductorParameters.rt = 0.0077;
            Wave.SemiconductorParameters.Vt = 0.0;
            %% Diode parameters
            Wave.SemiconductorParameters.U__Bd = 600;
            Wave.SemiconductorParameters.rd = 0.0077;
            Wave.SemiconductorParameters.Vd = 0.0;

            %% Switching functions 

            % E reverse recovery - in the eon
            err= [ 0 ,0 ];
            % E turn off
            eoff=[51.735168827971265, 0.0007018160027662777
                85.24441177695266, 0.0009712021174327935
                116.28274317618536, 0.0015046880063436102
                156.68169894291293, 0.0022048384497987752
                188.70252929664514, 0.002870700096131742
                226.13769468487433, 0.0038348778982089833
                259.6282000916058, 0.004864591838397301
                286.7177981305907, 0.005628902523141318
                318.2384175738232, 0.006592211337751895
                348.77735273830615, 0.007390086663395894
                375.3699985697915, 0.008319613590239826
                399.9952024650278, 0.009083562196872733
                0, 0
                ];


            % E turn on
            eon=[51.208888293471546, 0.0020571105804655238
                63.524341606214705, 0.0023233828233764874
                108.3600215074398, 0.0029911272758872294
                139.89123173542228, 0.0035246855804202636
                166.4993564061575, 0.003826115607920101
                215.2748082343804, 0.004626670311586319
                249.7641061106112, 0.0051276053783082635
                297.0592921010849, 0.0059940582981966705
                329.5738159593169, 0.006626934628607431
                366.5275079792964, 0.007128231773440486
                400.03267754952776, 0.007562906545829133
                0, 0 
                ];

            Wave.SemiconductorParameters.eon=sort(eon);
            Wave.SemiconductorParameters.eoff=sort(eoff);
            Wave.SemiconductorParameters.err=sort(err);

            eonx= [0:0.1:600 ; pchip(eon(:,1),eon(:,2),0:0.1:600)];
            eoffx= [0:0.1:600 ; pchip(eoff(:,1),eoff(:,2),0:0.1:600)];
            errx=[0:0.1:600  ; (0:0.1:600)*0];

            Wave.SemiconductorParameters.eonx=eonx;
            Wave.SemiconductorParameters.eoffx=eoffx;
            Wave.SemiconductorParameters.errx=errx;

            Wave.SemiconductorParameters.cost = 580.52*3 ;
            Wave.SemiconductorParameters.Module = 'Cree CAS300M12BM2' ;
            Wave.SemiconductorParameters.weight = 0.3*3 ;

        case 'Two Level' % Infineon FF300R12KE4 Module 

            %% IGBT parameters
            Wave.SemiconductorParameters.U__Bt = 600;
            Wave.SemiconductorParameters.rt = 0.0043;
            Wave.SemiconductorParameters.Vt = 0.8391608391608392;
            %% Diode parameters
            Wave.SemiconductorParameters.U__Bd = 600;
            Wave.SemiconductorParameters.rd = 0.0030;
            Wave.SemiconductorParameters.Vd = 0.7736254773291813;

            %% Switching functions 

            % E reverse recovery
            err=[581.3343108504398, 0.03340175953079179
            496.3812316715543, 0.03246334310850439
            395.47800586510266, 0.030527859237536654
            338.54545454545456, 0.02917888563049853
            256.7008797653959, 0.026070381231671554
            189.88269794721407, 0.022434017595307918
            130.07624633431087, 0.018563049853372433
            87.24926686217009, 0.015102639296187687
            54.419354838709694, 0.011700879765395897
            0, 0
            ];

            % E turn off
            eoff=[591.8498715186751, 0.06758052794144366
            560.1422379110752, 0.06478041373582163
            511.6152308770471, 0.0601118695979443
            439.33085887818925, 0.052991668180756346
            369.04768084719797, 0.045753497547174705
            279.98286915669524, 0.0361789134892413
            203.78955018558412, 0.0278883640044644
            138.48210345991123, 0.02076543722584162
            86.07729644145665, 0.014457782853583206
            39.65271108573215, 0.00814779245723779
            0, 0
            ];


            % E turn on
            eon=[591.6240558569314, 0.07097905365068652
            557.1754873205803, 0.06443001012277104
            497.1630285254496, 0.052617514989487885
            442.81153476782515, 0.04560749604173696
            379.5208555039322, 0.03813221896332442
            276.5333402548862, 0.028094323461468576
            173.4835310301866, 0.018993952293196975
            113.05837464635191, 0.013392555869909409
            37.76053157525892, 0.006625094089859063
            0, 0 
            ];

    %         RjcT = 0.093 ;
    %         RjcD = 0.15 ;
    %         Rcs = 0.05 ;
    %         weight = 0.340 ;

            Wave.SemiconductorParameters.eon=sort(eon);
            Wave.SemiconductorParameters.eoff=sort(eoff);
            Wave.SemiconductorParameters.err=sort(err);

            eonx= [0:0.1:600 ; pchip(eon(:,1),eon(:,2),0:0.1:600)];
            eoffx=[0:0.1:600  ; pchip(eoff(:,1),eoff(:,2),0:0.1:600)];
            errx= [0:0.1:600 ; pchip(err(:,1),err(:,2),0:0.1:600)];

            Wave.SemiconductorParameters.eonx=eonx;
            Wave.SemiconductorParameters.eoffx=eoffx;
            Wave.SemiconductorParameters.errx=errx;
    %         Wave.SemiconductorParameters.RjcT = RjcT;
    %         Wave.SemiconductorParameters.RjcD = RjcD;
    %         Wave.SemiconductorParameters.Rcs = Rcs;        
    %         Wave.SemiconductorParameters.weight = weight ;
            Wave.SemiconductorParameters.cost = 118.3*3 ;
            Wave.SemiconductorParameters.weight = 0.34*3 ;
            Wave.SemiconductorParameters.Module = 'Infineon FF300R12KE4' ;

        case 'Three Level NPC' % Semikron 'SEMiX305MLI07E4_NPCC_650V'
            %% Diode 1  and Switch 2
            % IGBT parameters

            Wave.SemiconductorParameters.U__Bt2 = 300;

            Wave.SemiconductorParameters.rt2 = 0.0038;
            Wave.SemiconductorParameters.Vt2 = 0.735;

            % Diode parameters

            Wave.SemiconductorParameters.U__Bd1 = 300;

            Wave.SemiconductorParameters.rd1 = 0.0024;
            Wave.SemiconductorParameters.Vd1 = 0.97;

            % E reverse recovery
            err_d1=[54.463641826923094, 0.004230769230769229
            141.80438701923075, 0.005865384615384616
            256.32361778846143, 0.007403846153846153
            358.63731971153845, 0.00875
            459.0715144230769, 0.010048076923076923
            538.8762019230769, 0.011298076923076921
            0, 0
            ];

            % E turn off
            eoff_t2=[55.401141826923094, 0.004230769230769229
            128.82812500000003, 0.007451923076923075
            203.12499999999997, 0.009951923076923077
            279.29236778846155, 0.012403846153846154
            346.0712139423076, 0.014711538461538463
            413.8100961538462, 0.017259615384615387
            475.01352163461524, 0.020096153846153847
            523.0784254807692, 0.022788461538461542
            552.2896634615383, 0.024375000000000004
            0, 0
            ];


            % E turn on
            eon_t2=[51.371694711538424, 0.0012499999999999976
            136.74729567307693, 0.0019230769230769197
            241.8194110576923, 0.0026923076923076883
            339.4050480769231, 0.0036057692307692284
            453.0048076923075, 0.005336538461538462
            535.5679086538461, 0.006009615384615384
            0, 0 
            ];

            %% Diode 5  and Switch 1
            % IGBT parameters

            Wave.SemiconductorParameters.U__Bt1 = 300;

            Wave.SemiconductorParameters.rt1 = 0.0038;
            Wave.SemiconductorParameters.Vt1 = 0.735;

            % Diode parameters

            Wave.SemiconductorParameters.U__Bd5 = 300;

            Wave.SemiconductorParameters.rd5 = 0.0025;
            Wave.SemiconductorParameters.Vd5 = 1;

            % E reverse recovery
            err_d5=[53.58009447371825, 0.002167152435785153
            128.04060359804163, 0.0029769271633476417
            240.15994486640153, 0.004027337075909198
            348.5577682378786, 0.004795474450458723
            452.31661617539385, 0.005281195709916864
            546.8492009935534, 0.005483782968886838
            0, 0
            ];

            % E turn off
            eoff_t1=[53.17951442231765, 0.004983991155651912
            127.2652873695244, 0.00875145371792847
            191.9783485764333, 0.011437637295582132
            261.2614682192135, 0.014030639348734362
            314.87889273356404, 0.01624560295194475
            381.4699421384371, 0.019166822208502632
            433.3213685767205, 0.021757096297147116
            478.7161337564072, 0.024158566526439718
            524.1970451837069, 0.02702953380522333
            552.9828138236013, 0.028911972892647412
            0, 0
            ];

            % E turn on
            eon_t1=[55.22548780312712, 0.0011345460810636178
            149.8097603698546, 0.0016188315697282032
            249.00716449625986, 0.0022446840586368734
            372.16184008384903, 0.003437666010998
            489.82899969848813, 0.004723685910781199
            548.6496575686658, 0.005296271303249143
            0, 0 
            ];            
            RjcT1 = 0.15 ;
            RjcT2 = 0.16 ;
            RjcD1 = 0.25 ;
            RjcD2 = 0.29 ;
            RjcD5 = 0.31 ;
            RcsT1 = 0.031;      
            RcsT2 = 0.035;      
            RcsD1 = 0.043;      
            RcsD2 = 0.039;  
            RcsD5 = 0.049;  
            weight = 0.398 ;

            Wave.SemiconductorParameters.eon_t1=sort(eon_t1);
            Wave.SemiconductorParameters.eon_t2=sort(eon_t2);
            Wave.SemiconductorParameters.eoff_t1=sort(eoff_t1);
            Wave.SemiconductorParameters.eoff_t2=sort(eoff_t2);

            Wave.SemiconductorParameters.err_d5=sort(err_d5);
            Wave.SemiconductorParameters.err_d1=sort(err_d1);

            eon_t1x= [0:0.1:600; pchip(eon_t1(:,1),eon_t1(:,2),0:0.1:600)];
            eon_t2x= [0:0.1:600 ; pchip(eon_t2(:,1),eon_t2(:,2),0:0.1:600)];

            eoff_t1x= [0:0.1:600 ; pchip(eoff_t1(:,1),eoff_t1(:,2),0:0.1:600)];
            eoff_t2x= [0:0.1:600 ; pchip(eoff_t2(:,1),eoff_t2(:,2),0:0.1:600)];

            err_d5x= [0:0.1:600 ; pchip(err_d5(:,1),err_d5(:,2),0:0.1:600)];
            err_d1x= [0:0.1:600 ; pchip(err_d1(:,1),err_d1(:,2),0:0.1:600)];

            Wave.SemiconductorParameters.eon_t1x=eon_t1x;
            Wave.SemiconductorParameters.eon_t2x=eon_t2x;

            Wave.SemiconductorParameters.eoff_t1x=eoff_t1x;
            Wave.SemiconductorParameters.eoff_t2x=eoff_t2x;

            Wave.SemiconductorParameters.err_d5x=err_d5x;
            Wave.SemiconductorParameters.err_d1x=err_d1x;

            Wave.SemiconductorParameters.RjcT1 = RjcT1;
            Wave.SemiconductorParameters.RjcT2 = RjcT2;
            Wave.SemiconductorParameters.RjcD1 = RjcD1;
            Wave.SemiconductorParameters.RjcD2 = RjcD2;
            Wave.SemiconductorParameters.RjcD5 = RjcD5;
            Wave.SemiconductorParameters.RcsT1 = RcsT1;
            Wave.SemiconductorParameters.RcsT2 = RcsT2;      
            Wave.SemiconductorParameters.RcsD1 = RcsD1;      
            Wave.SemiconductorParameters.RcsD2 = RcsD2;    
            Wave.SemiconductorParameters.RcsD5 = RcsD5;    
            Wave.SemiconductorParameters.weight = weight ;
            Wave.SemiconductorParameters.cost = 187.43*3 ;
            Wave.SemiconductorParameters.Module = 'Semikron SEMiX305MLI07E4' ;
            Wave.SemiconductorParameters.weight = 0.398*3 ;

        case 'Three Level TTYPE' % Semikron 'SEMiX305TMLI12E4B'
            %% Diode 1  and Switch 2
            % IGBT parameters
            Wave.SemiconductorParameters.U__Bt2 = 300;
            Wave.SemiconductorParameters.rt2 = 0.0041;
            Wave.SemiconductorParameters.Vt2 = 0.7;

            % Diode parameters
            Wave.SemiconductorParameters.U__Bd1 = 300;
            Wave.SemiconductorParameters.rd1 = 0.0028;
            Wave.SemiconductorParameters.Vd1 = 1.4;

            % E reverse recovery
            err_d1=[103.7037037037037, 0.0073947368421052664
            186.41975308641975, 0.007789473684210527
            281.48148148148147, 0.00810526315789474
            353.08641975308643, 0.008342105263157894
            458.02469135802465, 0.008421052631578954
            570.3703703703704, 0.008421052631578954
            658.0246913580247, 0.008578947368421054
            698.7654320987654, 0.008421052631578954
            0, 0
            ];

            % E turn off
            eoff_t2=[101.23456790123453, 0.009605263157894735
            162.962962962963, 0.011894736842105263
            237.037037037037, 0.014500000000000006
            318.51851851851853, 0.01813157894736843
            411.11111111111114, 0.023026315789473686
            483.95061728395063, 0.026500000000000006
            564.1975308641975, 0.029342105263157895
            648.148148148148, 0.03202631578947369
            696.2962962962961, 0.03352631578947368
            0, 0
            ];


            % E turn on
            eon_t2=[103.7037037037037, 0.0017105263157894748
            164.19753086419752, 0.0018684210526315817
            243.20987654320987, 0.0020263157894736886
            322.2222222222221, 0.0025000000000000022
            407.40740740740733, 0.0030526315789473693
            480.2469135802468, 0.0036052631578947364
            574.0740740740741, 0.0041578947368421035
            656.7901234567901, 0.004631578947368424
            696.2962962962961, 0.004868421052631584
            0, 0 
            ];

            %% Diode 2  and Switch 1
            % IGBT parameters
            Wave.SemiconductorParameters.U__Bt1 = 300;
            Wave.SemiconductorParameters.rt1 = 0.0056;
            Wave.SemiconductorParameters.Vt1 = 0.8;

            % Diode parameters
            Wave.SemiconductorParameters.U__Bd2 = 300;
            Wave.SemiconductorParameters.rd2 = 0.0016;
            Wave.SemiconductorParameters.Vd2 = 1.15;

            % E reverse recovery
            err_d2=[0.3076923076923208, 0
            102.46153846153845, 0.006888888888888889
            180, 0.007555555555555565
            279.6923076923076, 0.007888888888888904
            364.6153846153845, 0.007777777777777786
            476.6153846153845, 0.008222222222222228
            555.3846153846152, 0.008222222222222228
            625.5384615384614, 0.00811111111111111
            696.9230769230768, 0.00811111111111111
            ];

            % E turn off
            eoff_t1=[1.5384615384615472, 0
            103.69230769230768, 0.01122222222222223
            176.30769230769226, 0.014888888888888889
            253.8461538461538, 0.018888888888888893
            330.1538461538461, 0.022333333333333344
            428.6153846153845, 0.02655555555555556
            506.1538461538461, 0.030888888888888896
            572.6153846153844, 0.0348888888888889
            635.3846153846152, 0.03955555555555556
            696.9230769230768, 0.044111111111111115
            ];

            % E turn on
            eon_t1=[103.69230769230768, 0.002555555555555561
            162.76923076923072, 0.002888888888888899
            0.3076923076923208, -0.0001111111111111035
            225.5384615384615, 0.003555555555555562
            316.6153846153845, 0.0050000000000000044
            407.6923076923076, 0.007444444444444448
            465.53846153846143, 0.009222222222222229
            528.3076923076922, 0.010666666666666672
            598.4615384615383, 0.012444444444444452
            647.6923076923076, 0.013666666666666674
            696.9230769230768, 0.014666666666666675
            ];  

            RjcT1 = 0.09 ;
            RjcT2 = 0.17 ;
            RjcD1 = 0.16 ;
            RjcD2 = 0.22 ;
            RcsT1 = 0.021;      
            RcsT2 = 0.059;      
            RcsD1 = 0.041;      
            RcsD2 = 0.059;    
            weight = 0.398 ; 

            Wave.SemiconductorParameters.eon_t1=sort(eon_t1);
            Wave.SemiconductorParameters.eon_t2=sort(eon_t2);
            Wave.SemiconductorParameters.eoff_t1=sort(eoff_t1);
            Wave.SemiconductorParameters.eoff_t2=sort(eoff_t2);

            Wave.SemiconductorParameters.err_d2=sort(err_d2);
            Wave.SemiconductorParameters.err_d1=sort(err_d1);

            eon_t1x= [0:0.1:600 ; pchip(eon_t1(:,1),eon_t1(:,2),0:0.1:600)];
            eon_t2x= [0:0.1:600 ; pchip(eon_t2(:,1),eon_t2(:,2),0:0.1:600)];

            eoff_t1x= [0:0.1:600; pchip(eoff_t1(:,1),eoff_t1(:,2),0:0.1:600)];
            eoff_t2x= [0:0.1:600 ; pchip(eoff_t2(:,1),eoff_t2(:,2),0:0.1:600)];

            err_d2x= [0:0.1:600 ; pchip(err_d2(:,1),err_d2(:,2),0:0.1:600)];
            err_d1x= [0:0.1:600 ; pchip(err_d1(:,1),err_d1(:,2),0:0.1:600)];

            Wave.SemiconductorParameters.eon_t1x=eon_t1x;
            Wave.SemiconductorParameters.eon_t2x=eon_t2x;

            Wave.SemiconductorParameters.eoff_t1x=eoff_t1x;
            Wave.SemiconductorParameters.eoff_t2x=eoff_t2x;

            Wave.SemiconductorParameters.err_d2x=err_d2x;
            Wave.SemiconductorParameters.err_d1x=err_d1x;

            Wave.SemiconductorParameters.RjcT1 = RjcT1;
            Wave.SemiconductorParameters.RjcT2 = RjcT2;
            Wave.SemiconductorParameters.RjcD1 = RjcD1;
            Wave.SemiconductorParameters.RjcD2 = RjcD2;
            Wave.SemiconductorParameters.RcsT1 = RcsT1;
            Wave.SemiconductorParameters.RcsT2 = RcsT2;      
            Wave.SemiconductorParameters.RcsD1 = RcsD1;      
            Wave.SemiconductorParameters.RcsD2 = RcsD2;      
            Wave.SemiconductorParameters.weight = weight ;
            Wave.SemiconductorParameters.cost = 199.92*3 ;
            Wave.SemiconductorParameters.Module = 'Semikron SEMiX305TMLI12E4B' ;
            Wave.SemiconductorParameters.weight = 0.398*3 ;

    end
end    
%% Plot Two IGBT Switching Energies 

if Wave.Input.plot_switching_energy == 1 
    switch topology
        case 'Two Level - SiC'
            A = imread('eonoff_2LC_SiC.PNG');
            B = imread('diode_characteristics_SiC.PNG');

            figure;
            subplot(1,2,1)
            sgtitle(sprintf('Switching energy - %s',topology))
            hold on
            plot(eonx(1,:),eonx(2,:)*1000,'--g')
            plot(eoffx(1,:),eoffx(2,:)*1000,'--b')
            scatter(eon(:,1),eon(:,2)*1000,'filled','g')
            scatter(eoff(:,1),eoff(:,2)*1000,'filled','b')
            legend('E_{on}','E_{off}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on
            
            subplot(1,2,2)
            image(A)
            xticks([])
            yticks([])
            
            onstatecar=-1/Wave.SemiconductorParameters.rd*Wave.SemiconductorParameters.Vd + ...
                1/Wave.SemiconductorParameters.rd*(0:0.1:6);
            
            figure;
            subplot(1,2,1)
            sgtitle(sprintf('On-state characteristics - %s',topology))
            hold on
            plot(0:0.1:6,onstatecar,'b')
            xlabel('On State Voltage [V]')
            ylabel('Drain-Source Current [A]')
            grid on
            xlim([0 6])
            ylim([0 eoffx(1,end)])
            
            
            subplot(1,2,2)
            image(B)
            xticks([])
            yticks([])
            
            
        case 'Two Level'
            A = imread('eonoff.PNG');
            B = imread('err.PNG');
            C = imread('IGBT_characteristics_Si.PNG');
            D = imread('diode_characteristics_Si.PNG');

            figure;
            subplot(2,2,1:2)
            sgtitle(sprintf('Switching energy - %s',topology))
            hold on
            plot(eonx(1,:),eonx(2,:)*1000,'--g')
            plot(eoffx(1,:),eoffx(2,:)*1000,'--b')
            plot(errx(1,:),errx(2,:)*1000,'--r')
            scatter(eon(:,1),eon(:,2)*1000,'filled','g')
            scatter(eoff(:,1),eoff(:,2)*1000,'filled','b')
            scatter(err(:,1),err(:,2)*1000,'filled','r')
            legend('E_{on}','E_{off}','E_{rr}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on
            
            subplot(2,2,3)
            image(A)
            xticks([])
            yticks([])
            
            subplot(2,2,4)
            image(B)
            xticks([])
            yticks([])
            
                        
            onstatecar_D=-1/Wave.SemiconductorParameters.rd*Wave.SemiconductorParameters.Vd + ...
                1/Wave.SemiconductorParameters.rd*(0:0.1:6);                        
            onstatecar_T=-1/Wave.SemiconductorParameters.rd*Wave.SemiconductorParameters.Vt + ...
                1/Wave.SemiconductorParameters.rt*(0:0.1:6);
            
            figure;
            subplot(2,2,1)
            sgtitle(sprintf('On-state characteristics - %s',topology))
            title('IGBT')
            hold on
            plot(0:0.1:6,onstatecar_T,'b')
            xlabel('Voltage [V]')
            ylabel('Drain-Source Current [A]')
            grid on
            xlim([0 6])
            ylim([0 eoffx(1,end)])
            
            subplot(2,2,2)
            title('Diode')
            hold on
            plot(0:0.1:6,onstatecar_D,'b')
            xlabel('On State Voltage [V]')
            ylabel('Drain-Source Current [A]')
            grid on
            xlim([0 6])
            ylim([0 eoffx(1,end)])
                       
            subplot(2,2,3)
            image(C)
            xticks([])
            yticks([])
                        
            subplot(2,2,4)
            image(D)
            xticks([])
            yticks([])
            
            
        case 'Three Level NPC'
            A = imread('switching_igbt1_NPC.PNG');
            B = imread('switching_igbt2_NPC.PNG');
            
            figure;
            subplot(1,2,1)
            sgtitle(sprintf('T1 - D5 Switching energy - %s',topology))
            hold on
            plot(eon_t1x(1,:),eon_t1x(2,:)*1000,'--g')
            plot(eoff_t1x(1,:),eoff_t1x(2,:)*1000,'--b')
            plot(err_d5x(1,:),err_d5x(2,:)*1000,'--r')
            scatter(eon_t1(:,1),eon_t1(:,2)*1000,'filled','g')
            scatter(eoff_t1(:,1),eoff_t1(:,2)*1000,'filled','b')
            scatter(err_d5(:,1),err_d5(:,2)*1000,'filled','r')
            legend('E_{on}','E_{off}','E_{rr}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on
            
            subplot(1,2,2)
            image(A)
            xticks([])
            yticks([])
            
            figure;
            subplot(1,2,1)
            sgtitle(sprintf('T2 - D1 Switching energy - %s',topology))
            hold on
            plot(eon_t2x(1,:),eon_t2x(2,:)*1000,'--g')
            plot(eoff_t2x(1,:),eoff_t2x(2,:)*1000,'--b')
            plot(err_d1x(1,:),err_d1x(2,:)*1000,'--r')
            scatter(eon_t2(:,1),eon_t2(:,2)*1000,'filled','g')
            scatter(eoff_t2(:,1),eoff_t2(:,2)*1000,'filled','b')
            scatter(err_d1(:,1),err_d1(:,2)*1000,'filled','r')
            legend('E_{on}','E_{off}','E_{rr}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on  
             
            subplot(1,2,2)
            image(B)
            xticks([])
            yticks([])   
            
        case 'Three Level TTYPE'
            A = imread('switching_igbt1_TTYPE.PNG');
            B = imread('switching_igbt2_TTYPE.PNG');
            
            figure;
            subplot(1,2,1)
            sgtitle(sprintf('T1 - D2 Switching energy - %s',topology))
            hold on
            plot(eon_t1x(1,:),eon_t1x(2,:)*1000,'--g')
            plot(eoff_t1x(1,:),eoff_t1x(2,:)*1000,'--b')
            plot(err_d2x(1,:),err_d2x(2,:)*1000,'--r')
            scatter(eon_t1(:,1),eon_t1(:,2)*1000,'filled','g')
            scatter(eoff_t1(:,1),eoff_t1(:,2)*1000,'filled','b')
            scatter(err_d2(:,1),err_d2(:,2)*1000,'filled','r')
            legend('E_{on}','E_{off}','E_{rr}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on
             
            subplot(1,2,2)
            image(A)
            xticks([])
            yticks([])
            
            figure;
            subplot(1,2,1)
            sgtitle(sprintf('T2 - D1 Switching energy - %s',topology))
            hold on
            plot(eon_t2x(1,:),eon_t2x(2,:)*1000,'--g')
            plot(eoff_t2x(1,:),eoff_t2x(2,:)*1000,'--b')
            plot(err_d1x(1,:),err_d1x(2,:)*1000,'--r')
            scatter(eon_t2(:,1),eon_t2(:,2)*1000,'filled','g')
            scatter(eoff_t2(:,1),eoff_t2(:,2)*1000,'filled','b')
            scatter(err_d1(:,1),err_d1(:,2)*1000,'filled','r')
            legend('E_{on}','E_{off}','E_{rr}')
            xlabel('I_{C} [A]')
            ylabel('E [mJ]')
            grid on
            
                         
            subplot(1,2,2)
            image(B)
            xticks([])
            yticks([])
    end
end
end