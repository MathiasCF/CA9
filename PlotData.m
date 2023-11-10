clc; clear all; close all;
cd 'C:\Users\Mathias\OneDrive - Aalborg Universitet\CA9\CA9Project'
load('Run1.16.12.mat')
%% Height Plot
h = data{2}.Values.Data;
h(1)=h(2);

figure(1)
plot(h)
xlim([0 6*60*24])
xticks(0:length(h)/6:length(h))
xticklabels({'0','24','48','72','96','120','144'})
xlabel('Time [min]')

ylim([20 40])
ylabel('Height [cm]')

title('Water Level in Elevated Water Reservoir')

% exportgraphics(figure(1), fullfile('Report\figures','ResultHeight.pdf'))

mean(h(1*60*24:6*60*24))
%% Pump plot
p = data{4}.Values.Data(1:6*24);
p(1)=p(2);

figure(2)
plot(p)

xlim([0 6*24])
xticks(0:length(p)/6:length(p))
xticklabels({'0','24','48','72','96','120','144'})
xlabel('Time [min]')

ylim([40 110])
ylabel('Rotational Speed [\%]')

title('Pumping Station Action')

% exportgraphics(figure(2), fullfile('Report\figures','ResultPumpSpeed.pdf'))

%%

