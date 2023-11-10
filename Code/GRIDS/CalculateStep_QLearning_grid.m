function [newPos, idx] = CalculateStep(currentPos,Q,epsilon)
%CalculateStep Calculates the next step on the grid
[max_x,max_y] = size(Q,[1 2]);          %size of dimension 1 and 2

PosPos = zeros(2,4);

PosPos(:,1) = currentPos + [-1;0];  %left (1)
PosPos(:,2) = currentPos + [0;-1];  %up (2)
PosPos(:,3) = currentPos + [1;0];   %right (3)
PosPos(:,4) = currentPos + [0;1];   %down (4)

for ii = 1:length(PosPos)
    Posx(ii) = PosPos(1,ii); Posy(ii) = PosPos(2,ii);                                                       %create the 4 possible positions
    if ((1 <= Posx(ii)) && (Posx(ii) <= max_x)) && ((1 <= Posy(ii)) && (Posy(ii) <= max_y))
        Legalmoves(ii) = 1;                                                         %reward associated to an action
    else
        Legalmoves(ii) = nan;
    end
end
% Legalmoves
% 
% reshape(Q(currentPos(2),currentPos(1),:),[],1)
% reshape(Q(currentPos(2),currentPos(1),:),[],1).*Legalmoves'
[val,idx] = max(reshape(Q(currentPos(2),currentPos(1),:),[],1).*Legalmoves');

if rand >= epsilon
    newPos = [Posx(idx);Posy(idx)];
else
    for jj = 1:100;
        ran = randi([1 4]);
        if Legalmoves(ran) > 0
            newPos = [Posx(ran);Posy(ran)];
            break
        end
    end
end
end


