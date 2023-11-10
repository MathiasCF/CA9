clc
clear all
close all

h = 20; %max height
timediscretisation = 24;

Q = [0 0 0];

time = 1;
actions = 3;
weights = 5;
w = zeros(actions,timediscretisation,weights);                              %a row of weights for each action
% w(3,:,5) = 0;
% w(2,:,5) = 0;
% w(1,:,1) = 0;

%centers = [0 5 10 15 20];%[1 2 3 4 5]*h/weights;                            %uniformly distributed centers
for c = 1:weights
    centers(c) = (c-1)*h/(weights-1);
end

feature = zeros(1,weights);
sigma = 2;                                            %width of features



maxstep = 500000;

exponent = 0;%5/maxstep;
alpha = 0.2;
gamma = 0.9;
epsilon = 0.1;

demand = load('ConsumptionProfile');
demand = demand.dcon;

S0 = [10 1]';       %S0(h,t)

%for plotting
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
        
        Cost = action^2.2 + QuadBarrierFunc(newstate(1));            %cost = E + b(h)    ->    cost = q*p+b(h)  =   q*(q^2+q)
        
        Costi(ii) = Cost;
        
        %update features at new height
        for f = 1:weights
            feature(f) = exp((-(abs(state(1)-centers(f)))^2)/(2*sigma^2));
        end
        
        %update Q values with new features
        for n = 1:3
            Q(n) = squeeze(w(n,time,:))'*feature';
        end
        
        %update weights, special case for time = 1
        if time == 1
            w(action,timediscretisation,:) = squeeze(w(action,timediscretisation,:))' + alpha*exp(-ii*exponent)*(Cost + gamma*min(Q) - Qold).*oldfeature;
        else
            w(action,time-1,:) = squeeze(w(action,time-1,:))' + alpha*exp(-ii*exponent)*(Cost + gamma*min(Q) - Qold).*oldfeature;
        end
        
        %update Q with new weights and new features
        for n = 1:3
            Q(n) = squeeze(w(n,time,:))'*feature';
        end
        
        Tanklevel(ii) = state(1);
        decayrate(ii) = alpha*exp(-ii*exponent);
        
        state = newstate(1:2);
        pump(ii) = action;
        
         weighttest1(:,ii) = squeeze(w(1,10,:));
%         weighttest2(ii,:) = w(2,12,:);
%         weighttest3(ii,:) = w(3,12,:);
    end
    
    figure()
    ha(1)=subplot(5,1,1);
    plot(Tanklevel)
    ylim([-1 h+1]);
    title('height')
    ha(2)=subplot(5,1,2);
    plot(demandvector)
    title('demand')
    ha(3)=subplot(5,1,3);
    plot(pump)
    title('pump')
    ha(4)=subplot(5,1,4);
    plot(decayrate)
    title('decayrate')
    ha(5)=subplot(5,1,5);
    plot(Costi)%,'linestyle','none','marker', 'o')
    title('cost')
    legend('1','2','3')
    linkaxes(ha,'x')
end

mean(Costi(maxstep*0.8:maxstep*0.9))
mean(Costi(maxstep*0.9:maxstep))
mean(Tanklevel(maxstep*0.9:maxstep))

 figure()
 plot(weighttest1(1,:))
 hold on
 plot(weighttest1(2,:))
 plot(weighttest1(3,:))
 plot(weighttest1(4,:))
 plot(weighttest1(5,:))
% figure()
% plot(weighttest2)
% figure()
% plot(weighttest3)
