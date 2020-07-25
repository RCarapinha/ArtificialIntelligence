clear all
close all
clc

%Import MAZE
filename = 'MAZE.txt';
file_instance = fopen(filename, 'rt');
lines = fgetl(file_instance);
i = 1;
while ischar(lines)
    split_values = split(lines,',');
    data(i, :) = split_values;
    lines = fgetl(file_instance);
    i = i + 1;
end
maze = double(string(data));
%-----------

%Import Parameters
parameters = dlmread('DATA.TXT');
alpha = parameters(1,4);            %Learning Rate
gamma = parameters(1,5);            %Discount Factor
%-----------

n = 5; %Size of maze

% Display maze in matrix
disp(maze)
Goal = 25;
S = 13;

% Possible actions are:
% * Up    :  (i-n)
% * Down  :  (i+n)
% * Left  :  (i-1)
% * Right :  (i+1)

reward=zeros(n*n);
for i=1:Goal
    reward(i,:)=reshape(maze',1,Goal);
end

for i=1:Goal
    for j=1:Goal
        if j~=i-n  && j~=i+n  && j~=i-1 && j~=i+1
            reward(i,j)=-Inf;
        end
    end
end

for i=1:n:Goal
    for j=1:i+n
        if j==i+n-1 || j==i-1 || j==i-n-1
            reward(i,j)=-Inf;
            reward(j,i)=-Inf;
        end
    end
end

% Initialize the Q-matrix.
% Set the goal state to be 'n*n'.
% Set Discount factor gamma, learning rate, alpha and nr of iterations

q = randn(size(reward));
maxItr = 100;

% cs -> current state
% ns -> next state
% Repeat until Convergence OR Maximum Iterations

for k=1:maxItr
    cs=S;                                                 % Start Position
    while(1)                                              % Repeat until Goal state is reached
        n_actions = find(reward(cs,:)>-11);                 % possible actions for the chosen state (Find where I can go)
        ns = n_actions(randi([1 length(n_actions)],1,1)); % choose an action at random and set it as the next state (Choose one of them)
        n_actions = find(reward(ns,:)>=-11);                % find all the possible actions for the selected state (Find where I can from the selected state)
        max_q = 0;                                        % find the maximum q-value i.e, next state with best action
        
        for j=1:length(n_actions)
            max_q = max(max_q,q(ns,n_actions(j)));
        end
        
        q(cs,ns)=reward(cs,ns)+gamma*max_q;               % Update q-values as per Bellman's equation
        
        % Check if the Goal has been reached
        if(cs == Goal)
            break;
        end
        
        % Set current state as next state
        cs=ns;
    end
end
Matr = q;

% * Starting from the first postion
start = S;
move = 0;
path = start;

% * Iterating until Goal-State is reached
while(move~=Goal)
    [~,move]=max(q(start,:));
    
    % Appending next action/move to the path
    path=[path,move];
    start=move;
end

% Solution of maze
fprintf('Final path: %s',num2str(path))
fprintf('Total steps: %d',length(path))

% reproducing path to matrix path
pmat=zeros(n,n);
[q, alpha]=quorem(sym(path),sym(n));
q=double(q);
alpha=double(alpha);
q(alpha~=0)=q(alpha~=0)+1;
alpha(alpha==0)=n;
for i=1:length(q)
    pmat(q(i),alpha(i))=1;
end

Tstr=string(pmat);
Tstr(Goal) = 'Goal';
i = size(pmat,1);