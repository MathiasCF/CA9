function [newstate] = nextstate(state,Q,epsilon,h,demand,timediscretisation)
%CalculateStep Calculates the next step on the grid
%[maxstate] = size(Q,[1]);          %size of dimension 1
%%
[val,action] = max(Q(state(1),state(2),state(3),:));


if rand < epsilon
    action = randi(3);
end

newh = round(state(2) + (action-(1+2*demand(state(3)))));                                   %heigh dynamics

if newh < 1
    newh = 1;
else if newh > h
        newh = h;
    end
end


if state(3) < timediscretisation;                     %increment time
    newt = state(3) + 1;
else
    newt = 1;
end


newstate = [action, newh, newt];







end
%%
% Posiblestates = zeros(1,maxstate);
% 
% PosPos(:,1) = currentPos + [-1;0];  %left (1)
% PosPos(:,2) = currentPos + [0;-1];  %up (2)
% PosPos(:,3) = currentPos + [1;0];   %right (3)
% PosPos(:,4) = currentPos + [0;1];   %down (4)
% 
% for ii = 1:length(PosPos)
%     Posx(ii) = PosPos(1,ii); Posy(ii) = PosPos(2,ii);                                                       %create the 4 possible positions
%     if ((1 <= Posx(ii)) && (Posx(ii) <= max_x)) && ((1 <= Posy(ii)) && (Posy(ii) <= max_y))
%         Legalmoves(ii) = 1;                                                         %reward associated to an action
%     else
%         Legalmoves(ii) = nan;
%     end
% end
% % Legalmoves
% % 
% % reshape(Q(currentPos(2),currentPos(1),:),[],1)
% % reshape(Q(currentPos(2),currentPos(1),:),[],1).*Legalmoves'
% [val,idx] = max(reshape(Q(currentPos(2),currentPos(1),:),[],1).*Legalmoves');
% 
% if rand >= epsilon
%     newPos = [Posx(idx);Posy(idx)];
% else
%     for jj = 1:100;
%         ran = randi([1 4]);
%         if Legalmoves(ran) > 0
%             newPos = [Posx(ran);Posy(ran)];
%             break
%         end
%     end
% end
% end
% 
% 
