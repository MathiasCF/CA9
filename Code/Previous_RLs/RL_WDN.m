clc
clear all
close all

P = 3;
h = 20;
timediscretisation = 24;

Q = zeros(P,h,timediscretisation,3);
%Q(1,1,1,:) = [1 2 3];

exponent = 0.0000;
alpha = 0.1;
gamma = 0.2;
epsilon = 0.1;
maxstep = 2000;

demand = load('ConsumptionProfile');
demand = demand.dcon;
%demand = [1 3 2 1];
S0 = [1 h/2 1]';

 %consumerindex = [2 1 2];
for episode = 1:1
   state = S0;
   
   if episode > 100
       %maxstep = 1000;
       epsilon = 0;
       alpha = 0;
       state = [1 h/2+5 1]';
   end
   for ii = 1:maxstep
       
%        if ii > 100
%            alpha = 0;
% 
%        end
%        
%        if ii == 100
%                              Qold = Q(state(1),state(2),state(3),:)
% 
%        end
       newstate = nextstate(state, Q, epsilon,h,demand,timediscretisation);
       epsilon = epsilon*exp(-ii*exponent);
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
       figure()
       ha(1)=subplot(4,1,1);
       plot(Tanklevel)
       ylim([-1 h+1]);
       ha(2)=subplot(4,1,2);
       plot(pump)
       ha(3)=subplot(4,1,3);
       plot(decayrate)
       ha(4)=subplot(4,1,4);
       plot(test,'linestyle','none','marker', 'o')
       legend('1','2','3')
       linkaxes(ha,'x')

end


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

