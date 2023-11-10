function [Bcost] = QuadBarrierFuncActualHeight(h)

lb = 20; ub = 40;

Bcost = 0;

if h < lb
    Bcost = (h-lb)^2;
end

if h > ub
    Bcost = (h-ub)^2;
end
end


