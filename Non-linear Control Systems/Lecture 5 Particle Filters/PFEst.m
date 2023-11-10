%PFEst estimates the state simulated by Sim.m
% 
% External input: Parameters and simulated data from Sim.m

% Time-stamp: <2018-11-06 14:04:09 tk>
% Version 1: 2018-11-06 11:24:57 tk Initial version
% Torben Knudsen
% Aalborg University, Dept. of Electronic Systems, Section of Automation
% and Control
% E-mail: tk@es.aau.dk

%% Parameters

Ns= 100; Resample= 2; EqualSpace= 0; NsEffFracLim= 0.25; sigmax0= 1; 
wMin= eps;
Animate= 0;

% Definitions

Skip= floor(min(n/2,2/(1-a)));           % Transient part to be skipped
                                        % from statistics

%% Algorithm

% Initial particles
if EqualSpace==1;
  xp= ((1:Ns)/(Ns+1)-1/2)*2*sigmax0;    % Equal spaced
else;
  xp= randn(1,Ns)*sigmax0;               % N(0,sigmax0^2) distributed;
end;
w= ones(1,Ns)/Ns;                       % Weights
XP= zeros(n,Ns);
W= zeros(n,Ns);
NsEffFrac= zeros(n,1);
for i= 1:n;
  % Measurement update
  % New weight based on measurement i 
  switch Output
    case 1                              % Linear plus noise
      % y(i)= c*x(i)+v(i);                
      w= w.*normpdf((y(i)-c*xp)/sigmav);
    case 2                              % Absolute value plus noice
      % y(i)= c*abs(x(i))+v(i);
      w= w.*normpdf((y(i)-c*abs(xp))/sigmav);
    case 3                              % Sign with probability ProbSign
      for j= 1:Ns
        if sign(xp(j))==y(i)
          w(j)= w(j)*ProbSign;
        else
          w(j)= w(j)*(1-ProbSign);
        end;
      end;
  end
  % Small hack to make SampleDisc and SampleCont work
  w= max(w,wMin); 
  w= w/sum(w);
  nsefffrac= 1./sum(w.^2)/Ns;
  % Resample
  switch Resample
    case 1;
      xpRSIndex= SampleDisc(w,[],EqualSpace);
      xp= xp(xpRSIndex);
      w= ones(1,Ns)/Ns;
      nsefffrac= 1./sum(w.^2)/Ns;
    case 2
      xp= SampleCont(xp,w,[],EqualSpace)';
      w= ones(1,Ns)/Ns;
      nsefffrac= 1./sum(w.^2)/Ns;
    case 3
      if nsefffrac < NsEffFracLim;
        xp= SampleCont(xp,w,[],EqualSpace)';
        w= ones(1,Ns)/Ns;
        nsefffrac= 1./sum(w.^2)/Ns;
      end;
    otherwise;
  end;
  % Output results
  XP(i,:)= xp;
  W(i,:)= w;
  NsEffFrac(i)= nsefffrac;
  % Time update
  % Drawn new states
  xp= a*xp+b*u(i)+sigmaw*randn(1,Ns);
end;

% Calculate x^(k|k) and P(k|k)
XHPF= XP.*W;
XHPF= sum(XHPF')';
XHPFT= XP-XHPF*ones(1,Ns);
XHPFVar= XHPFT.^2.*W;
XHPFVar= sum(XHPFVar')';
NsEffFrac= 1./sum((W.^2)')/Ns;          % NsEff/Ns
figure(2);
subplot(211)
lh= plot(1:n,XP,'b',1:n,XHPF,'r',1:n,sqrt(XHPFVar),'y',1:n,x,'g');
grid('on')
legend([lh(1); lh(Ns+1:end)],{'XP' 'XHPF' 'XHPFStd' 'x'});
title('Samples/particles, xhat, std-xhat and x')
subplot(212)
lh= plot(1:n,W,'b',1:n,NsEffFrac,'r');
grid('on')
legend([lh(1); lh(Ns+1:end)],{'W' 'NsEffFrac'});
title('Weights and Effective samples');

% Calculated simulated x which is the same as mean x maybe except from
% initial condition
% Start with a random number similar to the PF method
xsim0= mean(XP(1,:));                      % Average of first particles
xsim= filter([0 b],[1 -a],u,xsim0)';
x= x(:);
% Statistics for the simulated values including all samples and skipping
% transient
xt= x-xsim;
xts= xt(Skip+1:end);
Res= [mean(xt) sqrt(xt'*xt/n) mean(xts) sqrt(xts'*xts/length(xts))];
% Statistics for the PF method including all samples and skipping
% transient
xt= x-XHPF;
xts= xt(Skip+1:end);
res= [mean(xt) sqrt(xt'*xt/n) mean(xts) sqrt(xts'*xts/length(xts))];
Res= [Res; res];
% Present results
ColLab= {'Mean' 'Rms' 'MeanSkip' 'RmsSkip'};
RowLab= {'Sim' 'PF'};
Lab= {['Comparing simulated and PF estimates (skip= ' int2str(Skip) ')']};
disp(Lab);
disp(array2table(Res,'RowNames',RowLab,'VariableNames',ColLab));
% Plot estimates
figure(3);
plot(1:n,[x xsim XHPF])
legend({'x' 'xsim' 'XHPF'})

if Animate && Resample~=1;
  figure(4);
  clf
  NBarMax= n;
  i= 1;
  fh= bar(XP(i,:),W(i,:));
  xlim([1.1*min(min(XP(1:NBarMax,:))) 1.1*max(max(XP(1:NBarMax,:)))]);
  ylim([0 1.1*max(max(W(1:NBarMax,:)))]);
  hold('on');
  for i= 1:NBarMax;
    fh.XData= XP(i,:);
    fh.YData= W(i,:);
    drawnow;
    pause(0.1);
  end;
  hold('off');
  title('Samples/particles and weights')
end;
