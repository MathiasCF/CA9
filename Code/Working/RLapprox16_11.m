clear all; close all; clc;

for ep = 1:1

h = 20;                     %Set max height
timediscretisation = 24;    %Set

Q = [0 0 0];

time = 1;
actions = 3;
weights = 10;
w = zeros(actions,timediscretisation,weights);                              %a row of weights for each action
% w(3,:,5) = 0;
% w(2,:,5) = 0;
% w(1,:,1) = 0;

%place uniformly distributed weights
for c = 1:weights
    centers(c) = (c-1)*(h+20)/(weights-1);
    centers(c) = centers(c) - 10;
end

feature = zeros(1,weights);                      %Initialise features to zero
sigma = 2;                                            %width of features

 for f = 1:weights
            feature5(f) = exp((-(abs(7-centers(f)))^2)/(2*sigma^2));
 end

maxstep = 200000;

%Set initial values of alpha, gamma and epsilon 
exponent = 0;
alpha = 0.2;
gamma = 0.95;
epsilon = 0.1;

%Load demand profile - 'ConsumptionProfile' is normalised.
demand = load('ConsumptionProfile');
demand = demand.dcon;

S0 = [10 1]';       % set initial state S0(h,t)

%Create demand vector
jjj = 1;
for jj = 1:maxstep
    demandvector(jj) = 3.2*demand(jjj);
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
        
        newstate = nextstatefunctionapprox(state, Q, epsilon,h,demand,timediscretisation,ii,exponent);    %gives new height and next time, and action
        action = newstate(3);
        
        Qold = squeeze(w(action,time,:))'*feature';          %store Q value
        oldfeature = feature;                                %store features
        
        time = newstate(2);      %update time
        
        Cost = action^3 + QuadBarrierFunc(newstate(1));            %cost = E + b(h)    ->    cost = q*p+b(h)  =   q*(q^2+q)
        
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
        decayrate(ii) = alpha*exp(-ii*exponent);
        
        state = newstate(1:2);
        pump(ii) = action;
        
        Q5(ep,ii) = squeeze(w(2,7,:))'*feature5';
        
        weighttest1(:,ii) = squeeze(w(1,7,:));
%         weighttest2(ii,:) = w(2,12,:);
%         weighttest3(ii,:) = w(3,12,:);
    end
end

heightepisode(ep,:) = Tanklevel;

% bc = 1;
% for b = 24:24:maxstep
%     EPaveragecost(bc) = movmean(Costi,100);
%     bc = bc + 1;
% end
    EPaveragecost = movmean(Costi,4*24*60);

%mean(Costi(maxstep*0.8:maxstep*0.9))
mean(Costi(maxstep*0.9:maxstep))
mean(Tanklevel(maxstep*0.9:maxstep))
end

%  figure()
%  plot(weighttest1(1,:))
%  hold on
% for plots = 2:weights
%     plot(weighttest1(plots,:))
% end

 % figure()
% plot(weighttest2)
% figure()
% plot(weighttest3)

%% Plots 
%clc

figure(1)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    %ylim([-1 h+1]);
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

% exportgraphics(figure(1), fullfile('..\Report\figures','FuncApproxRL1.pdf'))

%Zoomed 5 plot
figure(2)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    ylim([min(Tanklevel(maxstep-100:maxstep))-1 max(Tanklevel(maxstep-100:maxstep))+1]);
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
    xlim([maxstep-100 maxstep])

%exportgraphics(figure(2), fullfile('..\Report\figures','FuncApproxRL1Zoomed.pdf'))



% figure()
% plot(actualheight)

% %Plot a Qvalue in function approximation
figure(3)
plot(Q5')
title('$\hat{Q}(h,t,a,w)$')
% exportgraphics(figure(3), fullfile('..\Report\figures','FuncApproxQConverge.pdf'))

figure()
plot(EPaveragecost)