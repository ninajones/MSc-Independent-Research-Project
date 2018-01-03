%% This script uses get_meas_n_before_end.m to extract the neuronal activities at -1 at LL and LR. It then
%% uses the rank sum test to determine if the values for LL and LR are significantly different and the neuron is
%% thus a place cell. For only place cells, this script uses the function avg_around_trial_ends to plot the average 
%% meas values (including standard deviations and standard errors) from -8 to +8 (+/-1 second) around trial ends 
%% for all four position possibilities (RR, RL, LR, and LL). It also prints the neurons which are place cells.

% initialises variables
moments_around_end = -8:8;
dt = median(diff(resB.t));

% creates Figure directory to store the n plots
mkdir Figures;

% n represents the number of neurons in the loaded dataset
n = length(res2pM(:,1));
stim_pos = 'L';

% creates neuron_activity_LL and neuron_activity_LR vectors
neuron_activity_LL = [];
neuron_activity_LR = [];

for neuron_num = 1:n  % iterates through neuron 1 through n
    
    % LL and LR values are extracted for the current neuron at -1
    LL_values = get_meas_n_before_end(res2pM(neuron_num,:), stim_pos, 'L', resB, -1);
    LR_values = get_meas_n_before_end(res2pM(neuron_num,:), stim_pos, 'R', resB, -1);
    
    % using rank sum test to compare LL values and LR values at -1
    [p,can_reject_null_hypothesis] = ranksum(LL_values, LR_values);

    % if can_reject_null_hypothesis = 1, p is less than 5% and thus the
    % null hypothesis is rejected and the current neuron is a place cell
    if can_reject_null_hypothesis % meaning rejects null hypothesis
    
    
            % adds LL and LR values in each iteration to their respective
            % vector
            neuron_activity_LL = [neuron_activity_LL; LL_values];
            neuron_activity_LR = [neuron_activity_LR; LR_values];
    
             % statement is returned if the neuron is a place cell
             fprintf('Neuron %i is a place cell.\n', neuron_num);
             % create figure for the place cell
             figure('visible','off'); % suppresses plots from popping up
             % allow plot multiple using `hold` function
             hold on;

             colors = ['r', 'b', 'y', 'g'];

             % use this to loop through combinations of R and L
             for stim_pos = ['R', 'L'] % for R, then for L
                  for behav_resp = ['R', 'L'] % for R, then for L

                      sample_size = length(resB.stimPos(:,8)==stim_pos & resB.behavResp(:,6)==behav_resp);

                      % calculate the averages and standard deviations at
                      % each time point, to be included in the plot
                      current_result = avg_and_std_around_trial_ends_place_cells(res2pM(neuron_num,:), stim_pos, behav_resp, resB);
                      avg_results = current_result.avg_around_trial_ends;
                      std_results = current_result.std_around_trial_ends;
                      stderror_results = std_results./(sqrt(sample_size));

                      curr_col = colors(end);
                      colors(end) = [];  

                      % create plot at all time points and LL, LR, RL, and RR for the place cell
                      plot((moments_around_end)*dt, avg_results, curr_col, (moments_around_end)*dt, avg_results+stderror_results, curr_col, (moments_around_end)*dt, avg_results-stderror_results, curr_col);

                  end          
             end

             % save the current place cell figure
             title('Mean Meas Amt +/-SE at Time (Secs) +/-1 Sec Within Trial Ends')
             xlabel('Time (Secs) +/-1 Sec Within Trial Ends')
             ylabel('Mean Meas Amts +/-SE')
             legend('RR+SE','RR','RR-SE','RL+SE','RL','RL-SE','LR+SE','LR','LR-SE','LL+SE','LL','LL-SE')

             hold off;
             the_filename=strcat('Figures/Neuron',num2str(neuron_num),'.png'); 
             saveas(gca,the_filename); 
    end

end

% transpose the rows into columns so that each place cell is a column
neuron_activity_LL_transposed = neuron_activity_LL.';
neuron_activity_LR_transposed = neuron_activity_LR.';

% write the LL and LR activities to separate CSV files
csvwrite('neuron_activity_LL.csv',neuron_activity_LL_transposed)
csvwrite('neuron_activity_LR.csv',neuron_activity_LR_transposed)


 
