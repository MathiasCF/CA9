clc
clear all
close all
warning off
for ep = 1:3

maxstep = 2000;                       %how many steps to simulate

max_h = 70;                             %max allowable height
timediscretisation = 24;                %discretisation of time into hours

Q = 0*ones(max_h,timediscretisation,3);              %initialise Q to 0
% Q(1,:,1:2) = 100;
% Q(2,:,1:2) = 100;
% Q(3,:,1:2) = 100;
% Q(4,:,1:2) = 100;

exponent = 0;%5/maxstep;                            %exponential decay, 5/maxstep or 0
alpha = 0.01;% + 0.1*ep;            %0.8
gamma = 0.9;% + 0.01*ep;                         %0.95
epsilon = 0.0;% + 0.02*ep;

%load demand data
demand = load('ConsumptionProfile');
%demand = demand.dcon*3.8;
demand = demand.dcon*0.96;

%demand = [1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 ];

%Initial state
S0 = [floor(((max_h/2)-10)/2) 1]';
% S0 = [floor(((12)-10)/2) 1]';


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
    actualh = 12;
    
    for ii = 1:maxstep                               %begin simulation loop
        
        %loop for testing purpose
        if ii > 0.9*maxstep
            alpha = 0.0;
            epsilon = 0.0;
            
        end
%         if ii == 1*maxstep
%             
%             demand = demand*1.1;
%         end
        
        newstate = nextstateActualheight(state, Q, epsilon,max_h,demand,timediscretisation,ii,exponent,actualh);    %gives new height, next time, and best action action
        action = newstate(3);
        actualh = newstate(4);
        
        %Cost = action^3 + QuadBarrierFunc(newstate(1));            %cost = E + b(h)    -> simplified to a cost of action (= pump flow (q)) and Barrierfunction (h)
        Cost = action^3 + QuadBarrierFuncActualHeight(actualh);
        
        actualhi(ii) = actualh;
        Costi(ii) = Cost;                            %store cost in a vector for later use
        
%         if ii > 1660 && ii < 1710
%             count = count + 1;
%             timetest(count) = state(2);
%             Qnewtest(count) = min(Q(newstate(1),newstate(2),:));
%             Qtest(count) = Q(state(1),state(2),action);
%         end
        
        %update Q
        Q(state(1),state(2),action) = Q(state(1),state(2),action) + alpha*exp(-ii*exponent)*(Cost + gamma*min(Q(newstate(1),newstate(2),:))-Q(state(1),state(2),action));
        
        
        Qs1(ii) = Q(15,22,1);
        Qs2(ii) = Q(15,22,2);
        Qs3(ii) = Q(15,22,3);
        
        %plotting variables
        Tanklevel(ii) = state(1);
        decayrate(ii) = alpha*exp(-ii*exponent);
        pump(ii) = action;
        
        %update state
        state = newstate(1:2);
    end
end
heightepisode(ep,:) = Tanklevel;
EPaveragecost(ep,:) = movmean(Costi,4*24*60);
% EPaveragecost(ep,:) = movmean(Costi,4*24);

end
%% figures
 figure(1)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    ylim([-1 26]);
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
% %exportgraphics(figure(1), fullfile('..\Report\figures','FullTabularSimulation.pdf'))
% 
% %print means for debugging
% % mean(Costi(maxstep*0.8:maxstep*0.9))
% % mean(Costi(maxstep*0.9:maxstep))
% % mean(Tanklevel(maxstep*0.9:maxstep))


% % %testing figure
% figure(2)
% plot(Qs1)
% hold on
% plot(Qs2)
% plot(Qs3)
% hold off
% title('Q at height = 5 time = 22')
% legend({'$Q(5,22,1)$','$Q(5,22,2)$','$Q(5,22,3)$'},'Location','best')

% %exportgraphics(figure(2), fullfile('..\Report\figures','FullTabularSimulationConvS_5_22.pdf'))
% 
% % plot last 100 samples
% figure(3)
%     ha(1)=subplot(4,1,1);
%     plot(Tanklevel)
%     ylim([min(Tanklevel(maxstep-100:maxstep))-1 max(Tanklevel(maxstep-100:maxstep))+1]);
%     title('Water level in elevated water reservoir')
% 
%     ha(2)=subplot(4,1,2);
%     plot(demandvector)
%     title('Demand')
%     ylim([min(demandvector(maxstep-100:maxstep))-1 max(demandvector(maxstep-100:maxstep))+1]);
%     
%     ha(3)=subplot(4,1,3);
%     plot(pump)
%     title('Action')
%     ylim([min(pump(maxstep-100:maxstep))-1 max(pump(maxstep-100:maxstep))+1]);
% %     ha(4)=subplot(5,1,4);
% %     plot(decayrate)   
% %     title('decayrate')
% 
%     ha(4)=subplot(4,1,4);
%     plot(Costi)%,'linestyle','none','marker', 'o')
%     title('Cost $J$')
%     linkaxes(ha,'x')
%     xlim([maxstep-100 maxstep])
%     ylim([min(Costi(maxstep-100:maxstep))-2 max(Costi(maxstep-100:maxstep))+2]);
%     %exportgraphics(figure(3), fullfile('..\Report\figures','FullTabularSimulationZoom.pdf'))
%     
    
%%
%clc
% 
% for i = 1:ep
%     figure(2)
%     plot(heightepisode(i,:))
%     title('Episode', i)
% end

% %EPaveragecost = movmean(Costi,4*24*60);
for i = 1:ep
figure(3)
plot(EPaveragecost(i,:))
hold on
title('$\gamma$ hyperparameter sweep')
legend('$\gamma$=0.82','$\gamma$=0.84','$\gamma$=0.86','$\gamma$=0.88','$\gamma$=0.9','$\gamma$=0.92','$\gamma$=0.94','$\gamma$=0.96','$\gamma$=0.98','$\gamma$=1')
%legend('$\alpha$=0.1','$\alpha$=0.2','$\alpha$=0.3','$\alpha$=0.4','$\alpha$=0.5','$\alpha$=0.6','$\alpha$=0.7','$\alpha$=0.8','$\alpha$=0.9','$\alpha$=1','location','best')
xlabel('Iteration') 
ylabel('Movingaverage cost') 
end
hold off

% for i = 10:ep
% figure(4)
% hold on
% plot(EPaveragecost(i,:))
% title('Episode', i)
% legend('1','2','3','4','5','6')
% end
%exportgraphics(figure(4), fullfile('..\Report\figures','FullTabularSimulationMACost.pdf'))


figure()
plot(actualhi)