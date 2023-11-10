clear all
close all
clc

Gridsize = 10;
GoalPos = [10 10]';                                         %
CheesePos = [2 4]';
Q = ones(Gridsize);                                 %initialize value grid

converged = 0;

N = 100;

%Positions = zeros(2,N);
%Positions(:,1) = startPos;

Goal = 0;                                           %Goal flag
alpha = 0.5;
gamma = 0.1;
epsilon = 0.05;
maxepisodes = 1500;

for episodes = 1:maxepisodes;
    
    if episodes > 0.95*maxepisodes
        epsilon = 0;
    end
    
    CheeseTaken = 0;
    clear Positions;
    clear R
    startPos = [1;1];
    Positions(:,1) = startPos;
    for ii = 1:N
        Cheese = 0;
        Positions(:,ii+1) = CalculateStep_Universal_GRID(Positions(:,ii),Q,epsilon);
        if Positions(:,ii) == GoalPos;
            Goal = 1;
        end
        
        if Positions(1,ii) == CheesePos(1) && Positions(2,ii) == CheesePos(2) && CheeseTaken == 0;
           Cheese = 1;
           CheeseTaken = 1;
        end
        
        R(ii) = -0.1 - 0.2*abs(3-Positions(2,ii)) - 0*Cheese + 30*Goal;
        
        Q(Positions(2,ii),Positions(1,ii)) = Q(Positions(2,ii),Positions(1,ii)) + alpha*(R(ii) + gamma*(Q(Positions(2,ii+1),Positions(1,ii+1))-Q(Positions(2,ii),Positions(1,ii))));
        if Positions(:,ii+1) == GoalPos;
            Q(GoalPos(1),GoalPos(2)) = 0.1;
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
    if episodes == 1 | episodes == maxepisodes/10 | episodes == maxepisodes/8 | episodes == maxepisodes/6 | episodes == maxepisodes/4 | episodes == maxepisodes/2 | episodes == maxepisodes/1 | episodes > 7990
    figure()
    plot(Positions(1,:),-Positions(2,:))
    
    xlim([0 Gridsize+1])
    ylim([-(Gridsize+1) 0])
    %SavedPositions(episodes) = Positions;
    episodes;
    end
    if episodes > 10 && sum(TotalR(episodes-9:episodes))/10 > -8.2 && converged == 0
        converged = 1;
        episodeconverge = episodes
        Convergepos = Positions
    end
   
end
figure()
plot(TotalR)
title("Error")

