clear all
close all
clc

Gridsize = 4;
GoalPos = [4 4]';                                         %
CheesePos = [2 4]';
Q = ones(Gridsize)*-1;                                 %initialize value grid

converged = 0;

N = 100;

Goal = 0;                                           %Goal flag
alpha = 0.5;
gamma = 0.1;
epsilon = 0.05;
maxepisodes = 1500;

for episodes = 1:maxepisodes;
    
    clear Positions;
    clear R
    startPos = [1;1];
    Positions(:,1) = startPos;
    for ii = 1:N
        %Positions(:,ii+1) = CalculateStep_SOS(Positions(:,ii),Q,epsilon);
        
       Q = 
        
        %Q(Positions(2,ii),Positions(1,ii)) = -1 + gamma*(Q(Positions(2,ii+1),Positions(1,ii+1),idx)-Q(Positions(2,ii),Positions(1,ii),idx)));
        
        
        
        if Positions(:,ii) == GoalPos;
            Goal = 1;
        end
       
        
        R(ii) = -1;
        
        if Positions(:,ii+1) == GoalPos;
            Q(GoalPos(1),GoalPos(2)) = 0.1;
            Goal = 0;
            break
        end
    end
end