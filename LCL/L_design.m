function [ Wave ] = L_design ( Wave )
%%
ACFilter = Wave.Input.ACFilter;
% this to ensure that a good starting point is found
start_check = -1 ; 
it=1; % counter
switch ACFilter
    case 'LCL'
        Ltot = 1e-5 ; % starting point that should work
    case 'L'
        Ltot = 1e-4 ; % starting point that should work
end
while start_check <= 0 
    [ i_ab_fft_amplitude ] = current_fft ( Ltot , Wave  );
    [ IEEE_respected ] = IEEE519 ( i_ab_fft_amplitude , Wave );
    start_check = IEEE_respected ; 
    Ltot = Ltot/10 ;
    it=it+1;
    if it==3
        disp('Defining new starting Ltot min')
    end
end
if it>=3
    fprintf('Good new strating Ltot min found after %d iteration \n',it)
end
%%
Ltot_0 = Ltot*10 ;
Ltot_end = Ltot_0*5000 ;
% actual routine
x=1;
for Ltot = Ltot_0:Ltot_0:Ltot_end
    [ i_ab_fft_amplitude ] = current_fft ( Ltot , Wave  );
    [ IEEE_respected ] = IEEE519 ( i_ab_fft_amplitude , Wave );
    compliance(x,:) = [ Ltot IEEE_respected ] ;    
    if x>2 && compliance(x-1,2) >= 0 && compliance(x,2) < 0 
        flag = Ltot ;
        break % the break is to cut shorter the computation
    end
    x=x+1;   
end
% this to ensure that an end solution is found / kinda forced 
if compliance(end,2) >=0
    disp('New end point required')
    Ltot_end = Ltot_end*1000; % this is really playing safe (going to some H)
    compliance = [];
    x=1;
    for Ltot = Ltot_0:Ltot_0:Ltot_end
        [ i_ab_fft_amplitude ] = current_fft ( Ltot , Wave  );
        [ IEEE_respected ] = IEEE519 ( i_ab_fft_amplitude , Wave );
        compliance(x,:) = [ Ltot IEEE_respected ] ;    
        if x>2 && compliance(x-1,2) >= 0 && compliance(x,2) < 0 
            flag = Ltot ;
            break % maybe here it can be cut
        end
        x=x+1;   
    end
end
%%
% second optimization to refine the data granularity
Ltot_0_1 = flag - Ltot_0 ; 
Ltot_end_1 = flag + Ltot_0 ;
step = Ltot_0/100;
x=1;
for Ltot = Ltot_0_1:step:Ltot_end_1
    [ i_ab_fft_amplitude ] = current_fft ( Ltot , Wave  );
    [ IEEE_respected ] = IEEE519 ( i_ab_fft_amplitude , Wave );
    compliance_2(x,:) = [ Ltot IEEE_respected ] ;
    
    if x>2 && compliance_2(x-1,2) >= 0 && compliance_2(x,2) < 0 
        flag2 = Ltot ;
    end
    
    x=x+1;   
end

Wave.Input.L = flag2 ; 

end


