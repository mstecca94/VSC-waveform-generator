function [ Wave ] = semiconductor_data ( Wave )
%% here I can add different switches and switch to compare them
topology =  Wave.Input.Topology  ; 

switch topology
        case 'Two Level - SiC' % Cree C3M0120090J - datasheet data
                %% MOSFET parameters
                Wave.SemiconductorParameters.U__Bt = 600;
                Wave.SemiconductorParameters.rt = 0.17;
                Wave.SemiconductorParameters.Vt = 0.0;
                %% Body Diode parameters
                Wave.SemiconductorParameters.U__Bd = 600;
                Wave.SemiconductorParameters.rd = 0.17;
                Wave.SemiconductorParameters.Vd = 0.0;

                %% Switching functions 
                % E reverse recovery - in the eon
                err= [ 0 ,0 ];
                % E turn off
                eoff=[0, 0
                    0.1, 0.000009
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
        case 'Two Level' % Infineon IXGA30N120B3 Module - datasheet data
                %% IGBT parameters
                Wave.SemiconductorParameters.U__Bt = 960;
                Wave.SemiconductorParameters.rt = 0.0429;
                Wave.SemiconductorParameters.Vt = 1.35;
                %% Diode parameters
                Wave.SemiconductorParameters.U__Bd = 960;
                Wave.SemiconductorParameters.rd = 0.0185;
                Wave.SemiconductorParameters.Vd = 1.25;

                %% Switching functions 
                % E reverse recovery
                err=[0 , 0
                ];
                % E turn off
                eoff=[0 , 0
                    15.086956521739129, 0.002382513661202186
                    25.608695652173914, 0.0043060109289617485
                    33.391304347826086, 0.005748633879781421
                    41.17391304347825, 0.0073442622950819665
                    47.565217391304344, 0.008633879781420765
                    53.391304347826086, 0.009836065573770491
                    59.95652173913043, 0.011234972677595628
                ];
                % E turn on
                eon=[0 , 0
                    15.130434782608695, 0.0035846994535519115
                    20.391304347826086, 0.004699453551912567
                    25.869565217391305, 0.005814207650273224
                    33.26086956521739, 0.007409836065573772
                    40.04347826086956, 0.008852459016393442
                    46.30434782608695, 0.010229508196721313
                    51.565217391304344, 0.011344262295081967
                    60, 0.013245901639344262
                ];

                Wave.SemiconductorParameters.eon=sort(eon);
                Wave.SemiconductorParameters.eoff=sort(eoff);
                Wave.SemiconductorParameters.err=sort(err);

                eonx= [0:0.1:25 ; pchip(eon(:,1),eon(:,2),0:0.1:25)];
                eoffx=[0:0.1:25  ; pchip(eoff(:,1),eoff(:,2),0:0.1:25)];
                errx=[0:0.1:25  ; (0:0.1:25)*0];

                Wave.SemiconductorParameters.eonx=eonx;
                Wave.SemiconductorParameters.eoffx=eoffx;
                Wave.SemiconductorParameters.errx=errx;

                Wave.SemiconductorParameters.cost = (6.03+2*3.1)*3 ;
                Wave.SemiconductorParameters.weight = 3*0.015*3 ;
                Wave.SemiconductorParameters.Module = '2x IGBT IXYS IXGA30N120B3 / 1x SiC Schottky diode Infineon IDK20G120C5' ;   
end
end