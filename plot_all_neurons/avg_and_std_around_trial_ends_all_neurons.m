%% This function calculates the average measurements for a given measurement (neuronal firing, licking 
%% amounts, etc), -/+ 8 around trial ends. The function also calculates the standard deviations of the 
%% mean at -/+ 8 around trial ends.

%% The input values of this function are four parameters: the meas, the position of the reward, 
%% the position the mouse occupies, and the dataset containing these position values.

%% The output values of this function are the average meas values from -8 to +8 (+/-2 seconds) 
%% around trial ends for any positions entered in a script using this function.

function res = avg_and_std_around_trial_ends_all_neurons(meas, stimPosValue, behavRespValue, resB)
    trial_end_rows = find(resB.trialBnd); % finds columns with value 1 (trial end columns)
    whereStimPosDir = resB.stimPos(1:end, 8) == stimPosValue; % looking at column 8 (R or L) for all rows and check if equal to reward position
    whereBehavRespDir = resB.behavResp(1:end,6) == behavRespValue; % looking at column 6 (R or L) for all rows and check if equal to mouse position
    trial_end_conditions = whereStimPosDir & whereBehavRespDir; % if RR, then whereStimPosDir = 1 and whereBehavRespDir = 1
    trial_end_rows = trial_end_rows(trial_end_conditions); % find end row indices of the input positions only

    %% calculate average amount and SD of meas for nth measurement before and after trial end
    res.avg_around_trial_ends = []; % assigns vector containing means to res.avg_around_trial_ends
    res.std_around_trial_ends = []; % assigns vector containing standard devs to res.std_around_trial_ends
    
    moments_around_end = -8 : 8;
    for n = moments_around_end
        rows_n_before_end = trial_end_rows + n;
        meas_n_before_end = meas(rows_n_before_end); % neuronal activities/licking intensities for all rows corresponding to current of the 17
        mean_meas_n_before_end = mean(meas_n_before_end); % avg of all rows for this iteration (17 total)
        std_meas_n_before_end = std(meas_n_before_end); % std of all rows for this iteration (17 total)    
        
        %% add mean and std of meas amounts at current moment to separate vectors
        res.avg_around_trial_ends(end + 1) = mean_meas_n_before_end;
        res.std_around_trial_ends(end + 1) = std_meas_n_before_end;
    end
    % return the avg_around_trial_ends and std_around_trial_ends by removing semi-colon
    res; 
end
