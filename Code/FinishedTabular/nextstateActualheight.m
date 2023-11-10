function [newstate] = nextstate(state,Q,epsilon,demand,timediscretisation,actualh)

[val,action] = min(Q(state(1),state(2),:));

if rand < epsilon
    action = randi(3);
end

flow = [6 8 10];
% flow = [0.5 0.66 0.8];
A = 0.3;

actualh = actualh + (0.06*(flow(action)-(demand(state(2)))))/A;

% newh = floor((actualh-10)/2);                                   %heigh dynamics                                %heigh dynamics
% 
% if newh < 1
%     newh = 1;
% else if newh > 25
%         newh = 25;
%     end
% end

if (actualh > 15) && (actualh < 55) 
    newh = ceil(actualh-14);

elseif actualh <= 15
    newh = 1;

elseif actualh >= 55
    newh = 42;
end

% Time increase
if state(2) < timediscretisation;                     %increment time
    newt = state(2) + 1;
else
    newt = 1;
end

%Create nextstate
newstate = [newh, newt, action, actualh flow(action)];

end