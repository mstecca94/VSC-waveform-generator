function [ Wave ] = i_on_off_evaluation ( Wave )
%%
t=Wave.Input.t;
t_step=Wave.Input.t_step;
fs=Wave.Input.fs;
A=Wave.Current.i_converter_side;
k=1/fs/(t_step);
 
[~,b]=max(A(1,1:k));
[~,b3]=min(A(1,1:k));

for x=1:k:size(t,2)-k
    x=round(x);
    [y,z]=max(A(1,x:x+k));
    [y1,z1]=min(A(1,x:x+k));
    env_up(x,:)=[t(1,round(x+z)) y ];
    env_down(x,:)=[t(1,round(x+z1)) y1];
end

[a1,b1]=max(A(1,end-k:end));
[a2,b2]=min(A(1,end-k:end));

env_up(end+1,:)=[env_up(end,1)+t_step*k a1];
env_down(end+1,:)=[env_down(end,1)+t_step*k a2];

env_up(find(env_up(:,1)==0),:)=[];
env_up(find(env_up(:,2)<=0),:)=[];
% env_up(:,1)=env_up(:,1)+t_step*b;

env_down(find(env_down(:,1)==0),:)=[];
env_down(find(env_down(:,2)<=0),:)=[];
% env_down(:,1)=env_down(:,1)+t_step*b3;

Wave.CurrentWR.TurnOFFCurrent = env_up ;
Wave.CurrentWR.TurnONCurrent = env_down ;

figure;
title('Turn on and off current')
hold on
plot(t,A)
scatter(env_up(:,1),env_up(:,2))
scatter(env_down(:,1),env_down(:,2))
grid on
xlabel('Time [s]')
ylabel('Current [A]')


end