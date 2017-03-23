%
%  Program: pca.m
%  Author:  Colin Targonski
%  Course:  ECE 8560 Pattern Recognition
%  Date:    3/14/2017
%
%  Details: This program was created in an effort to reduce the
%  dimensionality of a dataset by performing Principle Component Analysis
%  (PCA) on both the training and the test set.  
%

clear
clc

% constants
TEST_SIZE = 15000;

[training_set, test_set] = read_data('../data/train_sp2017_v19','../data/test_sp2017_v19');

% first standardize the data
training_set = training_set - mean(training_set);
training_set = training_set ./ std(training_set);

test_set = test_set - mean(test_set);
test_set = test_set ./ std(test_set);

% obtain covariance matrices for train and test set
cov_train = cov(training_set);
cov_test = cov(test_set);

% obtain the eigenvectors and eigenvalues of cov_train and cov_test
[V_train D_train] = eig(cov_train);
[V_test D_test] = eig(cov_test);

% obtain projection matrix from 2 eigenvectors that corresopond to the 
% largest eigenvalues (the last two in V)
W_train = V_train(:,3:4);
W_test = V_test(:,3:4);

% project original dataset into the reduced-dimension dataset
% temp1 = pca(training_set)';
% temp2 = pca(test_set)';
% W_train = temp1(:,3:4);
% W_test = temp2(:,3:4);
Y_train = training_set * W_train;
Y_test = test_set * W_test;

%
% now we will use a bayesian classifier on the reduced dataset to classify
%

% the test set
% split training data into 3 classes
c1_tr_set = Y_train(1:5000,:);
c2_tr_set = Y_train(5001:10000,:);
c3_tr_set = Y_train(10001:15000,:);

% calculate class specific mean vectors and covariance matrices
mu_c1 = mean(c1_tr_set);
sigma_c1 = cov(c1_tr_set);

mu_c2 = mean(c2_tr_set);
sigma_c2 = cov(c2_tr_set);

mu_c3 = mean(c3_tr_set);
sigma_c3 = cov(c3_tr_set);

% open file for writing to
out_file = fopen('pca-bayesian-classified.txt', 'w');

% preallocate class vector
class = zeros(TEST_SIZE,1);

% calculate discriminant function based on the Gaussian model
for i = 1:TEST_SIZE
    x = Y_test(i,:);
    prob1 = -0.5 * (x - mu_c1) * inv(sigma_c1) * (x - mu_c1)';
    prob2 = -0.5 * (x - mu_c2) * inv(sigma_c2) * (x - mu_c2)';
    prob3 = -0.5 * (x - mu_c3) * inv(sigma_c3) * (x - mu_c3)';
    
    if prob1 > prob2 && prob1 > prob3
        class(i) = 1;
    elseif prob2 > prob1 && prob2 > prob3
        class(i) = 2;
    else
        class(i) = 3;
    end
    
    % write classification of ith vector line by line
    fprintf(out_file, '%d\n', class(i));
        
end

%s = calc_n_knn(Y_train, Y_test, 5);

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
    out_file = fopen('pca-5-classified.txt', 'w');

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



