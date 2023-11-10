clear all
close all
clc

Gridsize = 8;
GoalPos = [8 8]';                                         
CheesePos = [2 4]';
Q = zeros(Gridsize,Gridsize,4);                                 %initialize value grid

%Q(1,1,:) = [1 2 4 3];

converged = 0;

maxsteps = 100;


Goal = 0;                                           %Goal flag
alpha = 0.5;
gamma = 0.8;
epsilon = 0.2;
maxepisodes = 5000;

for episodes = 1:maxepisodes;
    episodes;
    CheeseTaken = 0;
    clear Positions;
    clear R
    
    startPos = [1;1];
    Positions(:,1) = startPos;
    
    for ii = 1:maxsteps
        Cheese = 0;
        
        [Positions(:,ii+1),idx] = CalculateStep_QLearning_grid(Positions(:,ii),Q,epsilon);
        
        if Positions(:,ii+1) == GoalPos;                                                                  %check if in goal position
            Goal = 1;
        end
        
        if Positions(1,ii) == CheesePos(1) && Positions(2,ii) == CheesePos(2) && CheeseTaken == 0;
           Cheese = 1;
           CheeseTaken = 1;
        end
        
        R(ii) = -1 - 0.2*abs(3-Positions(2,ii+1)) + 0*Cheese + 30*Goal;
        
        Q(Positions(2,ii),Positions(1,ii),idx) = Q(Positions(2,ii),Positions(1,ii),idx) + alpha*(R(ii) + gamma*(Q(Positions(2,ii+1),Positions(1,ii+1),idx)-Q(Positions(2,ii),Positions(1,ii),idx)));
        Positions;
        
        if Positions(:,ii+1) == GoalPos;
            %Q(GoalPos(1),GoalPos(2),idx) = 1000;
            Goal = 0;
            break
        end
        %Q
        %pause(0.1)
    end
    
    
    TotalR(episodes) = sum(R);
    if sum(R) < -3
        Magic = Positions;
    end
    if episodes == 1 | episodes == maxepisodes/10 | episodes == maxepisodes/8 | episodes == maxepisodes/6 | episodes == maxepisodes/4 | episodes == maxepisodes/2 | episodes == maxepisodes/1 | (episodes > 9990 && episodes < 10010)
    figure()
    plot(Positions(1,:),-Positions(2,:))
    
    xlim([0 Gridsize+1])
    ylim([-(Gridsize+1) 0])
    %SavedPositions(episodes) = Positions;
    episodes;
    end
    if episodes > 100 && sum(TotalR(episodes)) > 300 && converged == 0
        converged = 1;
        episodeconverge = episodes
        Convergepos = Positions
    end
   
end
figure()
plot(TotalR)
title("Error")
  

figure()
plot(Positions(1,:),-Positions(2,:))
    
xlim([0 Gridsize+1])
ylim([-(Gridsize+1) 0])
