function [newQ = CalculateStep(currentPos,RewardMatrix,epsilon)
%CalculateStep Calculates the next step on the grid
[max_x,max_y] = size(RewardMatrix);

PosPos = zeros(2,4);

PosPos(:,1) = currentPos + [-1;0];
PosPos(:,2) = currentPos + [0;-1];
PosPos(:,3) = currentPos + [1;0];
PosPos(:,4) = currentPos + [0;1];

for ii = 1:length(PosPos)
    Posx(ii) = PosPos(1,ii); Posy(ii) = PosPos(2,ii);                                                       %create the 4 possible positions
    if ((1 <= Posx(ii)) && (Posx(ii) <= max_x)) && ((1 <= Posy(ii)) && (Posy(ii) <= max_y))
        Q(currentPos(2),currentPos(1)) = -1 + gamma*(Q(Posy(ii),Posi(ii)));
    else
        Q(Positions(2,ii),Positions(1,ii)) = nan;
    end
end

newQ = Q;

% [val,idx] = max(Reward);
% 
% if rand >= epsilon
%     newPos = [Posx(idx);Posy(idx)];
% else
%     for jj = 1:100;
%         ran = randi([1 4]);
%         if Reward(ran) > 0 | Reward(ran) < 0
%             newPos = [Posx(ran);Posy(ran)];
%             break
%         end
%     end
% end
end


