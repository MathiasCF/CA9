clc
clear all
close all

maxstep = 200000;                       %how many steps to simulate

max_h = 20;                             %max allowable height
timediscretisation = 24;                %discretisation of time into hours

Q = zeros(max_h,timediscretisation,3);              %initialise Q to 0
%Q(1,:,1:2) = 100;
%Q(2,:,1:2) = 100;

exponent = 0;%5/maxstep;                            %exponential decay, 5/maxstep or 0
alpha = 0.2;
gamma = 0.95;
epsilon = 0.1;

%load demand data
demand = load('ConsumptionProfile');
demand = demand.dcon*3.2;
%demand = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 ];

%Initial state
S0 = [max_h/2 1]';


%for plotting
jjj = 1;
for jj = 1:maxstep
    demandvector(jj) = demand(jjj);  %1+1.8*
    jjj = jjj + 1;
    if mod(jj,24) == 0
        jjj = 1;
    end
end

%--------------------------------------------------------------------------
for episode = 1:1                               %run 1 episode to simulate laboratorie (real world has one continious episode)
    state = S0;                                      %set initial state
    
    for ii = 1:maxstep                               %begin simulation loop
        
        %loop for testing purpose
        if ii > 0.9*maxstep
            alpha = 0.0;
            epsilon = 0.0;
        end
        
        
        newstate = nextstateREDUCEDSTATESPACE(state, Q, epsilon,max_h,demand,timediscretisation,ii,exponent);    %gives new height, next time, and best action action
        action = newstate(3);
        
        Cost = action^3 + QuadBarrierFunc(newstate(1));            %cost = E + b(h)    -> simplified to a cost of action (= pump flow (q)) and Barrierfunction (h)
        
        Costi(ii) = Cost;                            %store cost in a vector for later use
        
%         if ii > 1660 && ii < 1710
%             count = count + 1;
%             timetest(count) = state(2);
%             Qnewtest(count) = min(Q(newstate(1),newstate(2),:));
%             Qtest(count) = Q(state(1),state(2),action);
%         end
        
        %update Q
        Q(state(1),state(2),action) = Q(state(1),state(2),action) + alpha*exp(-ii*exponent)*(Cost + gamma*min(Q(newstate(1),newstate(2),:))-Q(state(1),state(2),action));
        
        
        %BIGissue(ii) = Cost + gamma*min(Q(newstate(1),newstate(2),:))-Q(state(1),state(2),action);
        Qs1(ii) = Q(5,22,1);
        Qs2(ii) = Q(5,22,2);
        Qs3(ii) = Q(5,22,3);
        
        %plotting variables
        Tanklevel(ii) = state(1);
        decayrate(ii) = alpha*exp(-ii*exponent);
        pump(ii) = action;
        
        %update state
        state = newstate(1:2);
    end
end

%% figures
 figure(1)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    ylim([-1 max_h+1]);
    title('height')
    ha(2)=subplot(4,1,2);
    plot(demandvector)
    title('demand')
    ha(3)=subplot(4,1,3);
    plot(pump)
    title('pump')
%     ha(4)=subplot(5,1,4);
%     plot(decayrate)   
%     title('decayrate')
    ha(4)=subplot(4,1,4);
    plot(Costi)%,'linestyle','none','marker', 'o')
    title('cost')
    linkaxes(ha,'x')
%exportgraphics(figure(1), fullfile('..\Report\figures','FullTabularSimulation.pdf'))

%print means for debugging
% mean(Costi(maxstep*0.8:maxstep*0.9))
% mean(Costi(maxstep*0.9:maxstep))
% mean(Tanklevel(maxstep*0.9:maxstep))

%testing figure
figure(2)
plot(Qs1)
hold on
plot(Qs2)
plot(Qs3)
hold off
title('Q at height = 5 time = 22')
legend({'$Q(5,22,1)$','$Q(5,22,2)$','$Q(5,22,3)$'},'Location','best')
%exportgraphics(figure(2), fullfile('..\Report\figures','FullTabularSimulationConvS_5_22.pdf'))

% plot last 100 samples
figure(3)
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
    %exportgraphics(figure(3), fullfile('..\Report\figures','FullTabularSimulationZoom.pdf'))
    
    
%%    
clc
EPaveragecost = movmean(Costi,4*24*60);
figure(4)
plot(EPaveragecost)
title('Moving average cost')
exportgraphics(figure(4), fullfile('..\Report\figures','FullTabularSimulationMACost.pdf'))