%% check.m

% first open the training data to read into a matrix
train_file = fopen('../results/ctargon-classified-takehome1.txt');

classified = cell2mat(textscan(train_file, '%f'));

fclose(train_file);

correct = 0;
i = 1;

% determine if the classified file matches the pattern 3-1-2-3-2-1
% and count each class that was predicted correctly
while (i <= 15000)
    if classified(i) == 3
        correct = correct + 1;
    end
    i = i + 1;
    if classified(i) == 1
        correct = correct + 1;
    end
    i = i + 1;
    if classified(i) == 2
        correct = correct + 1;
    end
    i = i + 1;
    if classified(i) == 3
        correct = correct + 1;
    end
    i = i + 1;
    if classified(i) == 2
        correct = correct + 1;
    end
    i = i + 1;
    if classified(i) == 1
        correct = correct + 1;
    end
    i = i + 1;
    
end

key = zeros(15000,1);
i = 1;

% correct pattern is 3-1-2-3-2-1 repeated for 2500 iterations
while i <= 15000
    key(i)   = 3;
    i = i+1;
    key(i) = 1;
    i = i+1;
    key(i) = 2;
    i = i+1;
    key(i) = 3;
    i = i+1;
    key(i) = 2;
    i = i+1;
    key(i) = 1;
    i = i+1;
end

% determine the confusion matrix
C = confusionmat(key, classified);

% print the number classified correctly and the associated confusion matrix
fprintf('Number correct: %d   Accuracy: %.4f\n', correct, correct / 15000);
fprintf('The confusion matrix is as follows:');
display(C);
