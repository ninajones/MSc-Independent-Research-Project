%% A function that calculates the average measurements for a given measurement (neuronal firing, licking 
%% amounts, etc), -/+ 8 around trial ends. The function also calculates the standard deviations of the 
%% mean at -/+ 8 around trial ends.

%% The input values of this function are four parameters: the meas, the position of the reward, 
%% the position the mouse occupies, and the dataset containing these position values.

%% The output values of this function are the average meas values and standard deviations from -8 to +8 
%% (+/-1 seconds) around trial ends.

function res = avg_and_std_around_trial_ends_place_cells(meas, stimPosValue, behavRespValue, resB) % function avg_and_std_around_trial_ends_place_cells has 4 parameters
    %% calculate average amount and SD of meas for nth measurement before and after trial end
    res.avg_around_trial_ends = []; % assigns vector containing means to res.avg_around_trial_ends
    res.std_around_trial_ends = []; % assigns vector containing standard devs to res.std_around_trial_ends
    
    moments_around_end = -8 : 8;
    for n = moments_around_end
        meas_n_before_end = get_meas_n_before_end(meas, stimPosValue, behavRespValue, resB, n);
        mean_meas_n_before_end = mean(meas_n_before_end); % avg of all rows for this iteration (17 total)
        std_meas_n_before_end = std(meas_n_before_end); % std of all rows for this iteration (17 total) 
        
        %% add mean and std of meas amounts at current moment to separate vectors
        res.avg_around_trial_ends(end + 1) = mean_meas_n_before_end;
        res.std_around_trial_ends(end + 1) = std_meas_n_before_end;

    end

    % return the avg_around_trial_ends and std_around_trial_ends by removing semi-colon
    res;
    
end
