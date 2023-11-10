clear all; close all; clc; warning off;
for ep = 1:1
    %Input values of alpha, gamma and epsilon
    alpha = 0.4;
    gamma = 0.95;
    epsilon = 0.1;
    
    timediscretisation = 24;    %Set number of discrete times
    h=70;                       %Set height of tank [cm]

    Q = [0 0 0];                %Initialise Q

    time = 1;                   %Initalise time at k=1
    actions = 3;                %Input number of actions available 
    weights = 10;               %Input number of weights (RBFs) 

    %Create a weight vecotr for each action and time of length w
    w = zeros(actions,timediscretisation,weights); 

    %Place centers uniformly
    for c = 1:weights
        centers(c) = (c-1)*(h)/(weights-1);
    end
    
    sigma = 3.2;        %Set width RBFs 

    %load demand data
    demand = load('ConsumptionProfile');
    demand = demand.dcon*5.77+5;     %Demand balancing

    S0 = [h/2 1]';          %set initial state S0(h,t)
    for f = 1:weights       %Initialise feature to k=1 based on h0
        feature(f) = exp((-(abs(S0(1)-centers(f)))^2)/(2*sigma^2));
    end
 %-------------------------------------------------------------------------
    maxstep = 2000000; %Number of iterations
    for episode = 1:1
        state = S0;
        for ii = 1:maxstep
            %Calculate new h based on action chosen and increment time
            newstate = nextstatefunctionapprox(state, Q, epsilon,h,demand,timediscretisation);    
            action = newstate(3);       
            actualh = newstate(1);      
            flow = newstate(4);                         
            Qold = squeeze(w(action,time,:))'*feature';     %store Q value
            oldfeature = feature;                           %store features
            time = newstate(2);                             %update time
           
            %Cost function
            P = 1000*9.82*0.1*actualh;
            Cost = flow*P*1.667*10^-5 + QuadBarrierFuncActualHeight(actualh);
           
            %update features at new height
            for f = 1:weights
                feature(f) = exp((-(abs(newstate(1)-centers(f)))^2)/(2*sigma^2));          
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

            %Set new states
            state = newstate(1:2); 
        end
    end
end