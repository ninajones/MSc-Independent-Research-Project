%% This script creates a comparison of model position predictions (L or R) for 1-all place cells in
%% order to find if the model is more accurate in predicting position when there are more place cells
%% than with less place cells. In each for loop iteration, half of the R and L trials are extracted 
%% and the same amount of R and L trials are used to train the data. The remaining R and L trials are 
%% used to test the model's predictions. The proportions of correct predictions (when the predicted 
%% position matches the test data position) are printed for each amount of columns.

% load activity data for L and R
load_data_LL = csvread("neuron_activity_LL.csv");
load_data_LR = csvread("neuron_activity_LR.csv");

% generate position data based on activity data
L_count = length(load_data_LL(:,1));
R_count = length(load_data_LR(:,1));
positions = vertcat(ones(L_count,1), repmat(2,R_count,1)); % 1 = L, 2 = R

% number of place cells for loaded dataset
num_place_cells = length(load_data_LR(1,:));

% each iteration uses last_place_cell amount of place cells per iteration 
% (1, then 2, then 3, then 4, etc)
first_place_cell = 1;

for last_place_cell = first_place_cell:num_place_cells

    % The data to be used to train the model comes from place cells numbers
    % first_place_cell through last_place_cell for L and R. These 
    % activities are then concatenated in a vector.
    L_training_activities = load_data_LL(:,(first_place_cell:last_place_cell));
    R_training_activities = load_data_LR(:,(first_place_cell:last_place_cell));
    training_activities_concat = vertcat(L_training_activities, R_training_activities);

    % The total number of trials
    sample_size = length(L_training_activities) + length(R_training_activities);
    
    % The data to be used to test the model comes from place cells numbers
    % first_place_cell through last_place_cell for L and R. These 
    % activities are then concatenated in a vector.
    L_test_activities = load_data_LL(:,(first_place_cell:last_place_cell));
    R_test_activities = load_data_LR(:,(first_place_cell:last_place_cell));
    test_activities_concat = vertcat(L_test_activities, R_test_activities);

    % The number of training rows (trials) to be used are half of the 
    % sample size rounded down. Of these, the trials used for the majority 
    % position will equal those of the minority position. For testing, the 
    % remaining R and L trials will be used.
    half_of_L_count = floor((L_count/2));
    half_of_R_count = floor((R_count/2));
    half_of_smallest = min(half_of_L_count,half_of_R_count);
    
    % The training rows will be the first half of the L rows and R rows 
    % rounded down and the majority position trials used will equal the 
    % minority position trials used.
    training_rows_LL = 1:half_of_smallest;
    first_LR_row_index = L_count+1;
    training_rows_LR = first_LR_row_index:first_LR_row_index+(half_of_smallest-1);
    training_rows = [training_rows_LL,training_rows_LR];
    
    % The remaining L and R trials rows not used to train will be used to 
    % test.
    test_rows_LL = half_of_smallest+1:L_count;
    first_LR_test_row_index = first_LR_row_index+half_of_smallest;
    last_LR_index = L_count+R_count;
    test_rows_LR = first_LR_test_row_index:last_LR_index;
    test_rows = [test_rows_LL,test_rows_LR]; 
    
    % Uses the training data to train the model:
    training_activities = training_activities_concat(training_rows,:); % training activities are extracted from all training rows and columns
    training_positions = positions(training_rows); % extracts the positions corresponding to all training rows    
    Mdl = fitcnb(training_activities,training_positions, 'DistributionNames', 'kernel'); % train model with the training activities and positions
     
    % Evaluates how good this model is by using the newly generated test
    % data to see if the model can predict the correct positions given the 
    % activities of the test data:
    test_activities = test_activities_concat(test_rows,:); % extracts the activities corresponding to the test rows
    test_positions = positions(test_rows); % extracts the positions corresponding to the test rows
    predicted_positions = predict(Mdl, test_activities); % model used to predict the positions after given the activities corresponding to the test rows

    % calculate the number of correct predictions by comparing
    % predicted_positions to test_positions
    is_correctly_predicted = predicted_positions == test_positions; % given a value of 1 if the positions predicted match the actual positions of the test rows

    % use number non-zero function to count correctly predicted
    number_correct = nnz(is_correctly_predicted);

    % calculate the proportion that are correct
    fprintf("Percent correctly predicted for %d place cell(s) is %f.\n", last_place_cell, (nnz(is_correctly_predicted)/length(is_correctly_predicted))*100);

end
