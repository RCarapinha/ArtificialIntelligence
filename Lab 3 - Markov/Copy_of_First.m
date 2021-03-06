clear all
close all
clc

%=================================
%           Loading Data
%=================================
parameters = dlmread('DATA1.TXT');
p1 = parameters(1,1);
p2 = parameters(1,2);
p3 = parameters(1,3);
non_terminal = parameters(1,4); %Points for normal moves
gamma = parameters(1,5); %Discounts

p4 = 1-p1-p2-p3;
iterations = 100;
epsilon = 0.0001;

filename = 'environment1.txt';
file_instance = fopen(filename, 'rt');
lines = fgetl(file_instance);
i = 1;
while ischar(lines)
    split_values = split(lines,',');
    %disp(split_values);
    data(i, :) = split_values;
    lines = fgetl(file_instance);
    i = i + 1;
end
data = string(data);
data(data == '.') = 0.0;
data(data == 'X') = 2.0;
data(data == 'S') = 0.0;
data = double(data);
utility_matrix = data;

%=================================
%          Beginning Iterations
%=================================
for i = 1:iterations
    dummy = zeros(size(utility_matrix, 1), size(utility_matrix, 2));
    row = size(utility_matrix,1);
    while row > 0
        for col = 1:size(utility_matrix, 2)
            
            if (utility_matrix(row, col) == 1)||(utility_matrix(row, col) == -1)||(utility_matrix(row, col) == 2)
                dummy(row, col) = utility_matrix(row, col);
                continue
            end
            
            s = utility_matrix(row, col);
            
            %=================================
            %         Can Go Up ??
            %=================================
            if (row - 1) == 0 || utility_matrix((row -1), col) == 2
                u = utility_matrix(row, col);
                %up = 1;
            elseif (row - 1) > 0
                u = utility_matrix((row -1), col);
            end
            
            %=================================
            %         Can Go Down ??
            %=================================
            if (row + 1) > size(utility_matrix,1) || utility_matrix((row + 1), col) == 2
                d = utility_matrix(row, col);
                %down = 1;
            elseif (row + 1) <= size(utility_matrix,1)
                d = utility_matrix((row + 1), col);
            end
            
            %=================================
            %         Can Go Left ??
            %=================================
            if (col - 1) == 0 || utility_matrix(row, (col - 1)) == 2
                l = utility_matrix(row, col);
                %left = 1;
            elseif (col - 1) > 0
                l = utility_matrix(row, (col - 1));
            end
            
            %=================================
            %         Can Go Right ??
            %=================================
            if (col + 1) > size(utility_matrix, 2) || utility_matrix(row, (col + 1)) == 2
                r = utility_matrix(row, col);
                %right = 1;
            elseif (col + 1) <= size(utility_matrix, 2)
                r = utility_matrix(row, (col + 1));
            end
            
            % right, left, up, down
            ut = [r, l, u, d]';
            
            %=================================
            %  Calculating Utility Sequence
            %=================================
            % right, left, up, down
            uti = zeros(4, 1);
            for x = 1:4
                uti(x, 1) = non_terminal + gamma*ut(x, 1);
            end
            
            %=================================
            %  Calculating Expected Utility
            %=================================
            % right, left, up, down
            util = zeros(4, 1);
            util(1,1) = p1*uti(1, 1) + p2*uti(3, 1) + p3*uti(4, 1) + p4*uti(2,1); %right
            util(2,1) = p1*uti(2, 1) + p2*uti(3, 1) + p3*uti(4, 1) + p4*uti(1,1); %left
            util(3,1) = p1*uti(3, 1) + p2*uti(1, 1) + p3*uti(2, 1) + p4*uti(4,1); %up
            util(4,1) = p1*uti(4, 1) + p2*uti(1, 1) + p3*uti(2, 1) + p4*uti(3,1); %down
            
            %=========================================
            %      Selecting the Best Utility
            %=========================================
            [max_value,p] = max(util);
            dummy(row, col) = max_value;
            policy(row, col) = p;
        end
        row = row - 1;
    end
    utility_matrix = dummy(:,:);
    VF(:,:,i) = utility_matrix;
    
    if(i>2)
        if abs(sum(sum(VF(:,:,i) - VF(:,:,i-1)))) < epsilon
            disp('Epsilon criteria satisfied!');
            break;
        end
    end
    
end

%=========================================
%           Displaying Results
%=========================================
result = utility_matrix(:,:);
result(result == 2) = 0;
VF(VF(:,:,:) == 2) = 0;

% for row = 1:size(result, 1)
%     for col = 1:size(result, 2)
%         if col == size(result, 2)
%             fprintf('%6.3f ', result(row, col));
%         else
%             fprintf('%6.3f, ', result(row, col));
%         end
%     end
%     fprintf('\n');
% end

F11(1:size(VF,3)) = VF(1,1,:);
F12(1:size(VF,3)) = VF(1,2,:);
F13(1:size(VF,3)) = VF(1,3,:);
F14(1:size(VF,3)) = VF(1,4,:);
 
F21(1:size(VF,3)) = VF(2,1,:);
F22(1:size(VF,3)) = VF(2,2,:);
F23(1:size(VF,3)) = VF(2,3,:);
F24(1:size(VF,3)) = VF(2,4,:);

F31(1:size(VF,3)) = VF(3,1,:);
F32(1:size(VF,3)) = VF(3,2,:);
F33(1:size(VF,3)) = VF(3,3,:);
F34(1:size(VF,3)) = VF(3,4,:);

figure
hold on
plot(F11)
plot(F12)
plot(F13)
plot(F14)

plot(F21)
plot(F22)
plot(F23)
plot(F24)

plot(F31)
plot(F32)
plot(F33)
plot(F34)

Tstr=string(policy);

for i=1:size(utility_matrix, 1)
    for j=1:size(utility_matrix, 2)
        if policy(i,j)==1       %right
            Tstr(i,j)='>';
        elseif policy(i,j)==2   %left
            Tstr(i,j)='<';
        elseif policy(i,j)==3   %up
            Tstr(i,j)='^';
        elseif policy(i,j)==4   %down
            Tstr(i,j)='v';
        else
            Tstr(i,j)=result(i,j);
        end
    end
end

Tstr(2,2) = 'Wall';

title('Convergence Plot')
xlabel('Iterations')
ylim([-1.1 1.1])