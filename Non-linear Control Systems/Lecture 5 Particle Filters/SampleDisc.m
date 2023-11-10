function s= SampleDisc(pdf,ns,EqualSpace)
%SampleDisc draws ns new integer numbers according to the probability
% density function specified by the values 1:length(pdf) and pdf.
%
% s= Sample(pdf,ns,EqualSpace)
%
% pdf : pdf to draw from (default 1/2, 1/2)
% ns : Number of samples (default length(pdf))
% EqualSpace : If 1 use equal spacing and deterministic drawing other
%              wise use random sampling (default 0)
% 
% External input: None

% Time-stamp: <2018-11-05 11:56:25 tk>
% Version 1: 
% Torben Knudsen
% Aalborg University, Dept. of Electronic Systems, Section of Automation
% and Control
% E-mail: tk@es.aau.dk

%% setting up inputs
pdfDef= 0.5*ones(2,1);
EqualSpaceDef= 0;
if nargin < 3; EqualSpace= []; end;
if nargin < 2; ns= []; end;
if nargin < 1; pdf= []; end;
if isempty(EqualSpace); EqualSpace= EqualSpaceDef; end;
if isempty(pdf); pdf= pdfDef; end;
if isempty(ns); ns= length(pdf); end;

%% Parameters

%% Definitions etc.

%% Algorithm

pdf= pdf(:);
n= size(pdf,1);
cdf= cumsum(pdf);
if EqualSpace;
  u= (1:ns)'/(ns+1);
else;
  u= rand(ns,1);
end;
s = interp1(cdf,(1:n)',u,'next','extrap');

% The below gives the same as s = interp1(cdf,(1:n)',u,'next');
% $$$ saux= zeros(ns,1);
% $$$ for i= 1:ns;
% $$$   saux(i)= min(find(u(i)<=cdf));
% $$$ end;
% $$$ maxdiff(s-saux)
