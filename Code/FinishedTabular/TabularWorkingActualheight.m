clc; clear all; close all; warning off
ColorSet = varycolor(50);
for ep = 1:50
maxstep = 50000;                       %how many steps to simulate
                           
timediscretisation = 24;                %discretisation of time into hours

 nStates = size(15:55,2) + 1;

Q = 0*ones(nStates,timediscretisation,3);              %initialise Q to 0

alpha = 0.1;% + 0.125*ep;            %0.8
gamma = 0.77;% + 0.11*ep;                         %0.95
epsilon = 0.1;% + 0.01*ep;

%load demand data
demand = load('ConsumptionProfile');
demand = demand.dcon*5.77+5;

%Initial height
h0 = 35;
%Initial state
S0 = [ceil(h0-14) 1]';
% S0 = [floor(((max_h)-10)/2) 1]';


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
    actualh = h0;
    
    for ii = 1:maxstep                               %begin simulation loop
       
        %loop for testing purpose
        if ii > 0.9*maxstep
            alpha = 0.;
            epsilon = 0.0;
            
        end
        
        newstate = nextstateActualheight(state, Q, epsilon,demand,timediscretisation,actualh);    %gives new height, next time, and best action action
        action = newstate(3);
        actualh = newstate(4);
        flow = newstate(5);
        
        %Cost = action^3 + QuadBarrierFunc(newstate(1));            %cost = E + b(h)    -> simplified to a cost of action (= pump flow (q)) and Barrierfunction (h)
%       Cost = action^3 + QuadBarrierFuncActualHeight(actualh);
        P = 1000*9.82*0.1*actualh;
%       Cost = flow*P*0.9 + 13*QuadBarrierFuncActualHeight(actualh);
        Cost = flow*P*1.667*10^-5 + QuadBarrierFuncActualHeight(actualh);
        
        actualhi(ii) = actualh;
        Costi(ii) = Cost;                            %store cost in a vector for later use
               
        %update Q
        Q(state(1),state(2),action) = Q(state(1),state(2),action) + alpha*(Cost + gamma*min(Q(newstate(1),newstate(2),:))-Q(state(1),state(2),action));
        
        %plotting variables
        Tanklevel(ii) = state(1);
        pump(ii) = action;
        
        %update state
        state = newstate(1:2);

        Q1(ii) = Q(30,1,1);
        Q2(ii) = Q(30,1,2);
        Q3(ii) = Q(30,1,3);
    end
end


heightepisode(ep,:) = Tanklevel;
EPaveragecost(ep,:) = movmean(Costi,4*24*60);
% EPaveragecost(ep,:) = movmean(Costi,4*24);

end

% figure(10)
% plot(Q1)
% hold on
% plot(Q2)
% plot(Q3)
% hold off
%% figures
 figure(1)
    ha(1)=subplot(4,1,1);
    plot(Tanklevel)
    ylim([-1 nStates+5]);
    title('height')
    ha(2)=subplot(4,1,2);
    plot(demandvector)
    title('demand')
    ha(3)=subplot(4,1,3);
    plot(pump)
    title('pump')
    ha(4)=subplot(4,1,4);
    plot(Costi)%,'linestyle','none','marker', 'o')
    title('cost')
    linkaxes(ha,'x')
% %exportgraphics(figure(1), fullfile('..\Report\figures','FullTabularSimulation.pdf'))

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
%     ha(4)=subplot(4,1,4);
%     plot(Costi)%,'linestyle','none','marker', 'o')
%     title('Cost $J$')
%     linkaxes(ha,'x')
%     xlim([maxstep-100 maxstep])
%     ylim([min(Costi(maxstep-100:maxstep))-2 max(Costi(maxstep-100:maxstep))+2]);
%     %exportgraphics(figure(3), fullfile('..\Report\figures','FullTabularSimulationZoom.pdf'))
%     

%Normal movmean cost plot
% for i = 1:ep
% figure(3)
% plot(EPaveragecost(i,:), 'Color', ColorSet(i,:))
% hold on
% title('$\gamma$ hyperparameter sweep')
% %legend('$\gamma$=0.82','$\gamma$=0.84','$\gamma$=0.86','$\gamma$=0.88','$\gamma$=0.9','$\gamma$=0.92','$\gamma$=0.94','$\gamma$=0.96','$\gamma$=0.98','$\gamma$=1')
% %legend('$\alpha$=0.1','$\alpha$=0.2','$\alpha$=0.3','$\alpha$=0.4','$\alpha$=0.5','$\alpha$=0.6','$\alpha$=0.7','$\alpha$=0.8','$\alpha$=0.9','$\alpha$=1','location','best')
% legend()
% xlabel('Iteration') 
% ylabel('Movingaverage cost') 
% end
% hold off

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
% axes('Position',[.24 .48 .46 .42])
% box on
% for i = 1:ep
% plot(EPaveragecost(i,:), 'Color', ColorSet(i,:))
% hold on
% xlim([0.0 0.4*maxstep])
% ylim([2.5 5])
% end
% hold off

%exportgraphics(figure(3), fullfile('..\..\Report\figures','GammaSweepTabRealH.pdf'))


% 
% 
figure(5)
plot(actualhi)

statemean =movmean(Tanklevel,100);
figure(11)
plot(statemean)
xlim([0 2000])
ylim([0 20])
hold on 
syms h
fplot(30/3200 * h)
hold off

figure(3)
title('50 Simulations $\alpha = 0.1$')
legend('$\gamma$=0.11','$\gamma$=0.22','$\gamma$=0.33','$\gamma$=0.44','$\gamma$=0.55','$\gamma$=0.66','$\gamma$=0.77','$\gamma$=0.88','$\gamma$=0.99','$\gamma$=1')
%legend('$\alpha$=0.125','$\alpha$=0.25','$\alpha$=0.375','$\alpha$=0.5','$\alpha$=0.625','$\alpha$=0.75','$\alpha$=0.875','$\alpha$=1','$\alpha$=0.9','$\alpha$=1','location','best')
%legend('$\epsilon$=0.1','$\epsilon$=0.2','$\epsilon$=0.3','$\epsilon$=0.4','$\epsilon$=0.5','$\epsilon$=0.75','$\epsilon$=0.875','$\epsilon$=1','$\alpha$=0.9','$\alpha$=1','location','best')
legend()
xlabel('Iteration') 
ylabel('Movingaverage cost')
legend('off')
ylim([2.4 3.4])
xlim([48000 maxstep])

%exportgraphics(figure(3), fullfile('..\Report\figures','50plot.pdf'))
