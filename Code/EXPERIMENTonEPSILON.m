clc
clear all
close all


%%
%Remeber demand are set purposely set low, normalise to 2.5 for regular behavior
%%
P = 3;
h = 20;
timediscretisation = 24;

Q = zeros(P,h,timediscretisation,3);
%Q(1,1,1,:) = [1 2 3];

exponent = 0.00001;
alpha = 0.5;
gamma = 0.2;
epsilon = 0;
maxstep = 5000;

demand = load('ConsumptionProfile');
demand = demand.dcon;
%demand = [1 3 2 1];
S0 = [1 h/2 1]';

 %consumerindex = [2 1 2];
for episode = 1:10
   state = S0;
   
   Q = zeros(P,h,timediscretisation,3);
    epsilon = epsilon + 0.1;
   
   if episode > 100
       %maxstep = 1000;
       epsilon = 0;
       alpha = 0;
       state = [1 h/2+5 1]';
   end
   for ii = 1:maxstep
       newstate = nextstate(state, Q, epsilon,h,demand,timediscretisation);
       %epsilon = epsilon*exp(-ii*exponent)
       R = -abs(h/2-newstate(2));

       Qold = Q(state(1),state(2),state(3),:);
       Q(state(1),state(2),state(3),newstate(1)) = Q(state(1),state(2),state(3),newstate(1)) + alpha*exp(-ii*exponent)*(R + gamma*(max(Q(newstate(1),newstate(2),newstate(3),:))-Q(state(1),state(2),state(3),newstate(1))));
       changeofstate(ii) = newstate(1);
       Tanklevel(ii) = state(2);
       decayrate(ii) = alpha*exp(-ii*exponent);
       
       
       test(ii,:) = Qold-Q(state(1),state(2),state(3),:);

       state = newstate;
       pump(ii) = state(1);
       
%        if ii > 2936 && ii < 2982
%         test(ii,:) = Q(state(1),state(2),state(3),:);
%        end
   end
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

       Q1 = Q(:,:,:,1);
Q2 = Q(:,:,:,2);
Q3 = Q(:,:,:,3);
untappedpotential1(episode) = size(Q1(Q1 == 0),1)
untappedpotential2(episode) = size(Q2(Q2 == 0),1)
untappedpotential3(episode) = size(Q3(Q3 == 0),1)
untappedpotential4(episode) = size(Q(Q == 0),1)
       


end


figure()

plot(untappedpotential1)
hold on
plot(untappedpotential2)

plot(untappedpotential3)

plot(untappedpotential4-1500)

grid on

%         
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

