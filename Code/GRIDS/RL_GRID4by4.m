clear all
close all
clc

OS = 4;
%Q = [1 2 3 4; 1 2 5 6; 1 2 8 8; 1 2 10 12];
Q = ones(OS);

%startPos = [1;1];

N = 100;

%Positions = zeros(2,N);
%Positions(:,1) = startPos;

Goal = 0;
alpha = 0.4;
gamma = 0.1;
epsilon = 0.2;
maxepisodes = 1000;

for episodes = 1:maxepisodes;
    
    if episodes > 0.9*maxepisodes
        epsilon = 0;
    end
    
    clear Positions;
    clear R
    startPos = [1;1];
    Positions(:,1) = startPos;
    for ii = 1:N
        Positions(:,ii+1) = CalculateStep4x4(Positions(:,ii),Q,epsilon);
        if Positions(:,ii+1) == [OS OS]';
            Goal = 1;
        end
    
        R(ii) = -0.1 - 0.2*abs(3-Positions(2,ii));
        Q(Positions(2,ii),Positions(1,ii)) = Q(Positions(2,ii),Positions(1,ii)) + alpha*(R(ii) + gamma*(Q(Positions(2,ii+1),Positions(1,ii+1))-Q(Positions(2,ii),Positions(1,ii))));
        if Goal == 1;
            Q(OS,OS) = alpha*50;
            Goal = 0;
            break
        end
    end
    TotalR(episodes) = sum(R);
    if episodes > 1000
    figure()
    plot(Positions(1,:),-Positions(2,:))
    xlim([0 OS+1])
    ylim([-(OS+1) 0])
    Positions(episodes) = Positions;
    episodes
    end
end
figure()
plot(TotalR)

