function [ Wave ] = find_transitions ( Wave )

%%
Topology = Wave.Input.Topology ;
v = Wave.Voltage.v_a ;
t = Wave.Input.t;
I = Wave.Current.i_converter_side ;
Ig = Wave.Current.i_50Hz_a ;
Ig_2 = Wave.Current.i_grid_side ;
%%
switch Topology 
    case {'Two Level','Two Level - SiC'}
        transition = zeros(size(v,2),2) ;
        transition_off = zeros(size(v,2),2) ;
        transition_on = zeros(size(v,2),2) ;
        i_off = zeros(size(v,2),2) ;
        i_on = zeros(size(v,2),2) ;
        for x=1:size(v,2)-1
            if (v(x) > 0 && v(x+1)<=0) || (v(x) < 0 && v(x+1)>=0) || (v(x)==0 && v(x+1)>0) ...
                    || (v(x)== 0 && v(x+1) < 0)
                transition(x,:) = [t(1,x) v(1,x)];
            end
            if (v(x) > 0 && v(x+1)<=0) || (v(x)== 0 && v(x+1) < 0)
                transition_off(x,:) = [t(1,x) v(1,x)];
                i_off(x,:) = [t(1,x) I(1,x)];
                if Ig(x)<=0
                    i_off(x,:) = [0 0];
                end
            end
            if (v(x) < 0 && v(x+1)>=0) || (v(x)==0 && v(x+1)>0)
                transition_on(x,:) = [t(1,x) v(1,x)];
                i_on(x,:) = [t(1,x) I(1,x)];
            end
        end
        transition_on(i_on(:,2)<=0,:)=[];
        transition_off(i_off(:,2)<=0,:)=[];
        i_on(i_on(:,2)<=0,:)=[];
        i_off(i_off(:,2)<=0,:)=[];
        %% save
        Wave.Current.Transition = transition ;
        Wave.Current.Transition_on = transition_on ;
        Wave.Current.Transition_off = transition_off ;
        Wave.Current.TurnONCurrent = i_on ;
        Wave.Current.TurnOFFCurrent = i_off ;      
        if Wave.Input.plot_transition == 1
            %% plot
            figure;
            subplot(2,1,1)
            title('Switching Transitions')
            hold on
            plot(t,Wave.Voltage.v_a)
            scatter(transition(:,1),transition(:,2),200,'p')
            scatter(transition_on(:,1),transition_on(:,2))
            scatter(transition_off(:,1),transition_off(:,2))
            grid on
            xlabel('Time [s]')

            subplot(2,1,2)       
            title('Switching Currents')
            hold on
            plot(t,I)
            plot(t,Ig)
            plot(t,Ig_2)
            scatter(i_on(:,1),i_on(:,2))
            scatter(i_off(:,1),i_off(:,2))
            legend('Ic','Ig','Ig reconstructed','Turn on','Turn off')
            grid on
            xlabel('Time [s]')
        end

    case {'Three Level NPC','Three Level TTYPE'}
        transition = zeros(size(v,2),2) ;
        transition_off_T1 = zeros(size(v,2),2) ;
        transition_on_T1 = zeros(size(v,2),2) ;
        transition_off_T3 = zeros(size(v,2),2) ;
        transition_on_T3 = zeros(size(v,2),2) ;
        i_off_T1 = zeros(size(v,2),2) ;
        i_on_T1 = zeros(size(v,2),2) ;
        i_off_T3 = zeros(size(v,2),2) ;
        i_on_T3 = zeros(size(v,2),2) ;
        % for the commutation loops check : Comparison of 2- and 3-level Active
        % Filters with Enhanced Bridge-Leg Loss Distribution / from Thiago
        for x=1:size(v,2)-1
            % P -> 0 
            if v(x) > 0 && v(x+1)==0
                if Ig(x)>=0
                    i_off_T1(x,:) = [t(1,x) I(1,x)];
                    transition_off_T1(x,:) = [t(1,x) v(1,x)];
                    transition(x,:) = [t(1,x) v(1,x)];
                else
                    i_on_T3(x,:) = [t(1,x) I(1,x)];
                    transition_on_T3(x,:) = [t(1,x) v(1,x)];
                    transition(x,:) = [t(1,x) v(1,x)];
                end
            end
            % 0 -> P
            if v(x) == 0 && v(x+1)>0
                if Ig(x)>=0
                    i_on_T1(x,:) = [t(1,x) I(1,x)];
                    transition_on_T1(x,:) = [t(1,x) v(1,x)];
                    transition(x,:) = [t(1,x) v(1,x)];
                else
                    i_off_T3(x,:) = [t(1,x) I(1,x)];
                    transition_off_T3(x,:) = [t(1,x) v(1,x)];
                    transition(x,:) = [t(1,x) v(1,x)];
                end
            end
        end
        transition_on_T1(i_on_T1(:,2)<=0,:)=[];
        transition_off_T1(i_off_T1(:,2)<=0,:)=[];
        transition_on_T3(i_on_T3(:,2)>=0,:)=[];
        transition_off_T3(i_off_T3(:,2)>=0,:)=[];
        i_on_T1(i_on_T1(:,2)<=0,:)=[];
        i_off_T1(i_off_T1(:,2)<=0,:)=[];
        i_on_T3(i_on_T3(:,2)>=0,:)=[];
        i_off_T3(i_off_T3(:,2)>=0,:)=[];
        %% Save                      
        Wave.Current.Transition_off_T1 = transition_on_T1 ;
        Wave.Current.Transition_off_T1 = transition_off_T1 ;
        Wave.Current.Transition_on_T3 = transition_on_T3 ;
        Wave.Current.Transition_off_T3 = transition_off_T3 ;
        Wave.Current.TurnONCurrent_T1 = abs(i_on_T1) ;
        Wave.Current.TurnOFFCurrent_T1 = i_off_T1 ;
        Wave.Current.TurnONCurrent_T3 = i_on_T3 ;
        Wave.Current.TurnOFFCurrent_T3 = i_off_T3 ;
        if Wave.Input.plot_transition == 1
            %% plot
            figure;
            subplot(3,1,1)
            title('All Switching Transitions')
            hold on
            plot(t,Wave.Voltage.v_a)
            scatter(transition(:,1),transition(:,2))
            legend('Voltage Waveform','Switching Transitions')
            grid on
            xlabel('Time [s]')

            subplot(3,1,2)
            title('Hard Switching Transitions')
            hold on
            plot(t,Wave.Voltage.v_a)
            scatter(transition_on_T1(:,1),transition_on_T1(:,2))
            scatter(transition_off_T1(:,1),transition_off_T1(:,2))
            scatter(transition_on_T3(:,1),transition_on_T3(:,2))
            scatter(transition_off_T3(:,1),transition_off_T3(:,2))
            legend('Voltage Waveform','Turn on T1','Turn off T1','Turn on T3','Turn off T3')
            grid on
            xlabel('Time [s]')

            subplot(3,1,3)        
            title('Switching Currents')
            hold on
            plot(t,I)
            plot(t,Ig)
            plot(t,Ig_2)
            scatter(i_on_T1(:,1),i_on_T1(:,2))
            scatter(i_off_T1(:,1),i_off_T1(:,2))
            scatter(i_on_T3(:,1),i_on_T3(:,2))
            scatter(i_off_T3(:,1),i_off_T3(:,2))
            legend('Ic','Ig','Ig reconstructed','Turn on T1','Turn off T1','Turn on T3','Turn off T3')
            grid on
            xlabel('Time [s]')
        end
        
end


end
