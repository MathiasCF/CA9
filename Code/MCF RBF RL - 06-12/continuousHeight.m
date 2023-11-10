clear all; close all; clc; warning off;
%ColorSet = varycolor(10);

for ep = 1:1
                    %Set max height
timediscretisation = 24;    %Set

h=70;

Q = [0 0 0];

time = 1;
actions = 3;
weights = 10;

w = zeros(actions,timediscretisation,weights);                              %a row of weights for each action

for c = 1:weights
    centers(c) = (c-1)*(h+20)/(weights-1);
    centers(c) = centers(c) - 10;
end
%centers =  [0    10    20    30    40    50    60    70]

%centers(4) = 200;

sigma = 9;%1.79;%2.5 + 0.5*ep;                                            %width of features
sigma = 4;
%sigma = 3.12;
%sigma = 1.9;

testheight = 24.5;
 for f = 1:weights
            feature5(f) = exp((-(abs(testheight-centers(f)))^2)/(2*sigma^2));
 end


feature = zeros(1,weights);                      %Initialise features to zero


 for f = 1:weights
            feature5(f) = exp((-(abs(5-centers(f)))^2)/(2*sigma^2));
 end

maxstep = 1000000;

%Set initial values of alpha, gamma and epsilon 
alpha = 0.4;% + 0.45*(ep-1);
gamma = 0.95;% + 0.5*ep;
epsilon = 0.1;


%load demand data
demand = load('ConsumptionProfile');
demand = demand.dcon*5.77+5;

S0 = [h/2 1]';       % set initial state S0(h,t)

%Create demand vector
jjj = 1;
for jj = 1:maxstep
    demandvector(jj) = demand(jjj);
    jjj = jjj + 1;
    if mod(jj,24) == 0
        jjj = 1;
    end
end

%--------------------------------------------------------------------------
for episode = 1:1
    state = S0;
        
    for ii = 1:maxstep
        
        %turn of learning and randomnes for the last 10%
        if ii > 0.9*maxstep
            alpha = 0.0;
            epsilon = 0;
        end
        
        newstate = nextstatefunctionapprox(state, Q, epsilon,h,demand,timediscretisation);    %gives new height and next time, and action
        action = newstate(3);
        actualh = newstate(1);
        flow = newstate(4);
        
        Qold = squeeze(w(action,time,:))'*feature';          %store Q value
        oldfeature = feature;                                %store features
        
        time = newstate(2);      %update time
        
      P = 1000*9.82*0.1*actualh;
      Cost = flow*P*1.667*10^-5 + QuadBarrierFuncActualHeight(actualh);
      Costi(ii) = Cost;
        
        %update features at new height
        for f = 1:weights
            feature(f) = exp((-(abs(newstate(1)-centers(f)))^2)/(2*sigma^2));           %newstate instead of state???
        end
        
        %update Q values with new features
        for n = 1:3
            Q(n) = squeeze(w(n,time,:))'*feature';
        end
        
        %update weights, special case for time = 1
        if time == 1
            w(action,timediscretisation,:) = squeeze(w(action,timediscretisation,:))' + alpha*(Cost + gamma*min(Q) - Qold).*oldfeature;
        else
            w(action,time-1,:) = squeeze(w(action,time-1,:))' + alpha*(Cost + gamma*min(Q) - Qold).*oldfeature;
        end
        
        %update Q with new weights and new features
        for n = 1:3
            Q(n) = squeeze(w(n,time,:))'*feature';
        end
        
        Tanklevel(ii) = state(1);
        
        state = newstate(1:2);
        pump(ii) = action;
        
        %weighttest1(:,ii) = squeeze(w(1,7,:));
%         weighttest2(ii,:) = w(2,12,:);
%         weighttest3(ii,:) = w(3,12,:);

        Q1(ep,ii) = squeeze(w(1,24,:))'*feature5';
        Q2(ep,ii) = squeeze(w(2,24,:))'*feature5';       
        Q3(ep,ii) = squeeze(w(3,24,:))'*feature5';
    end
end

EPaveragecost(ep,:) = movmean(Costi,4*24*60);

%mean(Costi(maxstep*0.8:maxstep*0.9))
mean(Costi(maxstep*0.95:maxstep))
mean(Tanklevel(maxstep*0.9:maxstep))
end



%% Plots 
%clc

figure(1)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    ylim([0 70]);
    title('Water level in elevated water reservoir')
    ha(2)=subplot(4,1,2);
    plot(demandvector)
    title('Demand')
    ha(3)=subplot(4,1,3);
    plot(pump)
    title('Action')
%     ha(4)=subplot(5,1,4);
%     plot(decayrate)   
%     title('decayrate')
    ha(4)=subplot(4,1,4);
    plot(Costi)%,'linestyle','none','marker', 'o')
    title('Cost $J$')
    linkaxes(ha,'x')

 %Plotting averagecost sweep
for i = 1:ep
figure(3)
plot(EPaveragecost(i,:), 'Color', ColorSet(i,:))
hold on
title('$\gamma$ hyperparameter sweep')
legend('$\gamma$=0.11','$\gamma$=0.22','$\gamma$=0.33','$\gamma$=0.44','$\gamma$=0.55','$\gamma$=0.66','$\gamma$=0.77','$\gamma$=0.88','$\gamma$=0.99','$\gamma$=1')
%legend('$\alpha$=0.125','$\alpha$=0.25','$\alpha$=0.375','$\alpha$=0.5','$\alpha$=0.625','$\alpha$=0.75','$\alpha$=0.875','$\alpha$=1','$\alpha$=0.9','$\alpha$=1','location','best')
%legend('$\epsilon$=0.1','$\epsilon$=0.2','$\epsilon$=0.3','$\epsilon$=0.4','$\epsilon$=0.5','$\epsilon$=0.75','$\epsilon$=0.875','$\epsilon$=1','$\alpha$=0.9','$\alpha$=1','location','best')
legend()
xlabel('Iteration') 
ylabel('Movingaverage cost')
%ylim([4.5 inf])
%xlim([0.9*maxstep maxstep])
end

% % %Plot a Qvalue in function approximation
% for i = 1:ep
% figure()
% plot(Q1(i,:)')
% hold on
% plot(Q2(i,:)')
% plot(Q3(i,:)')
% title('$\hat{Q}(h,\textbf{w}_{t,a})$ EPISODE is',i)
% legend('$\hat{Q}\big(5,\textbf{w}_{22,1}\big)$', '$$\hat{Q}\big(5,\textbf{w}_{22,2}\big)$', '$$\hat{Q}\big(5,\textbf{w}_{22,3}\big)$','location','best')
% end