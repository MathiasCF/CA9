clear all; close all; clc
rng(10)
%Exercise: 
%This exercise uses CPF-AS to estimate a state trajectory and a parameters
%of a dynamical system.

%The system is: 
%x1(t+1) = 0.5*x1(t) + w(t) + 0.1*x2(t)
% w(t)~N(0,sigw^2), x2(t)~Ber(q)
%y(t) = x1(t) + v(t), v(t)~(0,sigv^2)

sigw = 0.05;
sigv = 0.1;

%True value of q:
q = 0.8;

%Generate data: 
%T
T = 100;
x = zeros(2,T); 
x(2,1:end) = rand(1,T)<=q; 
x(1,1) = 0.3; 

for t=2:T
    x(1,t) = 0.5*x(1,t-1) + sigw*randn + 0.1*x(2,t-1);
end
y = x(1,1:end) + sigv*randn(1,T);



%Prior for q: beta prior:
alpha = 1;
beta = 1; 
%Note that the postrior for q can be found in closed form. It is also a
%beta distribution, with parameters:
%alphapost = alpha + sum(x(2,1:end));
%betapost = beta + length(x(2,1:end)) - sum(x(2,1:end));
%Note that to sample from a beta distribution in matlab:
%use betarnd(alpha,beta)

%Gibbs Sampling: 
%Number of samples: 
M = 10000;
%Vectors for the samples to save them:
qs = zeros(1,M);
xs = zeros(2,T,M); 

%Arbitrary initial point: 
xs(2,:,1) = rand(1,T,1)<=0.5;
xs(1,:,1) = randn(1,T,1);
qs(1) = 0.2;

for m=2:M
%Write you gibbs sampling algorithm here
%Note that: the function CPFAS implements a CPF-AS filter for the model.
%x = CPFAS(xc,y,q) where xc is the condtional trajctory. 
%So you do not need to implement the CPF-AS :). Only the gibbs sampling
%strategy.

    xs(:,:,m) = CPFAS(xs(2,:,m-1),y,qs(m-1));

    alphapost = alpha + sum(xs(2,1:end,m));
    betapost = beta + length(xs(2,1:end,m)) - sum(xs(2,1:end,m));

    qs(m) = betarnd(alphapost,betapost);
    %q = betarnd(alpha,beta)

end
brunin = round(M/3);

histogram(qs(brunin:M),'Normalization','probability')
hold on 
xline(q,'linewidth',3)
legend('Posterior','True value')
xlabel('$q$','Interpreter','latex','FontSize',12)
