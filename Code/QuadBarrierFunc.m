function [Bcost] = QuadBarrierFunc(h)

lb = 5; ub = 15;

Bcost = 0;

if h < lb
    Bcost = (h-lb)^2;
end

if h > ub
    Bcost = (h-ub)^2;
end
end


