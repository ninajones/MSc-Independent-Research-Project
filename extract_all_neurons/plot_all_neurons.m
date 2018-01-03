%% This script uses the function avg_and_std_around_trial_ends_all_neurons within two for loops to plot the average meas values 
%% (including standard deviations and standard errors) from -8 to +8 (+/-1 second) around trial ends for all 
%% four position possibilities (RR, RL, LR, and LL) for all 415 neurons.

% initialises variables
moments_around_end = -8 : 8; 
dt = median(diff(resB.t));

% creates Figure directory to store the plots for all neurons
mkdir Figures; 

% n represents the number of neurons in the loaded dataset
n = length(res2pM(:,1));

for neuron_num = 1:n  % iterate through neuron 1 through n
        
    % create figure for this neuron
    figure('visible','off'); % suppresses plots from popping up
    % allow plot multiple using `hold` function
    hold on;
    
    colors = ['r', 'b', 'y', 'g'];

    % use this to loop through combinations of R and L
    for stim_pos = ['R', 'L'] % for R, then for L ('' for char and "" for string)
        for behav_resp = ['R', 'L'] % for R, then for L
            
            sample_size = (length(resB.stimPos(:,8)==stim_pos & resB.behavResp(:,6)==behav_resp));
            
            % calculate the averages and standard deviations at each time point, to be included in the plot
            current_result = avg_and_std_around_trial_ends_all_neurons(res2pM(neuron_num,:), stim_pos, behav_resp, resB);          
            avg_results = current_result.avg_around_trial_ends;
            std_results = current_result.std_around_trial_ends;
            stderror_results = std_results./(sqrt(sample_size));
                          
            curr_col = colors(end);
            colors(end) = []; 
            
            % create plot
            plot((moments_around_end)*dt, avg_results, curr_col, (moments_around_end)*dt, avg_results+stderror_results, curr_col, (moments_around_end)*dt, avg_results-stderror_results, curr_col);
            
        end          
    end
    
    % save current neuron figure
    title('Mean Meas Amt +/-SE at Time (Secs) +/-1 Sec Within Trial Ends')
    xlabel('Time (Secs) +/-1 Sec Within Trial Ends')
    ylabel('Mean Meas Amts +/-SE')
    legend('RR+SE','RR','RR-SE','RL+SE','RL','RL-SE','LR+SE','LR','LR-SE','LL+SE','LL','LL-SE')
    
    hold off;
    the_filename=strcat('Figures/Neuron',num2str(neuron_num),'.png'); 
    saveas(gca,the_filename); 
    
end
          
