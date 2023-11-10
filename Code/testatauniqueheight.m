close all; clc;

for ep = 1:1

h = 20;                     %Set max height
timediscretisation = 24;    %Set

Q = [0 0 0];

time = 1;
actions = 3;
weights = 10;
%w = zeros(actions,timediscretisation,weights);                              %a row of weights for each action
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

maxstep = 2000;

%Set initial values of alpha, gamma and epsilon 
exponent = 0;
alpha = 0.0;
gamma = 0.;
epsilon = 0;

%Load demand profile - 'ConsumptionProfile' is normalised.
demand = load('ConsumptionProfile');
demand = demand.dcon;

S0 = [5+2.1 1]';       % set initial state S0(h,t)

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
    state = S0;
    
%     if episode == 2
%         state = [5+2.1 1]
%        maxstep = 2000;
%     alpha = 0;
%     epsilon = 0;
%     end
    
    for ii = 1:maxstep
        
        %turn of learning and randomnes for the last 10%
        if ii > 0.95*maxstep
            alpha = 0.002;
            epsilon = 0;
        end
        
        newstate = nextstatefunctionapprox(state, Q, epsilon,h,demand,timediscretisation,ii,exponent);    %gives new height and next time, and action
        action = newstate(3);
        
        Qold = squeeze(w(action,time,:))'*feature';          %store Q value
        oldfeature = feature;                                %store features
        
        time = newstate(2);      %update time
        
        Cost = action^2.2 + 3*QuadBarrierFunc(newstate(1));            %cost = E + b(h)    ->    cost = q*p+b(h)  =   q*(q^2+q)
        
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

    end

end

