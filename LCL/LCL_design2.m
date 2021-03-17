function [ Temp ] = LCL_design2 ( Wave , kres , sftycoeff) 
%% load data
vll = Wave.Input.vll ; 
P = Wave.Input.P ;

fs = Wave.Input.fs ;
fg = Wave.Input.fg ;
qfact =  Wave.Input.qfact ;
% kres =  Wave.Input.kres ;
wres = kres*fs*2*pi ;
% sftycoeff = Wave.Input.sftycoeff ;
%% define total inductance

[ flag2 ] = total_inductance_definition_LCL ( Wave , kres ) ;
Ltot = flag2*sftycoeff ;
Lc = 0.15*Ltot:0.01*Ltot:0.85*Ltot;
Lg = 0.85*Ltot:-0.01*Ltot:0.15*Ltot;

C = ( Lc + Lg ) ./ ( Lc .* Lg .* wres^2 ) ;  

%% max capacitance due to Q absorption
Cmax=qfact*P/3/((vll/sqrt(3))^2*2*pi*fg) ;                        % max Cap / max Q absorption

[ ~ , b ] = find(C>=Cmax);

% delete too high C designs
% Lc(b) = [] ;
% Lg(b) = [] ;
% C(b) = [] ;
Lc(b) = 0 ;
Lg(b) = 0 ;
C(b) = 0 ;
%% selected filter design

Temp(:,1) = kres*ones(size(Lc,2),1) ;
Temp(:,2) = Lc' ;
Temp(:,3) = Lg' ;
Temp(:,4) =  C' ;

%% check compliance

% [ i_a_fft_amplitude ] = current_fft( Ltot , Wave ) ;
% IEEE519_compliance_check ( i_a_fft_amplitude , Wave ) ;

end