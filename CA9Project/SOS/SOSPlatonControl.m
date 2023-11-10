clear all

v0 = [10 10 10];
v = [12 11 8];  %initial velocities  random
u = [0 0 0];    %intial inputs

x = [0 0 0];


for step = 1:20
   
    u(1) = -x(1)+x(2);
    u(2) = (x(1)-x(2))-(x(2)-x(3));
    u(3) = x(2)-x(3);


for i = 1:3    
    dv(i) = -v(i)+v0(i)+u(i);
        x(i) = x(i) + v(i);

    v(i) = v(i) + dv(i);
end

plot(x)
end

