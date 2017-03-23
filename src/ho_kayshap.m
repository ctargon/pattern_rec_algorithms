%
%  Program: ho-kayshap.m
%  Author:  Colin Targonski
%  Course:  ECE 8560 Pattern Recognition
%  Date:    3/14/2017
%
%  Details: This program was created in an effort to implement the 
%  ho-kayshap method on a c=3 d=4 dataset.
%

[training_set, test_set] = read_data('../data/train_sp2017_v19','../data/test_sp2017_v19');

train_1_2 = [ones(10000,1) training_set(1:10000,:)];
train_1_2(5001:10000,:) = -1 .* train_1_2(5001:10000,:);

train_1_3 = [ones(10000,1) vertcat(training_set(1:5000,:),training_set(10001:15000,:))];
train_1_3(5001:10000,:) = -1 .* train_1_3(5001:10000,:);

train_2_3 = [ones(10000,1) training_set(5001:15000,:)];
train_2_3(5001:10000,:) = -1 .* train_2_3(5001:10000,:);

%test_set = [ones(15000,1) test_set];


[w12] = ho_kay_proc(train_1_2);
[w13] = ho_kay_proc(train_1_3);
[w23] = ho_kay_proc(train_2_3);

train_1_2(5001:10000,:) = -1 .* train_1_2(5001:10000,:);
test_set = train_1_2;

% open file for writing to
%out_file = fopen('ho-kayshap-1-2-classified.txt', 'w');
class = zeros(10000,1);

for i = 1:10000
    t1 = test_set(i,:) * w12;
    t2 = test_set(i,:) * w13;
    t3 = test_set(i,:) * w23;
    
%     if t1 > 0 && t2 > 0
%         fprintf(out_file, '%d\n', 1);
%     elseif t1 < 0 && t3 > 0
%         fprintf(out_file, '%d\n', 2);
%     elseif t2 < 0 && t3 < 0
%         fprintf(out_file, '%d\n', 3);
%     else
%         r = randi([1 3]);
%         x = x + 1;
%         fprintf(out_file, '%d\n', r);
%     end
    if t1 > 0
        class(i) = 1;
    else
        class(i) = 2;
    end
    
end

key = ones(10000,1);
key(1:5000) = 1;
key(5001:10000) = 2;

C = confusionmat(key,class)

function [w] = ho_kay_proc(Y)

    MAX_STEPS = 1000;
    rho = 0.9; % learning rate
    k = 0; % counter
    
    w = ones(5,1);
    b = ones(10000,1);
    
    while (k < MAX_STEPS && abs(min(Y * w)) > 0.01)     
        w = (Y' * Y) \ Y' * b;
        
        e = ((Y * w) - b);
        
        c = 0.5 * (e + abs(e));
        
        b = b + (rho * c);
        
        k = k + 1;
    end
end







