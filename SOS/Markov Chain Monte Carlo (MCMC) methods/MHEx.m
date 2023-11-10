clear all;close all; clc;
rng(10)
%Metropolis Hasting exercise (Exercise 1):
%A robot at time t=0 with position x(0)=0 is commanded with a velocity v
%over a netwrok. The command reaches the robot after d unit of times. At
%time T=1, we collect N measurements Y = [y1,...,yN] of the position
% x(T)= v*(T-d) with yi = x(T) + sig*randn.
% We want to estimate d.


%Generate Data:
%True value of the delay:
d = 0.3;
%Final time:
T = 1; 
%velocity: 
v = 1; 
%Actual final position (assuming x0 = 0): 
x = v*(T-d);

%Standard deviation of the measurement: 
sig = 0.1;

%Number of measurements
N = 400;

%Generating measurements:

Y = x+sig*randn(1,N); 


%Define the parameters of the prior prior: 
%The prior on d is an exponential distribution with mean lam 
lam = 1/0.3; 


%Proposal density: Gaussain (random walk)
%theta' = ProbQ(theta*). Define as a function below in the script.

%Target distribution: Posterior \propto Likelihood x prior
%Define below in the script
%% Metropolis algorithm
%Number of samples: 
M = 100000; 
%theta = [alpha beta]
theta = zeros(M,1);

%initial sample: 
theta0 = 0.5; %Choose arbitrary  
theta(1,:) = theta0; 

%The algorithm
for i=1:M-1
    thetah = ProbQ(theta(i,:));
    u = rand;

    if log(u) <=  ftarget(thetah,Y,lam,sig,T)  -  ftarget(theta(i,:),Y,lam,sig,T)
        theta(i+1,:)=thetah;
    else 
        theta(i+1,:) = theta(i,:);
    end    
end

burnin = round(M/3);

f = figure;
histogram(theta(burnin:M,1))
hold on
xline(d,'linewidth',3)
xlabel('$d$','Interpreter','latex','FontSize',12)
legend('MH samples','True value')


function y = ProbQ(x)
%Sample from the proposal here (Random Walk for example)
%Try symmetric first :) 
%THIS IS RANDOM WALK implementation
y = x+0.1*randn();
end

%Some target function
function y = ftarget(theta,Y,lam,sig,tf)
        if (theta<tf)
%             y = -lam*theta - sum((Y+theta-1).^2/(2*sig^2));
           y = -lam*theta - sum(((Y+theta-1)/(2*sig)).^2);
        else 
            y = -inf;
        end 
end