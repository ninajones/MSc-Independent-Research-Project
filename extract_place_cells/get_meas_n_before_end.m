%% Here is a function to extract the neuronal activities for a given meas (neuronal firing, licking amounts, 
%% etc) at offset_from_end from the trial ends.

%% The input values of this function are five parameters: the meas, the position of the reward, 
%% the position the mouse occupies, the dataset containing these position values, and offset_from_end from the 
%% trial ends (it is given a value of -1 in print_and_plot_place_cells.m).

%% The output values of this function are the neuronal activities at offset_from_end from the trial ends.


function res = get_meas_n_before_end(meas, stimPosValue, behavRespValue, resB, offset_from_end)
    trial_end_rows = find(resB.trialBnd); % finds columns with value 1 (trial end columns)
    whereStimPosDir = resB.stimPos(1:end, 8) == stimPosValue; % looking at column 8 (R or L) for all rows and check if equal to reward position
    whereBehavRespDir = resB.behavResp(1:end,6) == behavRespValue; % looking at column 6 (R or L) for all rows and check if equal to mouse position
    
    trial_end_conditions = whereStimPosDir & whereBehavRespDir; % if RR, then whereStimPosDir = 1 and whereBehavRespDir = 1
    trial_end_rows = trial_end_rows(trial_end_conditions); % find end row indices of the input positions only
    
    
    rows_n_before_end = trial_end_rows - offset_from_end; % rows containing values at offset_from_end from trial ends
    
    % neuronal activities/licking intensities for all rows corresponding to
    % offset_from_end from trial ends
    res = meas(rows_n_before_end);
end
