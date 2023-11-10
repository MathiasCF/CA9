clear all; close all;

A = [0 -1;1 1]
B = [0;1]

Q = diag([1 1])
R = 0.001;

k = lqr(A,B,Q,R)
%%

dt = 10e-3;
    
x1(1) = 50;
x2 (1) = -50;

for i = 1:500
    u(i) = -k*[x1(i);x2(i)];
    x1(i+1) = x1(i) - x2(i)*dt;
    x2(i+1) = x2(i)+(x1(i)+x2(i)+x1(i)^3+u(i))*dt;
end

figure()
plot(x1)
hold on
plot(x2)
hold off
