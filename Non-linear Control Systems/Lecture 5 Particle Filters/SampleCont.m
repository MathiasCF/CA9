function s= SampleCont(x,pdf,ns,EqualSpace)
%SampleCont draws ns new real numbers according to the probability
% density function specified by the values x and pdf.
%
% s= SampleCont(x,pdf,ns,EqualSpace)
%
% x : values corresponding to pdf
% pdf : pdf to draw from (default 1/2, 1/2)
% ns : Number of samples (default length(pdf))
% EqualSpace : If 1 use equal spacing and deterministic drawing other
%              wise use random sampling (default 0)
% 
% External input: None

% Time-stamp: <2018-11-05 11:54:51 tk>
% Version 1: 
% Torben Knudsen
% Aalborg University, Dept. of Electronic Systems, Section of Automation
% and Control
% E-mail: tk@es.aau.dk

%% setting up inputs
EqualSpaceDef= 0;
if nargin < 4; EqualSpace= []; end;
if nargin < 3; ns= []; end;
if nargin < 2; pdf= []; end;
if nargin < 1; error('Error TK: To few input arguments'); end;
if isempty(EqualSpace); EqualSpace= EqualSpaceDef; end;
if isempty(pdf); pdf= ones(length(x))/length(x); end;
if isempty(ns); ns= length(pdf); end;

%% Parameters

%% Definitions etc.

%% Algorithm

pdf= pdf(:);
x= x(:);
[x,i]= sort(x);                         % sort x for interpolation
pdf= pdf(i);                            % pdf must correspond to x
n= size(pdf,1);
cdf= cumsum(pdf);
if EqualSpace;
  u= (1:ns)'/(ns+1);
else;
  u= rand(ns,1);
end;
x= [x(1)-(x(2)-x(1))/2; (x(1:n-1)+x(2:n))/2; x(n)+(x(n)-x(n-1))/2];
cdf= [0; cumsum(pdf)];
s = interp1(cdf,x,u,'linear','extrap');
