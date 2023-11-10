%Sim simulates the system with state equation
% x(i)= a*x(i-1)+b*u(i-1)+w(i-1);
% and three different measurements eqn
% y(i)= c*x(i)+v(i);
% y(i)= c*abs(x(i))+v(i);
% y(i)= sign(x(i) with probability ProbSign;
% 
% External input: None

% Time-stamp: <2018-11-06 14:04:51 tk>
% Version 1: 2018-11-06 11:20:36 tk Based on LSim.m
% Torben Knudsen
% Aalborg University, Dept. of Electronic Systems, Section of Automation
% and Control
% E-mail: tk@es.aau.dk

%% Parameters

n= 200; 
a= 0.95; k= 1; c= 1; fu= 0.02; x0= 0;
sigmax= 0.5; sigmav= 0.1;
uAmp= 1; ProbSign= 0.75; 
NormalP= 1; NormalM= 1;                 % Distribution of process and
                                        % measurement noise
Output= 1;                              % Measurement equation;

%% Definitions

b= k*(1-a); sigmaw= sigmax*sqrt(1-a^2); sigmax0= sigmaw; 

%% Algorithm

if NormalP;                             % Using normal (0,1) distribution
  w= sigmaw*randn(n,1);
else;                               % Using uniform mu= 0 Var=1 distribution
  w= sigmaw*(rand(n,1)-1/2)/sqrt(1/12);
end;
if NormalM;                             % Using normal (0,1) distribution
  v= sigmav*randn(n,1);
else;                               % Using uniform mu= 0 Var=1 distribution
  v= sigmav*(rand(n,1)-1/2)/sqrt(1/12);
end;
u= uAmp*square((1:n)*fu*2*pi);
x= zeros(n,1);
mux= zeros(n,1);                        % Mean of x i.e. simulated from u
y= zeros(n,1);
x(1)= sigmax0*randn+x0;
mux(1)= x0;                             % Mean of x i.e. simulated from u
switch Output
  case 1                                % Linear plus noise
    y(1)= c*x(1)+v(1);
  case 2                                % Absolute value plus noice
    y(1)= c*abs(x(1))+v(1);             
  case 3                                % Sign with probability ProbSign
    if (rand <= ProbSign)
      y(1)= sign(x(1));
    else
      y(1)= -sign(x(1));
    end;
end
for i= 2:n;
  x(i)= a*x(i-1)+b*u(i-1)+w(i-1);
  mux(i)= a*mux(i-1)+b*u(i-1);          % Mean of x i.e. simulated from u
  switch Output
    case 1                              % Linear plus noise
      y(i)= c*x(i)+v(i);
    case 2                              % Absolute value plus noice
      y(i)= c*abs(x(i))+v(i);
  case 3                                % Sign with probability ProbSign
    if (rand <= ProbSign)
      y(i)= sign(x(i));
    else
      y(i)= -sign(x(i));
    end;
  end
end;
figure(1)
subplot(311)
plot(u); 
ylim([min(u)-0.1 max(u)+0.1])
title('u')
subplot(312)
plot([x mux])
title('x and E(x)')
legend({'x' 'E(x)'})
subplot(313)
plot(y)
title('y');
ylim([min(y)-0.1 max(y)+0.1]);
