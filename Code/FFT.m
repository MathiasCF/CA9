clear; close all; clc;

load('resampdataset.mat')

y11 = fft(q_u2);
P22 = abs(y11/length(q_u2));
P11 = P22(1:length(q_u2)/2+1);
P11(2:end-1) = 2*P11(2:end-1);

P22a = angle(y11/length(q_u2));
P11a = P22a(1:length(q_u2)/2+1);
P11a(2:end-1) = 2*P11a(2:end-1);

%Time-axis
f = 1/(15*60)*(0:(length(q_u1)/2))/length(q_u1);

figure(1)

plot(f,P11,'LineWidth',1.5)
title('FFT of Consumption Pattern')
xlabel('Frequency [Hz]')
ylabel('Amplitude')
xlim([0 max(f)])


exportgraphics(figure(1), fullfile('..\Report\figures','FFT.pdf'))

% 
% 1/(1.15495*10^-5)/(60*60*24);
% 1/(2.30989*10^-5)/(60*60*24);
% 1/(3.46484*10^-5)/(60*60*24);
% 1/(4.63291*10^-5)/(60*60*24);
% 1/(6.9428*10^-5)/(60*60*24);
% 
% f1 = (1.15495*10^-5);
% f2 = (2.30989*10^-5);
% f3 = (3.46484*10^-5);
% f4 = (4.63291*10^-5);
% f5 = (6.9428*10^-5);
% 
% a0 = 5.42744 ; 
% a1 = 2.84716;
% a2 = 1.2767;
% a3 = 0.411351;
% a4 = 0.428664;
% a5 = 0.381533;
% 
% 
% ph1 = P11a(89)
% ph2 = P11a(177)
% ph3 = P11a(265)
% ph4 = P11a(354)
% 
% b1 = 0;
% 
% syms k
% 
% f = @(k) a0 +...
%     a1*cos(2*pi*f1*k+ph1) + b1*sin(2*pi*f1*k) +...
%     a2*cos(2*pi*f2*k+ph2) + b1*sin(2*pi*f2*k)+...
%     a3*cos(2*pi*f3*k+ph3) + b1*sin(2*pi*f3*k)+...
%     a4*cos(2*pi*f4*k+ph4) + b1*sin(2*pi*f4*k)%+...
%    % a5*cos(2*pi*f5*k+p5) + b1*sin(2*pi*f5*k);
% 
% figure()
% fplot(f)
% xlim([0 60*60*24])
% 
% figure()
% plot(q_u2(1:4*24))
% 
% 
% 
% 
% 
