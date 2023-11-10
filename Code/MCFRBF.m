clear all; close all; clc; warning off;
ColorSet = varycolor(11);

syms x

h = 70;
weights = 10;
for c = 1:weights
    centers(c) = (c-1)*(h)/(weights-1);
    %centers(c) = centers(c) - 10;
end


centers(4) = 200;
%centers =  [0    10    20    30    40    50    60    70]
sigma = 3.12;
%sigma = 4;
ysum = {};

for i = 1:length(centers)
    y{i}= @(x) exp (-abs(x-centers(i))^2 / (2*sigma^2) );
end

ysum = @(x) y{1}(x)+y{2}(x)+y{3}(x)+y{4}(x)+y{5}(x)    +    y{6}(x)+y{7}(x)+y{8}(x)+y{9}(x)+y{10}(x);

% 
figure()
for j = 1:weights
fplot(y{j})
hold on
end

% fplot(y{2})
% fplot(y{3})
% fplot(y{4})
% fplot(y{5})
fplot(ysum, 'Color', ColorSet(11,:))
hold off
xlim([-10 80])
xlabel('Height [cm]')
ylabel('$$\textbf{x}(h)$$')
legend('','','','','','','','','','','Basis sum')
% xlim([-7 27])
% 
% ylim([0 1.2])
% xline(0)
% xline(20)

%exportgraphics(figure(3), fullfile('\..\Report\figures','RadialSum.pdf'))
