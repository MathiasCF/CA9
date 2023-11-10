clc
clear all
close all

dz = 1;
r = 0.1;

P = 3;
h = 20;
timediscretisation = 24;

Q = zeros(P,h,timediscretisation,3);
%Q(1,1,1,:) = [1 2 3];



exponent = 0.0001;
alpha = 0.5;
gamma = 0.2;
epsilon = 0.1;
maxstep = 20000;

demand = load('ConsumptionProfile');
demand = demand.dcon;
%demand = [1 3 2 1];
S0 = [1 h/2 1]';

jjj = 1;
for jj = 1:maxstep
    demandvector(jj) = demand(jjj);
    jjj = jjj + 1;
    if mod(jj,24) == 0
        jjj = 1;
    end
end


bound = zeros(1,h);
for j = h-h/4+1:h
    bound(j) = -log(h-j+0.00001)+log(h/4);
end
bound(1:h/4)= bound(h:-1:h-h/4+1);

 %consumerindex = [2 1 2];
for episode = 1:1
   state = S0;
   
   if episode > 1
    clear Cost Costi newstate Pt pump Q Qold Tanklevel test
    Q = zeros(P,h,timediscretisation,3);
    alpha = 0.5;
    gamma = 0.2;
    epsilon = 0.4;
    end
%    t = zeros(1,maxstep);
    for ii = 1:maxstep

        if ii > 0.9*maxstep
            epsilon = 0;
            alpha = 0;
        end

       
       newstate = nextstateENERGY(state, Q, epsilon,h,demand,timediscretisation);
       epsilon = epsilon*exp(-ii*exponent);
       Pt = 1 * state(2) * 9.82;
       Cost = newstate(1)*(r*newstate(1)^2+dz+state(2)/10) + 2*bound(newstate(2));
        Costi(ii) = Cost;
       Qold = Q(state(1),state(2),state(3),:);
       Q(state(1),state(2),state(3),newstate(1)) = Q(state(1),state(2),state(3),newstate(1)) + alpha*exp(-ii*exponent)*(Cost + gamma*(min(Q(newstate(1),newstate(2),newstate(3),:))-Q(state(1),state(2),state(3),newstate(1))));
       changeofstate(ii) = newstate(1);
       Tanklevel(ii) = state(2);
       decayrate(ii) = alpha*exp(-ii*exponent);
       
       
       test(ii,:) = Q(state(1),state(2),state(3),:)-Qold;

       state = newstate;
       pump(ii) = state(1);
       
%        if ii > 2936 && ii < 2982
%         test(ii,:) = Q(state(1),state(2),state(3),:);
%        end
   end
       figure()
       ha(1)=subplot(5,1,1);
       plot(Tanklevel)
       ylim([-1 h+1]);
       ha(2)=subplot(5,1,2);
       plot(demandvector)
       ha(3)=subplot(5,1,3);
       plot(pump)
       ha(4)=subplot(5,1,4);
       plot(decayrate)
       ha(5)=subplot(5,1,5);
       plot(Costi)%,'linestyle','none','marker', 'o')
       legend('1','2','3')
       linkaxes(ha,'x')

       
maxepisode(episode) = max(Tanklevel(maxstep*0.9:maxstep))
minepisode(episode) = min(Tanklevel(maxstep*0.9:maxstep))
meanepisode(episode) = mean(Tanklevel(maxstep*0.9:maxstep))
costepisode(episode) = mean(Costi(maxstep*0.9:maxstep))
end


figure()
plot(maxepisode)
hold on
plot(minepisode)
plot(meanepisode)
plot(costepisode)
legend('max','min','mean','costmean')

%     Subplot for everything
%        figure()
%        ha(1)=subplot(4,1,1);
%        plot(Tanklevel)
%        ylim([-1 h+1]);
%        ha(2)=subplot(4,1,2);
%        plot(pump)
%        ha(3)=subplot(4,1,3);
%        plot(decayrate)
%        ha(4)=subplot(4,1,4);
%        plot(test,'linestyle','none','marker', 'o')
%        legend('1','2','3')
%        linkaxes(ha,'x')

