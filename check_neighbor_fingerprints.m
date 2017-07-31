function [ similar_agents ] = check_neighbor_fingerprints( m, spoof_threshold, condition )
% funtion check_neighbor_fingerprints does a pairwise comparison of the 
% spatial fingerprints of an agents' neighbors, finds similarities and
% if needed removes the spoofed neighbor. 

    steps = 0.001;
    max_time = 10;
    time = (0 : steps : max_time)';
    
    % Function to compare the similarities between two signals
    check_signals_similarity = @(x,y)(max(abs(xcorr(x,y)))/(norm(x,2)*norm(y,2)));
    
    % Simulating agents fingerprints as random signals
    agents_signal_fingerprints = randn(m, length(time));  
    number_vector = [1 2 3 4 5 6 7 8]';
    agents_signal_fingerprints = [number_vector agents_signal_fingerprints];
    
    % m^{th} agent is spoofed by (m-1)^{th} agent 
    % So m^{th} agent's fingerprint looks like delayed and amplified fingerprint of (m-1)^{th} agent with some noise 
    % Following line adds delay of 2 seconds and scales by 3 times 
    agents_signal_fingerprints(m,:) = [m, zeros(1,2), 3.*agents_signal_fingerprints(m-1, 2:length(time)-1)];
    
    % delete dummy !!!
    dummy = check_signals_similarity(agents_signal_fingerprints(m-1,:), agents_signal_fingerprints(m,:));
    
    % Adding white noise to signal fingerprints
    signal_to_noise_ratio = max_time; % we can vary this as a parameter too
    agents_signal_fingerprints = awgn(agents_signal_fingerprints,signal_to_noise_ratio,'measured');    
    neighbor_fingerprints = agents_signal_fingerprints;
    % remove agents which aren't the neighbors of the agent i
    neighbor_fingerprints(condition,:) = [];  
    rows = size(neighbor_fingerprints,1);
    
    % do pairwise comparison of fingerprints
    combinations = nchoosek(1:rows, 2); 
    similar_agents = [];
    for j = 1:size(combinations,1)
        %similarity = check_signals_similarity(agents_signal_fingerprints(combinations(j,1),:), agents_signal_fingerprints(combinations(j,2),:));
        similarity = check_signals_similarity(neighbor_fingerprints(combinations(j,1),2:end), neighbor_fingerprints(combinations(j,2),2:end));
        % remove if similar
        if(similarity >= spoof_threshold)
            if(~ismember(combinations(j,1), similar_agents))
                similar_agents = [similar_agents; neighbor_fingerprints(combinations(j,1),1)];
            end
            if(~ismember(combinations(j,2), similar_agents))
                similar_agents = [similar_agents; neighbor_fingerprints(combinations(j,2),1)];
            end
        end
    end
end

