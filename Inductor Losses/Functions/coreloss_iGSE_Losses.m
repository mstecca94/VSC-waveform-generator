function [coreloss_iGSE, num_minorloop]=coreloss_iGSE_Losses(B_rec1,t,ko,alpha,beta)
% coreloss_iGSE [W/kg]
% Use iGSE(improved Generalized Steinmetz Equation)
ki = ko/((2*pi)^(alpha-1)*2^(beta-alpha)*integral(@(x) abs(cos(x).^alpha),0,2*pi));

%%%%%%%%%%%%%%%%%%%%%%%%%%% Definition Part%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

slope_check_time=zeros(1,2); % This variable is for recording the point(time) where slope is changed
slope_check_B=zeros(1,2);    % This variable is for recording B when slope is changed
slope_check_i=[1,1];
slope_first=0;
slope_first_tB=zeros(1,3);
check=2; % This variable notify whether value is substituted to array 1 or array 2
Pw_iGSE =zeros(1,2);
num_minorloop=1;    %This shows nth time minor loop
time_dif=t(2)-t(1);

slope_check_B(1)=B_rec1(1);
slope_check_time(1)=t(1);
T_total=t(length(t))-t(1);
flg=0; % In case that first should to move to last point, flg changes to 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%% Calculate coreloss by iGSE
for i=3:length(t)
    if (B_rec1(i)-B_rec1(i-1))*(B_rec1(i-1)-B_rec1(i-2))<0 || i==length(t)  %%%%%% check when the slope become 0
        
        if slope_first==0                                                               % This part is for saving first minor loop
            slope_check_time(2)=t(i-1);                                                 % If first minor loop slope and last minor loope slope are
            slope_check_B(2)=B_rec1(i-1);                                               % same, we should move first minor loop to
            slope_check_i(2)=i-1;                                                       % right side of last loop
            slope_first_tB(1,3)=i-1;
            for c=1:slope_check_i(2)
                slope_first_tB(c,1)=t(c);
                slope_first_tB(c,2)=B_rec1(c);
            end
            slope_first=slope_check_B(2)-slope_check_B(1);
        end
        
        if i==length(t) && slope_first*(B_rec1(length(t))-slope_check_B(mod(check,2)+1))<0
            slope_first_tB(1,3)=1;
        end
        
        if i==length(t) && slope_first*(B_rec1(length(t))-slope_check_B(mod(check,2)+1))>0 % Check wheather slope of first minor loop and last are same
            for d=1:length(slope_first_tB(:,1))
                B_rec1(d+i-1)=slope_first_tB(d,2);
                t(d+i-1)=t(i)+time_dif*(d-1);
            end
            slope_check_time(check)=t(i+length(slope_first_tB(:,1))-1);         % '-1' means that first minor loop's last point is same as last minor loop's
            slope_check_B(check)=B_rec1(i+length(slope_first_tB(:,1))-1);       % fisrt point.
            slope_check_i(check)=i+length(slope_first_tB(:,1)-1);
            B_pk2pk=abs(slope_check_B(2)-slope_check_B(1)); % B_pk2pk means deltaB which is wrote in 2002 Sullivan's thesis
            t_delta=abs(slope_check_time(2)-slope_check_time(1));   % t_delta means T which is wrote in 2002 Sullivan's thesis
            round=ceil(abs(slope_check_i(2)-slope_check_i(1))/40); % To resample
            rotation_number=round;
            Pw_iGSE(num_minorloop,1)=0;
            flg=1;
        else
            slope_check_time(check)=t(i-1);
            slope_check_B(check)=B_rec1(i-1);
            slope_check_i(check)=i-1;
            B_pk2pk=abs(slope_check_B(2)-slope_check_B(1)); % B_pk2pk mean deltaB which is wrote in 2002 Sullivan's thesis
            t_delta=abs(slope_check_time(2)-slope_check_time(1));   % t_delta mean T which is wrote in 2002 Sullivan's thesis
            
            round=ceil(abs(slope_check_i(2)-slope_check_i(1))/40); % To resample
            rotation_number=round;
            Pw_iGSE(num_minorloop,1)=0;
            if i==length(t) && slope_first*(slope_check_B(check)-slope_check_B(mod(check,2)+1))<0
                plot_time=1:length(slope_first_tB(:,1));            % First minor loop was not drawed so draw it in this part
%                 plot(plot_time,B_rec1(plot_time));
%                 title('Divided into minor loop')
%                 xlabel('Time in seconds')
%                 ylabel('Magnetic flux density(B) in Tesla')
%                 hold on
            end
        end
        
        Pw_iGSE(num_minorloop,2)=i-1;
        if flg
            Pw_iGSE(num_minorloop,2)=i-1+slope_first_tB(1,3);
        end
        
        % If check is 2, Consider slope_check_i(1) to slope_check_i(2)
        % If check is 1, Consider slope_check_i(2) to slope_check_i(1)
        % If we simplify the structure, we just make the code by
        % considering slope_check_i(mod(check,2)+1) to slope_check_i(check)
        
        while slope_check_i(mod(check,2)+1)+rotation_number<slope_check_i(check)
            j=slope_check_i(mod(check,2)+1)+rotation_number;
            slope_temp=abs((B_rec1(j)-B_rec1(j-round))/(t(j)-t(j-round)));
            Pw_iGSE(num_minorloop,1)=Pw_iGSE(num_minorloop,1)+((ki*B_pk2pk^(beta-alpha))/t_delta)*(slope_temp^alpha)*(t(j)-t(j-round)); % iGSE equation
            rotation_number=rotation_number+round;
        end
        
        plot_time=slope_check_i(mod(check,2)+1):slope_check_i(mod(check,2)+1)+rotation_number-round;  % plot_time shows period for plot_function
        plot_function=B_rec1(plot_time); % This is function of minor loop
        if slope_check_i(1)~=1
%             plot(plot_time,plot_function);
%             title('Divided into minor loop')
%             xlabel('Time in seconds')
%             ylabel('Magnetic flux density(B) in Tesla')
%             hold on
        end
        check=mod(check,2)+1;
        Pw_iGSE(num_minorloop,1)=Pw_iGSE(num_minorloop,1)*t_delta/T_total;
        num_minorloop=num_minorloop+1;
    end
end


%% Plot the minor loop loss
i=1;
temp=1;
if flg
    Pw_iGSE(1,1)=0;
    for j=1:length(Pw_iGSE(:,1))
        while i<Pw_iGSE(j,2)
            coreloss_plot(i)=Pw_iGSE(j,1)/(Pw_iGSE(j,2)-temp);
            i=i+1;
        end
        temp=Pw_iGSE(j,2);
    end
    num_minorloop=num_minorloop-2;
else
    for j=1:length(Pw_iGSE(:,1))
        while i<=Pw_iGSE(j,2)
            coreloss_plot(i)=Pw_iGSE(j,1)/(Pw_iGSE(j,2)-temp);
            i=i+1;
        end
        temp=Pw_iGSE(j,2);
    end
    num_minorloop=num_minorloop-1;
end

% figure
% plot(t(slope_first_tB(1,3):length(t)),B_rec1(slope_first_tB(1,3):length(B_rec1))*0.001,t(1:length(t)-1),20.*coreloss_plot,'LineWidth',2);
% title('Input wave & minorloop loss')
% xlabel('Time in seconds')
% ylabel('Magnetic flux density(B) in kT')
coreloss_iGSE=sum(Pw_iGSE(:,1));
end



