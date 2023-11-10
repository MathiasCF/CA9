clc
clear all
close all


h = 20;
timediscretisation = 24;

Q = zeros(h,timediscretisation,3);
%Q(1,1,1,:) = [1 2 3];


maxstep = 5000;

exponent = 5/maxstep;
alpha = 0.5;
gamma = 0.3;
epsilon = 0.5;

demand = load('ConsumptionProfile');
demand = demand.dcon;
%demand = [1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3];
S0 = [h/2 1]';

jjj = 1;
for jj = 1:maxstep
    demandvector(jj) = 1+1.8*demand(jjj);
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

%--------------------------------------------------------------------------
for episode = 1:1
   state = S0;
   
   for ii = 1:maxstep
      
       if ii > 0.9*maxstep
           alpha = 0;
           epsilon = 0;
       end
       
       newstate = nextstateREDUCEDSTATESPACE(state, Q, epsilon,h,demand,timediscretisation);    %gives new height and next time, and action
       action = newstate(3);
       epsilon = epsilon*exp(-ii*exponent);

       Cost = action*((action)^2+state(1)/2) + 5*bound(newstate(1));            %cost = E + b(h)    ->    cost = q*p+b(h)  =   q*(q^2+q)
        
       Costi(ii) = Cost;
       
       Qold = Q(state(1),state(2),:);
       Q(state(1),state(2),action) = Q(state(1),state(2),action) + alpha*exp(-ii*exponent)*(Cost + gamma*(min(Q(newstate(1),newstate(2),:))-Q(state(1),state(2),action)));

       Tanklevel(ii) = state(1);
       decayrate(ii) = alpha*exp(-ii*exponent);
       
       state = newstate(1:2);
       pump(ii) = action;
       
%        if ii < 10000
%        line = nan(h,timediscretisation,3);
%        heightnow = state(1);
%        timenow = state(2);
%        for v = 1:timediscretisation
%            line(heightnow, v, 1) = 0;
%        end
%        for v2 = 1:h
%            line(v2, timenow, 1) = 0;
%        end
% 
%        surf(Q(:,:,1))
%        xlabel('Time')
%        ylabel('Height')
%        zlabel('Value')
%        hold on
%        %surf(line(:,:,1),'EdgeColor','g','LineWidth',5)
%        view(-135,45)
%        pause(0.05);
% %        if mod(ii,10) == 0
% %            pause(5)
% %        end
%        end
   end
   
       figure()
       ha(1)=subplot(5,1,1);
       plot(Tanklevel)
       ylim([-1 h+1]);
       ha(2)=subplot(5,1,2);
       plot(demandvector)
       title('demand')
       ha(3)=subplot(5,1,3);
       plot(pump)
       title('pump')
       ha(4)=subplot(5,1,4);
       plot(decayrate)
       ha(5)=subplot(5,1,5);
       plot(Costi)%,'linestyle','none','marker', 'o')
       title('cost')
       legend('1','2','3')
       linkaxes(ha,'x')

%        line = nan(h,timediscretisation,3);
%        highstate = 15;
%        timenow = 3;
%        for v = 1:timediscretisation
%            line(15, v, 1) = 0;
%        end
%        for v2 = 1:h
%            line(v2, timenow, 1) = 0;
%        end
% 
%        
%        figure()
%        surf(Q(:,:,1))
%        xlabel('Time')
%        ylabel('Height')
%        zlabel('Value')
% %        hold on
% %        surf(line(:,:,1),'EdgeColor','g','LineWidth',5)
%        
%        figure()
%        surf(Q(:,:,2))
%        xlabel('Time')
%        ylabel('Height')
%        zlabel('Value')
%        
%        figure()
%        surf(Q(:,:,3))
%        xlabel('Time')
%        ylabel('Height')
%        zlabel('Value')
 end
mean(Costi(maxstep*0.8:maxstep*0.9))

mean(Costi(maxstep*0.9:maxstep))
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

