function [newstate] = nextstate(state,Q,epsilon,h,demand,timediscretisation)

[val,action] = min(Q);          %Choose action based on min action-value
%Epsilon greedu policy
if rand < epsilon;
    action = randi(3);
end
flow = [6 8 10]; %Set pump flows relatve to action index
A = 0.3;
%Update water leevel in elevated water reservoir
actualh = state(1) + 0.06*(flow(action)-(demand(state(2))))/A;                                  
%Increment time
if state(2) < timediscretisation;                     %increment time
    newt = state(2) + 1;
else
    newt = 1;
end
%Update new states
newstate = [actualh, newt, action flow(action)];
end