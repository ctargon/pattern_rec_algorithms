%
%  Program: knn.m
%  Author:  Colin Targonski
%  Course:  ECE 8560 Pattern Recognition
%  Date:    3/8/2017
%
%  Details: This program was created in an effort to design and test a
%           minimum error k-Nearest Neighbor classifier
%

clear
clc

% constants
TEST_SIZE = 15000;

[training_set, test_set] = read_data('../data/train_sp2017_v19','../data/test_sp2017_v19');

% run knn for 1, 3, and 5 neighbors
s = calc_n_knn(training_set, test_set, 5);

function [sorted] = calc_n_knn(train, test, n)

    % declare correct labes
    labels = zeros(15000, 1);
    labels(1:5000) = 1;
    labels(5001:10000) = 2;
    labels(10001:15000) = 3;
    
    % declare vote counts
    v1 = 0;
    v2 = 0;
    v3 = 0;
    
    % open file for writing to
    out_file = fopen('knn-5-classified.txt', 'w');

    for i = 1:15000
        fprintf('%d\n', i);
        distances = zeros(15000, 1);
        
        % declare vote counts
        v1 = 0;
        v2 = 0;
        v3 = 0;        

        for j = 1:15000
            distances(j) = dist_func(test(i,:), train(j,:));
        end
        distances_labeled = horzcat(distances, labels);
        
        % sort distances while preserving correct labels
        sorted = sortrows(distances_labeled, 1);
        
        if n == 1
            % write classification of ith vector line by line
            fprintf(out_file, '%d\n', sorted(1,2));
        elseif n == 3
            for k = 1:3
                if sorted(k,2) == 1
                    v1 = v1 + 1;
                elseif sorted(k,2) == 2
                    v2 = v2 + 1;
                else
                    v3 = v3 + 1;
                end
            end
            
            if v1 > v2 && v1 > v3
                fprintf(out_file, '%d\n', 1);
            elseif v2 > v1 && v2 > v3
                fprintf(out_file, '%d\n', 2);
            else
                fprintf(out_file, '%d\n', 3);
            end      
        elseif n == 5
            for k = 1:5
                if sorted(k,2) == 1
                    v1 = v1 + 1;
                elseif sorted(k,2) == 2
                    v2 = v2 + 1;
                else
                    v3 = v3 + 1;
                end
            end
            
            if v1 > v2 && v1 > v3
                fprintf(out_file, '%d\n', 1);
            elseif v2 > v1 && v2 > v3
                fprintf(out_file, '%d\n', 2);
            else
                fprintf(out_file, '%d\n', 3);
            end            
        end      
    end
    

end

function [distance] = dist_func(x, y)
    distance = norm(x - y);
end