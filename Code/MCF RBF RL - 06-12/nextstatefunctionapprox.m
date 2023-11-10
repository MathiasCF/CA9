function [newstate] = nextstate(state,Q,epsilon,h,demand,timediscretisation)

[val,action] = min(Q);             %Q(h,t,a,w)

if rand < epsilon;
    action = randi(3);
end

flow = [6 8 10];
A = 0.3;
                                 %heigh dynamics
actualh = state(1) + 0.06*(flow(action)-(demand(state(2))))/A;                                   %heigh dynamics

if state(2) < timediscretisation;                     %increment time
    newt = state(2) + 1;
else
    newt = 1;
end


newstate = [actualh, newt, action flow(action)];

end