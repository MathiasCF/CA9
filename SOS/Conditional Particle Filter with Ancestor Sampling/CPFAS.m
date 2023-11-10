function xout = CPFAS(xc,y,q)
%This functions runs a CPF-AS given a trajectory xc(1:T) and measurements
%y(1:T) and parameter q for the system:
%x1(t+1) = 0.5*x1(t) + w(t) + 0.1*x2(t), 
% w(t)~N(0,sigw^2), x2(t)~Ber(q)
%y(t) = x(t) + v(t), v(t)~(0,sigv^2)
sigw = 0.05;
sigv = 0.1;
T = length(y);

% Number of particles:
Ns = 5;

%Number of states n:
n = 2;

%Initilize vectors:
x = zeros(Ns,n,T);
W = ones(Ns,T); %For the weights
%For t=1:
%Draw Ns-1 samples from an initial distribution:
x(1:Ns-1,1,1) = randn(Ns-1,1); %First State
x(1:Ns-1,2,1) = rand(Ns-1,1)<=q;
%Set the last sample to the conditional one:
x(Ns,:,1) = xc(:,1);
%Calculate weights for them:
W(:,1) = -0.5*(y(1)-x(:,1,1)).^2./(sigv^2); %In the log domain
Wnorm = logsumexp(W(:,1)); %normalizing them
W(:,1) = W(:,1) - Wnorm; 
csw = logcumsumexp_cols(W(:,1)); 
%To draw from them 
for t=2:T
    %Resample: Resample Ns-1 particles:
        u0 = 1/(Ns-1)*rand;
        ind = zeros(1,Ns-1);
        for i=1:(Ns-1)
            u = log(u0 + (i-1)/Ns);
            ind(i) = find(u <= csw,1);
        end
        tilx = x(ind,:,1:t-1);

    %Time Update (Predict): Propogate Ns-1 particles through the model:
        x(1:Ns-1,2,t) = rand(Ns-1,1)<=q;
        x(1:Ns-1,1,t) = 0.5*tilx(:,1,end) + sigw*randn(Ns-1,1,1) + 0.1*tilx(:,2,end);
    
        %Set the last particle to the conditional one: 
        x(Ns,:,t) = xc(:,t);
    
    %Ancestor Sampling: 
    %Compute weights:
    Wa = W(:,t-1) + logf(x(Ns,:,t),x(1:Ns-1,:,t-1),q,sigw);
    Wanorm = logsumexp(Wa);
    Wa = Wa - Wanorm;
    cswa = logcumsumexp_cols(Wa);
    %Sample an ancestor to x(Ns,t)
    inda = find(log(rand)<=cswa,1);
    
    %Set the trajectories:
    x(Ns,:,1:t-1) = x(inda,:,1:t-1);
    x(1:Ns-1,:,1:t-1) = tilx;
    
    %Measurement Update: 
    %Compute the weights: 
    W(:,t) =  -0.5*(y(t)-x(:,1,t)).^2./(sigv^2); %In the log domain
    Wnorm = logsumexp(W(:,t)); %normalizing them
    W(:,t) = W(:,t) - Wnorm; 
    csw = logcumsumexp_cols(W(:,t)); %To draw from them 
end
%output trajectory: Sample one of them:
indout = find(log(rand)<=csw,1);
xout = x(indout,:,:);

