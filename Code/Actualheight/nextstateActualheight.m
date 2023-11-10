function [newstate] = nextstate(state,Q,epsilon,h,demand,timediscretisation,ii,exponent,actualh)

[val,action] = min(Q(state(1),state(2),:));

if rand < epsilon*exp(-ii*exponent)
    action = randi(3);
end

flow = [0.36 0.48 0.6];
A = 0.3;

actualh = actualh + (flow(action)-(demand(state(2))))/A;

%newh = round(actualh-10);
newh = floor((actualh-10)/2);                                   %heigh dynamics                                %heigh dynamics

if newh < 1
    newh = 1;
else if newh > 25
        newh = 25;
    end
end

% Time increase
if state(2) < timediscretisation;                     %increment time
    newt = state(2) + 1;
else
    newt = 1;
end

%Create nextstate
newstate = [newh, newt, action, actualh];

end