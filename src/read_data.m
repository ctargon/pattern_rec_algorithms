function [training_set, test_set] = read_data(train_path, test_path)

    % first open the training data to read into a matrix
    train_file = fopen(train_path);

    training_set = cell2mat(textscan(train_file, '%f %f %f %f'));

    fclose(train_file);

    % open the test data and save to a matrix
    test_file = fopen(test_path);

    test_set = cell2mat(textscan(test_file, '%f %f %f %f'));

    fclose(test_file);

end