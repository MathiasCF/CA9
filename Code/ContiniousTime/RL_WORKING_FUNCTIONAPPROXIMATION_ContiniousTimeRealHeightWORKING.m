clear all; close all; clc;

for ep = 1:5

h = 70;                     %Set max height
timediscretisation = 24;    %Set

f0 = 1/24;

Q = [0 0 0];

time = 1;
actions = 3;
weights = 5;
tweights = 5;

w = zeros(actions,weights+tweights);                              %a row of weights for each action

%place uniformly distributed weights
for c = 1:weights
    centers(c) = (c-1)*(h+20)/(weights-1);
    centers(c) = centers(c) - 10;
end

feature = zeros(1,weights);                      %Initialise features to zero
tfeature = zeros(1,tweights);

sigma = 6.5;%2.5;% + 0.5*ep;                                            %width of features

maxstep = 10000;

%Set initial values of alpha, gamma and epsilon 
exponent = 0;
alpha = 0.005;% + 0.1*ep;
gamma = 0.96;
epsilon = 0.000;

%Load demand profile - 'ConsumptionProfile' is normalised.
demand = load('ConsumptionProfile');
demand = demand.dcon;
%demand = demand*0 + 2;

S0 = [h/2 1]';       % set initial state S0(h,t)

 for f = 1:weights
            feature5(f) = exp((-(abs(5-centers(f)))^2)/(2*sigma^2));
 end
 t = 10;
 f0 = 1/24;
%          feature5(6) = 1;
%          feature5(7) = sin(2*pi*f0*t);
%          feature5(8) = cos(2*pi*f0*t);
%         
%         feature5(9) = sin(4*pi*f0*t);
%         feature5(10) = cos(4*pi*f0*t);
% 
% 
%         
%          feature5(11) = sin(6*pi*f0*t);
%          feature5(12) = cos(6*pi*f0*t);
 

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
        
        newstate = nextstatecontinioustimeRealHeight(state, Q, epsilon,h,demand,timediscretisation,ii,exponent);    %gives new height and next time, and action
        action = newstate(3);
        
        Qold = w(action,:)*[feature tfeature]';          %store Q value
        oldfeature = [feature tfeature];                                %store features
        
        t = newstate(2);      %update time
        
        Cost = action^3 + QuadBarrierFuncActualHeight(newstate(1));            %cost = E + b(h)    ->    cost = q*p+b(h)  =   q*(q^2+q)
        
        Costi(ii) = Cost;
        
        %update features at new height
        for f = 1:weights
            feature(f) = exp((-(abs(newstate(1)-centers(f)))^2)/(2*sigma^2));           %newstate instead of state???
        end

        %-compute features for time--------------------------------------
         tfeature(1) = 1;
         tfeature(2) = sin(2*pi*f0*t);
         tfeature(3) = cos(2*pi*f0*t);
%         
        tfeature(4) = sin(4*pi*f0*t);
        tfeature(5) = cos(4*pi*f0*t);
% 
% 
%         
%          tfeature(6) = sin(6*pi*f0*t);
%          tfeature(7) = cos(6*pi*f0*t);
%         
%          tfeature(8) = sin(8*pi*f0*t);
%          tfeature(9) = cos(8*pi*f0*t);
% 
%          tfeature(10) = sin(12*pi*f0*t);
%          tfeature(11) = cos(12*pi*f0*t);
        
        %update Q values with new features
        for n = 1:3
            Q(n) = w(n,:)*[feature tfeature]';
        end
        
        %update weights, special case for time = 1
        w(action,:) = w(action,:) + alpha*(Cost + gamma*min(Q) - Qold).*oldfeature;
        
        
        %update Q with new weights and new features
        for n = 1:3
            Q(n) = w(n,:)*[feature tfeature]';
        end
        
%         Q1(ep,ii) = w(1,:)*feature5';
%         Q2(ep,ii) = w(2,:)*feature5';       
%         Q3(ep,ii) = w(3,:)*feature5';
        
        Tanklevel(ii) = state(1);
        decayrate(ii) = alpha*exp(-ii*exponent);
        
        state = newstate(1:2);
        pump(ii) = action;
    end
end

heightepisode(ep,:) = Tanklevel;

% bc = 1;
% for b = 24:24:maxstep
%     EPaveragecost(bc) = movmean(Costi,100);
%     bc = bc + 1;
% end
EPaveragecost(ep,:) = movmean(Costi,25*24);

%mean(Costi(maxstep*0.8:maxstep*0.9))
mean(Costi(maxstep*0.9:maxstep))
mean(Tanklevel(maxstep*0.9:maxstep))
end



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

%exportgraphics(figure(1), fullfile('..\Report\figures','FuncApproxRL111.pdf'))

%Zoomed 5 plot
% figure(2)
%     ha(1)=subplot(4,1,1);
%     plot(Tanklevel)
%     ylim([min(Tanklevel(maxstep-100:maxstep))-1 max(Tanklevel(maxstep-100:maxstep))+1]);
%     title('Water level in elevated water reservoir')
% 
%     ha(2)=subplot(4,1,2);
%     plot(demandvector)
%     title('Demand')
%     
%     ha(3)=subplot(4,1,3);
%     plot(pump)
%     title('Action')
% %     ha(4)=subplot(5,1,4);
% %     plot(decayrate)   
% %     title('decayrate')
%     ha(4)=subplot(4,1,4);
%     plot(Costi)%,'linestyle','none','marker', 'o')
%     title('Cost $J$')
%     linkaxes(ha,'x')
%     xlim([maxstep-100 maxstep])

%exportgraphics(figure(2), fullfile('..\Report\figures','FuncApproxRL1Zoomed111.pdf'))

% 
% for i = 1:ep
%     figure()
%     plot(heightepisode(i,:))
%     title('Episode', i)
% end

% %Plot a Qvalue in function approximation
% for i = 1:ep
% figure()
% plot(Q1(i,:)')
% hold on
% plot(Q2(i,:)')
% plot(Q3(i,:)')
% title('$\hat{Q}(h,\textbf{w}_{t,a})$ EPISODE is',i)
% legend('$\hat{Q}\big(5,\textbf{w}_{22,1}\big)$', '$$\hat{Q}\big(5,\textbf{w}_{22,2}\big)$', '$$\hat{Q}\big(5,\textbf{w}_{22,3}\big)$','location','best')
% end
%exportgraphics(figure(3), fullfile('..\Report\figures','HeightFuncApproxQConverge.pdf.pdf'))

%EPaveragecost = movmean(Costi,4*24*60);
for i = 1:ep
figure(3)
plot(EPaveragecost(i,:))
hold on
title('$\epsilon$ hyperparameter sweep')
legend('$\epsilon$=0','$\epsilon$=0.1','$\epsilon$=0.2','$\epsilon$=0.3','$\epsilon$=0.4','$\epsilon$=0.5','$\gamma$=0.6','$\gamma$=0.7','$\gamma$=0.8','$\gamma$=0.9')
%legend('$\alpha$=0.125','$\alpha$=0.25','$\alpha$=0.375','$\alpha$=0.5','$\alpha$=0.625','$\alpha$=0.75','$\alpha$=0.875','$\alpha$=1','$\alpha$=0.9','$\alpha$=1','location','best')
xlabel('Iteration') 
ylabel('Movingaverage cost')
%ylim([0 inf])
end

% axes('Position',[.23 .6 .48 .3])
% box on
% for i = 1:ep
% plot(EPaveragecost(i,:))
% hold on
% 
% end
hold off
%exportgraphics(figure(3), fullfile('..\Report\figures','AlphaSweepApprox11.pdf'))
