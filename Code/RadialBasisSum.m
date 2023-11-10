clear all
close all

weights = 10;
h = 70;
sigma = 3.12;              %5 weights
%sigma = 0.844;    %20 weights
%sigma=2.5;%1.79;   %10 weights
for c = 1:weights
    centers(c) = (c-1)*(h)/(weights-1);
    %centers(c) = centers(c) - 10;
end

% for c = 1:weights
%     centers(c) = (c-1)*(h)/(weights-1);
%     %centers(c) = centers(c) - 10;
% end

centers



%exp((-(abs(x-centers(f)))^2)/(2*sigma^2))

for j = 1:weights
    for x = 1:1500
        y(j,x) = exp((-(abs((x/8-20)-centers(j)))^2)/(2*sigma^2));
    end
end
    
%     
%     y2(x) = exp((-(abs((x/2-20)-centers(2)))^2)/(2*sigma^2));
%     y3(x) = exp((-(abs((x/2-20)-centers(3)))^2)/(2*sigma^2));
%     y4(x) = exp((-(abs((x/2-20)-centers(4)))^2)/(2*sigma^2));
%     y5(x) = exp((-(abs((x/2-20)-centers(5)))^2)/(2*sigma^2));
%     
%     y6(x) = exp((-(abs((x/2-20)-centers(6)))^2)/(2*sigma^2));
%     y7(x) = exp((-(abs((x/2-20)-centers(7)))^2)/(2*sigma^2));
%     y8(x) = exp((-(abs((x/2-20)-centers(8)))^2)/(2*sigma^2));
%     y9(x) = exp((-(abs((x/2-20)-centers(9)))^2)/(2*sigma^2));
%     y10(x) = exp((-(abs((x/2-20)-centers(10)))^2)/(2*sigma^2));
    %totalsum(x) = y(x) + y2(x) + y3(x) + y4(x) + y5(x) + y6(x) + y7(x) + y8(x) + y9(x) + y10(x);
%     
       % totalsum(x) = y(x) + y2(x) + y3(x) + y4(x) + y5(x);% + y6(x) + y7(x) + y8(x) + y9(x) + y10(x);

for x = 1:1500
    totalsum(x) = sum(y(:,x));
end


% figure()
for j = 1:weights
plot(y(j,:))
hold on
end

plot(totalsum)
xticklabels({'-20', '10','20','30','700','900'})

% 
% figure(1)
% plot(y)
% hold on
% plot(y2)
% plot(y3)
% plot(y4)
% plot(y5)
% % plot(y6)
% % plot(y7)
% % plot(y8)
% % plot(y9)
% % plot(y10)
% plot(totalsum)
% legend()
% xlim([0 120])


mean(totalsum(160:80*2*2))