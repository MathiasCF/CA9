clear all; close all; clc
rng(10)

%Gibbs sampling exercise (exercise 2):
%x(i)~Ber(qf), for 1<=i<=n
%x(i)~Ber(qs), for n+1<=i<=N
%Given X=[x1,...,xN], estimate qf,qs, and n.
%N: 
N = 500;

%Generate data:
qft = 0.5;
qst = 0.2;
nt = ceil(2*N/3);

for i=1:N
    if(i<=nt)
        X(i) = rand<=qft;
    else
        X(i) = rand<=qst;
    end
end

%Defining the priors:
%q1: Beta distribution with alphaf and betaf:
alphaf = 2; betaf = 2; 
%q2: Beta distribution with alphas and betas: 
alphas = 2; betas = 5;
%n: discrete uniform on {1,...,N} with probability pn:
pn = 1/N*ones(1,N);

%Conditional distributions:

%p(qf|X,qs,n) is an beta distribution with alphafc betafc:
%alphafc = alphaf + sum(X(1:n));
%betafc = betaf + n - sum(X(1:n));
%To draw a sample qf: 
%qf = betarnd(alphafc,betafc)

%p(qs|X,qf,n) is an beta distribution with alphasc betasc:
%alphasc = alphas + sum(X(n+1:N));
%betasc = betas + N-n - sum(X(n+1:N));
%To draw a sample qf: 
%qs = betarnd(alphasc,betasc)

%p(n|X,qf,qs) is a discrete distribution (Catogorical) on {1,...,N} with
%for i=1:N
% pn(i) =
% (qf^(sum(X(1:i))+alphaf-1))*((1-qf)^(betaf+i-sum(X(1:i))-1))*(qs^(sum(X(i+1:N))+alphas-1))*((1-qs)^(betas+N-i-sum(X(i+1:N))-1));
%end
%pn = pn./sum(pn);
%To draw a sample n: 
%n = find(rand=<cumsum(pn),1);


%% Gibbs sampling:
%theta = [qf,qs,n]
%Number of samples:
M = 2; %Choose your samples

theta = zeros(M,3);

%Start with an inital sample:
theta(1,:) = [0.1,0.1,round(N/3)]; %n should be less than N!

%Sample theta(m+1:m)
for m=1:M
%Fill the code for gibbs sampling 
end

%Plotting
burnin = ceil(M/3);
f = figure;
subplot(3,1,1)
histogram(theta(burnin:M,1),'Normalization','pdf')
hold on
xline(qft,'linewidth',3)
xlabel('$q_{f}$','Interpreter','latex','FontSize',12)
legend('Gibbs samples','True value')
subplot(3,1,2)
histogram(theta(burnin:M,2),'Normalization','pdf')
hold on
xline(qst,'linewidth',3)
xlabel('$q_{s}$','Interpreter','latex','FontSize',12)
legend('Gibbs samples','True value')

subplot(3,1,3)
histogram(theta(burnin:M,3),'Normalization','probability')
hold on
xline(nt,'linewidth',3)
xlabel('$n$','Interpreter','latex','FontSize',12)
legend('Gibbs samples','True value')