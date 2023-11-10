function [newstate] = nextstate(state,Q,epsilon,h,demand,timediscretisation,ii,exponent)

[val,action] = min(Q);             %Q(h,t,a,w)

if rand < epsilon*exp(-ii*exponent);
    action = randi(3);
end

A = 0.3;

%newh = round(state(1) + (action-(demand(state(2)))));                                   %heigh dynamics
newh = state(1) + (action-(4*demand(state(2))))/A;     %3.2                              %heigh dynamics

%actualh = newh;

% if newh < 0
%     actualh = newh;
%     newh = 0;
% else 
% if newh > h
%          newh = h;
%      end
% end


if state(2) < timediscretisation;                     %increment time
    newt = state(2) + 1;
else
    newt = 1;
end


newstate = [newh, newt, action];







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
