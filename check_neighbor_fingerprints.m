function [ before_sort ] = check_neighbor_fingerprints( i, m, before_sort, condition )
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
    
    % m^{th} agent is spoofed by (m-1)^{th} agent 
    % So m^{th} agent's fingerprint looks like delayed and amplified fingerprint of (m-1)^{th} agent with some noise 
    % Following line adds delay of 2 seconds and scales by 3 times 
    agents_signal_fingerprints(m,:) = [zeros(1,2), 3.*agents_signal_fingerprints(m-1, 1:length(time)-2)];
    
    % Adding white noise to signal fingerprints
    signal_to_noise_ratio = max_time-5; % we can vary this as a parameter too
    agents_signal_fingerprints = awgn(agents_signal_fingerprints,signal_to_noise_ratio,'measured');    
    
    % remove agents which aren't the neighbors of the agent i
    agents_signal_fingerprints(condition,:) = [];  
    [rows, cols] = size(agents_signal_fingerprints);
    
    % get indices of repeated values in before_sort vector
    % do pairwise comparison of fingerprints
    unique_vector = unique(before_sort);
    repeated_elements = unique_vector(histc(before_sort,unique_vector) > 1);
    num_of_repeated_elemets = length(repeated_elements);    
    for i = 1:num_of_repeated_elemets
        repeated_indices = find(ismember(before_sort,repeated_elements(i)));
        number_of_repeated_indices = length(repeated_indices);
        combinations = nchoosek(1:length(number_of_repeated_indices), 2);        
        for j = 1:size(combinations,1)
            check_signals_similarity(agents_signal_fingerprints(repeated_indices(combinations(j,1))), agents_signal_fingerprints(repeated_indices(combinations(j,2))));
            % remove if similar
        end
    end
    
    
end

