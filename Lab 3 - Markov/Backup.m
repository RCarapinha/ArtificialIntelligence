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

n = 4; %Size of maze

% Display maze in matrix
disp(maze)
Goal = 16;
S = 13;

% Possible actions are:
%
% * Up    :  (i-n)
% * Down  :  (i+n)
% * Left  :  (i-1)
% * Right :  (i+1)
%
% Reward  is -inf (No reward) for any other actions.
% Any other action other then above action will not occur.

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
maxItr = 50;

% cs -> current state
% ns -> next state
% Repeat until Convergence OR Maximum Iterations

for i=1:maxItr
    cs=S;                                                 % Start Position
    while(1)                                              % Repeat until Goal state is reached
        n_actions = find(reward(cs,:)>0);                 % possible actions for the chosen state (Find where I can go)
        ns = n_actions(randi([1 length(n_actions)],1,1)); % choose an action at random and set it as the next state (Choose one of them)
        n_actions = find(reward(ns,:)>=0);                % find all the possible actions for the selected state (Find where I can from the selected state)
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

% * Starting from the first postion
start = S;
move = 0;
path = start;

% * Iterating until Goal-State is reached
while(move~=Goal)
    [~,move]=max(q(start,:));
    
    %     % Deleting chances of getting stuck in small loops  (upto order of 4)
    %     if ismember(move,path)
    %         [~,x]=sort(q(start,:),'descend');
    %         move=x(2);
    %         if ismember(move,path)
    %             [~,x]=sort(q(start,:),'descend');
    %             move=x(3);
    %             if ismember(move,path)
    %                 [~,x]=sort(q(start,:),'descend');
    %                 move=x(4);
    %                 if ismember(move,path)
    %                     [~,x]=sort(q(start,:),'descend');
    %                     move=x(5);
    %                 end
    %             end
    %         end
    %     end
    
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
q=double(q);alpha=double(alpha);
q(alpha~=0)=q(alpha~=0)+1;
alpha(alpha==0)=n;
for i=1:length(q)
    pmat(q(i),alpha(i))=50;
end

Tstr=string(pmat);
Tstr(Goal) = 'Goal';
Tstr(4,1) = 'Start';
i = size(Tstr,1);
while i > 1
    for j=2:size(Tstr,2)-1
        if j~=4
            if double(Tstr(i,j+1)) == 50
                Tstr(i,j+1) = 'v';
            end
        end
        
        if j ~= 1
            if double(Tstr(i,j-1)) == 50
                Tstr(i,j-1) = '^';
            end
        end
        
        if i ~= 4
            if double(Tstr(i+1,j)) == 50
                Tstr(i+1,j) = '^';
            end
        end
            
        if i ~= 1
            if double(Tstr(i-1,j)) == 50
                Tstr(i-1,j) = '>';
            end
        end
    end
    i = i-1;
end

% %Final Plot
% figure
% imagesc(pmat)
% colormap(white)
% for i=1:n
%     for j=1:n
%         if maze(i,j)==min(maze)
%             text(j,i,'X','HorizontalAlignment','center')
%         end
%         if pmat(i,j)==50
%             text(j,i,'\bullet','Color','red','FontSize',28)
%         end
%     end
% end
% text(1,4,'START','HorizontalAlignment','right')
% text(4,4,'GOAL','HorizontalAlignment','right')
% hold on
% imagesc(maze,'AlphaData',0.2)
% colormap(winter)
% hold off
% axis off