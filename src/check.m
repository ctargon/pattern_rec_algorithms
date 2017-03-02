%% check.m


% first open the training data to read into a matrix
train_file = fopen('../results/ctargon-classified-takehome1.txt');

classified = cell2mat(textscan(train_file, '%f'));

fclose(train_file);

correct = 0;
i = 1;

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

fprintf('Number correct: %d   Accuracy: %.4f\n', correct, correct / 15000);
