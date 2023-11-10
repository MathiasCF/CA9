clear all; close all; clc;
syms h

a = 5; b = 15;
B = piecewise( ...
    h<a,(h-a)^2, ...
    (a<h) & (h<b),0,...
    h>b,(h-b)^2);

figure(1)
fplot(B)
xlim([0 20]);
ylim([0 25]);
xlabel('$h(k) \hspace{0.108cm} [cm]$')
ylabel('$B\bigg(h(k)\bigg)$ [$\cdot$]')
exportgraphics(figure(1), fullfile('..\Report\figures','QuadBarrierFuncA5B15.pdf'))
%%
clear all; close all; clc;
syms h

a = 10; b = 60;
B = piecewise( ...
    h<a,(h-a)^2, ...
    (a<h) & (h<b),0,...
    h>b,(h-b)^2);

figure(2)
fplot(B)
xlim([0 70]);
ylim([0 100]);
xlabel('$h(k) \hspace{0.108cm} [cm]$')
ylabel('$B\bigg(h(k)\bigg)$ [$\cdot$]')
exportgraphics(figure(2), fullfile('..\Report\figures','QuadBarrierFuncA10B60.pdf'))

