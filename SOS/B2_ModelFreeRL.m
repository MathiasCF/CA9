clc, clear, close all

%% defines
NUMBER_OF_STATES = 6;
NUMBER_OF_ACTIONS = 2;
NUMBER_OF_ITERATIONS = 10000;

%% parameters
gamma = 0.5;
den_epsilon = 0.5*ones(NUMBER_OF_STATES, 1);
alpha = ones(NUMBER_OF_STATES, NUMBER_OF_ACTIONS);

%% initiate Q and x
Q = zeros(NUMBER_OF_STATES, NUMBER_OF_ACTIONS);
x = randi(NUMBER_OF_STATES);

%% initiate u
u = randi(NUMBER_OF_ACTIONS);

%% x_all and u_all
x_all = zeros(size(x,1),NUMBER_OF_ITERATIONS);
u_all = zeros(size(u,1),NUMBER_OF_ITERATIONS);

%% learn
for i = 1:NUMBER_OF_ITERATIONS
    %%reset once boundaries are reached
    if (x <= 1) || (x >= NUMBER_OF_STATES)
        x = randi(NUMBER_OF_STATES);
        continue
    end
    
    %% Store values
    x_all(:,i) = x;
    u_all(:,i) = u;
    
    %% get desired action from u
    if u == 1
        action = -1;
    elseif u == 2
        action = +1;
    end

    Action(:,i)=action;
    
    %% determine the next state
    x_next = x + action;
    
    %% determine the reward for the given state
    if (x_next == 1) && (x == 2)
        reward = 1;
    elseif (x_next == NUMBER_OF_STATES) && (x == (NUMBER_OF_STATES - 1))
        reward = 5;
    else
        reward = 0;
    end

    %% determine whether to exploit or explore
    if rand() > 1/den_epsilon(x_next)
        % exploit
        [~, u_next] = max(Q(x_next,:));
    else
        % explore
        u_next = randi(NUMBER_OF_ACTIONS);
    end
    
    Q(x,u) = Q(x,u)+alpha(x,u)*(reward+gamma*Q(x_next,u_next)-Q(x,u));
    %SARSA Q update in Agorith 2.7 in [BBDE]
    
    Q21(i) = Q(2,1); 
    Q22(i) = Q(2,2); 

    Q31(i) = Q(3,1); 
    

    Q32(i) = Q(3,2); 
   

    Q41(i) = Q(4,1); 
    Q41plot = Q41;
    Q41plot(Q41plot==0)=nan;

    Q42(i) = Q(4,2);
    Q42plot = Q42;
    Q42plot(Q42plot==0)=nan;

    Q51(i) = Q(5,1); 
    Q52(i) = Q(5,2);

    
    %% update exploit/explore probability
    den_epsilon(x_next) = den_epsilon(x_next) + 1;
    %% update learning rate
    alpha(x, u) = 1/(1/alpha(x, u) + 1);
    
    %% update the state
    x = x_next;
    
    %% update the action
    u = u_next;
end
% ½Q

% figure
% subplot(2,1,1)
% stairs(x_all)
% title('x')
% subplot(2,1,2)
% stairs(u_all)
% title('u')

figure()
plot(Q41plot)
hold on
plot(Q42plot)
legend('Q(4,-1)','Q(4,1)')