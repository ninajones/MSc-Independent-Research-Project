%% This script creates a comparison among 1 column of 30 green apples and 30 red apples, and 
%% 3,5,7,10,12, and 15 columns in order to find if the model is more accurate in predicting 
%% colour when there are more columns than with less columns. New data is generated for each 
%% amount of columns. For each for loop iteration, the new data is used to train the model and 
%% then more data is generated to test the model's predictions. The proportions of correct 
%% predictions (when the predicted colour matches the test data colour) are printed for each 
%% amount of columns.

% total amount of red and green apple weights per column generated 
sample_size = 60;

% each iteration generates 60 rows of weights for a different amount of columns per iteration
for weights_per_row = [1,3,5,7,10,12,15] 

    % amount of red apples per column = 30, amount of green apples per
    % column = 30
    red_count = sample_size / 2;
    grn_count = red_count;

    % mean of generated red apple data is 80 and the standard deviation is
    % 5
    red_mean = 80;
    red_sd = 5; % values are spread out between 75 and 85

    % mean of generated green apple data is 90 and the standard deviation is
    % 5
    grn_mean = 90;
    grn_sd = 5; % values are spread out between 85 and 95

    % Generates the data to be used to train the model. Red and green apple 
    % weights are generated and then concatenated in a vector. 
    red_training_weights = normrnd(red_mean, red_sd, red_count,weights_per_row);
    grn_training_weights = normrnd(grn_mean, grn_sd, grn_count,weights_per_row); 
    training_weights_concat = vertcat(red_training_weights, grn_training_weights);

    % Generates the data to be used to test the model. Red and green apple 
    % weights are generated and then concatenated in a vector. 
    red_test_weights = normrnd(red_mean, red_sd, red_count,weights_per_row);
    grn_test_weights = normrnd(grn_mean, grn_sd, grn_count,weights_per_row); 
    test_weights_concat = vertcat(red_test_weights, grn_test_weights);
    
    % Create 30 rows of "red" and 30 rows of "green" and then concatenate 
    % in a vector of 60 to represent the colours corresponding to the
    % trained and test weight rows
    colours = vertcat(repmat("red",red_count,1),repmat("grn",grn_count,1));

    % training and test rows to be used are 1-60
    training_rows = reshape(1:60,60,1);
    test_rows = reshape(1:60,60,1);

    % use the training data to train the model:
    training_weights = training_weights_concat(training_rows,:); % training weights are extracted from all training rows and columns
    training_colours = colours(training_rows); % extracts the colours corresponding to the 60 training rows
    Mdl = fitcdiscr(training_weights,training_colours); % train model with the 60 training weights and colours

    % Evaluates how good this model is by using the newly generated test
    % data to see if the model can predict the correct colours given the weights of
    % the test data:
    test_weights = test_weights_concat(test_rows,:); % extracts the weights corresponding to the test rows
    test_colours = colours(test_rows); % extracts the colours corresponding to the 60 test rows
    predicted_colours = cellstr(predict(Mdl, test_weights)); % char converted to string and model used to predict the colours after given the weights corresponding to the test rows

    % calculate the number of correct predictions by comparing
    % predicted_colours to test_colours
    is_correctly_predicted = predicted_colours == test_colours; % given a value of 1 if the colours predicted match the actual colours of the test rows

    % use number non-zero function to count correctly predicted
    number_correct = nnz(is_correctly_predicted);

    % calculate the percentage that are correct
    fprintf("Percent correctly predicted for %d apple column(s) is %f\n", weights_per_row, (number_correct / sample_size)*100);
end
