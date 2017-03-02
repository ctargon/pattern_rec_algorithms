%
%  Program: bayesian.m
%  Author:  Colin Targonski
%  Course:  ECE 8560 Pattern Recognition
%  Date:    2/7/2017
%
%  Details: This program was created in an effort to design and test a
%           minimum error Bayesian classifier using a given training and
%           test set which can be found in the 'data' directory.
%

clear
clc

% constants
TEST_SIZE = 15000;

% first open the training data to read into a matrix
train_file = fopen('../data/train_sp2017_v19');

training_set = cell2mat(textscan(train_file, '%f %f %f %f'));

fclose(train_file);

% open the test data and save to a matrix
test_file = fopen('../data/train_sp2017_v19');

test_set = cell2mat(textscan(test_file, '%f %f %f %f'));

fclose(test_file);

% split training data into 3 classes
c1_tr_set = training_set(1:5000,:);
c2_tr_set = training_set(5001:10000,:);
c3_tr_set = training_set(10001:15000,:);

% calculate class specific mean vectors and covariance matrices
mu_c1 = mean(c1_tr_set);
sigma_c1 = cov(c1_tr_set);

mu_c2 = mean(c2_tr_set);
sigma_c2 = cov(c2_tr_set);

mu_c3 = mean(c3_tr_set);
sigma_c3 = cov(c3_tr_set);

% open file for writing to
out_file = fopen('train-classified.txt', 'w');

% preallocate class vector
class = zeros(TEST_SIZE,1);
train_labels = zeros(TEST_SIZE,1);

% calculate discriminant function based on the Gaussian model
for i = 1:TEST_SIZE
    x = test_set(i,:);
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
    
    if i < 5001
        train_labels(i) = 1;
    elseif i > 5000 && i < 10001
        train_labels(i) = 2;
    else
        train_labels(i) = 3;
    end
    
    % write classification of ith vector line by line
    fprintf(out_file, '%d\n', class(i));
        
end

sum = 0;
for i = 1:TEST_SIZE
    if class(i) ~= train_labels(i)
        sum = sum + 1;
    end
end

fprintf('The classifier correctly classified %4.2f%% of training vectors.\n', (1 - (sum/15000)) * 100);
fprintf('The classification error on training data is %.3f.\n', sum / 15000);

% close output file
fclose(out_file);
