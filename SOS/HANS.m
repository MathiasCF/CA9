clear all; close all; clc;

load('VoltageSet1')

figure()
plot(UL1)
hold on
plot(UL2)
plot(UL3)
hold off
legend('UL1','UL2','UL3')
xlim([1 length(UL1)])
ylim([220 230])
%%
MeanUL1 = mean(UL1);

VARUL1 = sqrt(var(UL1));

MeanUL2 = mean(UL2);
VARUL2 = sqrt(var(UL2));

MeanUL3 = mean(UL3);
VARUL3 = sqrt(var(UL3));

%% Low voltage question
MeanUL1*sqrt(3)

%% Discuss whether the trace shows any remarkable features that may point to needs for data preparation/cleaning.
%At 133 and 1330 it looks like voltage drops

%% Aggregate 

shift = 0; %Time offset in samples

for i = 1:2096/((60*15)/5);
    QUL1(i)=mean( UL1(shift+1+180*(i-1):shift+180*i) );
    QUL2(i)=mean( UL2(shift+1+180*(i-1):shift+180*i) );
    QUL3(i)=mean( UL3(shift+1+180*(i-1):shift+180*i) );
end

rms(QUL1)

figure()
plot(QUL1)
hold on 
plot(QUL2)
plot(QUL3)
hold off
xlim([1 length(QUL1)])

%% Is there timeshift
UL11 = UL1;
UL12 = UL2;
UL13 = UL3;

load('VoltageSet2')

figure()
plot(UL11)
hold on
plot(UL1)
plot(UL12)
plot(UL2)
plot(UL13)
plot(UL3)
hold off
% xlim([1 10])
% legend('a','b')
