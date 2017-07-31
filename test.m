function x = test(m, F, time_span, delay, spoof_threshold, x_0)
%Function test updates the information state of each
%vehicles after sorting & removing extreme values from its in-neighbors
%according to W_MSR algorithm    
    
    time_vec = 0:1:time_span;
    x = zeros(m, length(time_vec));
    % Set values of all vehicles at time = 0 to x_0
    x(:,1) = x_0;   
    x(7,:) = 300;
    x(8,:) = 300;
    % Before Detecting Spoofing Attack
    degree_vector_1 = [2 3 4 4 4 3 2 2];
    D_1 = diag(degree_vector_1);
    A_1 = [0 1 1 0 0 0 0 0
           1 0 1 1 0 0 0 0
           1 1 0 1 1 0 0 0
           0 1 1 0 1 1 0 0
           0 0 1 1 0 1 1 1
           0 0 0 1 1 0 1 1
           0 0 0 0 1 1 0 0
           0 0 0 0 1 1 0 0];
    L_1 = D_1 - A_1;
    
    D_2 = D_1;
    A_2 = A_1;
    
    spoof_flag = 0; % 1 - spoof detected, 0 - spoof not detected
    agent_similarity_counter = zeros(m,1);
    
    k = 1;
    while(k <= delay)
        for i = 1:m  
            if (i~=7 && i~=8)                
                L_i_row = L_1(i,:)';
                before_sort = [x(:,k) L_i_row];
                % Extract only in-neighbors
                condition = L_i_row >= 0;
                before_sort(condition,:) = [];  
                before_sort = before_sort(:,1);  
                
                % NEW CODE - not to be written here!!!
                similar_agents = check_neighbor_fingerprints(m, spoof_threshold, condition);
                agent_similarity_counter(similar_agents) = agent_similarity_counter(similar_agents) + 1;
                % removing larger values - sort descendingly
                ascend_sort = sortrows(before_sort, -1);              
                indices = ascend_sort > x(i,(k));
                if(~isempty(indices))
                    if(length(indices) > F)
                        % if # of values larger than x(i) > F, delete F larger ones
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        % else delete all larger values
                        ascend_sort(indices,:) = [];
                    end
                end
                % removing smaller values - sort ascendingly           
                ascend_sort = sortrows(ascend_sort);
                indices = find(ascend_sort < x(i,(k)));
                if(~isempty(indices))
                    if(length(indices) > F)
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        ascend_sort(indices,:) = [];
                    end
                end
                remaining_count = length(ascend_sort);
                weight = 1/(remaining_count+1);
                sum_weights = sum(ones(remaining_count+1,1)*weight); % should be 1
                x(i,k+1) = sum(weight*ascend_sort) + weight* x(i,(k)); 
            end
        end
        k = k + 1;
    end    
    
    % After Detecting Spoofing Attack  
    malicious_indices = find(agent_similarity_counter~=0);
    
    if(malicious_indices)    
        indices_to_remove = randperm(length(malicious_indices),length(malicious_indices)-F); % current algorithm tolerates upto F malicious agents in the network
        indices_to_remove = sort(indices_to_remove,'descend');
        spoof_flag = 1;

        % remove the specified row and column from degree matrix and adjacency matrix
        for index_to_remove = 1:length(indices_to_remove)        
            D_2(index_to_remove,:) = [];
            D_2(:,index_to_remove) = [];
            A_2(index_to_remove,:) = [];
            A_2(:,index_to_remove) = [];
        end
        L_2 = D_2 - A_2;    
    end
    
    % Spoof flag = 0 -> spoof not detected
    while(k <= length(time_vec) && k > delay && spoof_flag == 0)
        for i = 1:m       
            if (i~=7 && i~=8)
                L_i_row = L_1(i,:)'; % use new L matrix
                before_sort = [x(:,k) L_i_row];
                % Extract only in-neighbors
                condition = L_i_row >= 0;
                before_sort(condition,:) = [];  
                before_sort = before_sort(:,1);                      
                % removing larger values - sort descendinlgy
                ascend_sort = sortrows(before_sort, -1);              
                indices = find(ascend_sort > x(i,k));
                if(~isempty(indices))
                    if(length(indices) > F)
                        % if # of values larger than x(i) > F, delete F larger ones
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        % else delete all larger values
                        ascend_sort(indices,:) = [];
                    end
                end
                % removing smaller values - sort ascendingly
                ascend_sort = sortrows(ascend_sort);
                indices = find(ascend_sort < x(i,k));
                if(~isempty(indices))
                    if(length(indices) > F)
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        ascend_sort(indices,:) = [];
                    end
                end
                remaining_count = length(ascend_sort);
                weight = 1/(remaining_count+1);
                sum_weights = sum(ones(remaining_count+1,1)*weight); % should be 1
                x(i,k+1) = sum(weight*ascend_sort) + weight* x(i,k);             
            end
        end
        k = k + 1;
    end
    
    % After spoofing has been detected and spoofed node was removed from
    % the network
    if(spoof_flag == 1)
        m = m - 1;
        x(8,:) = []; % Removing spoofed node from the network
    end
          
    % Spoof flag = 1 -> spoof detected and removed
    while(k <= length(time_vec) && k > delay && spoof_flag == 1)
        for i = 1:m       
            if (i~=7)
                L_i_row = L_2(i,:)'; % use new L matrix
                before_sort = [x(:,k) L_i_row];
                % Extract only in-neighbors
                condition = L_i_row >= 0;
                before_sort(condition,:) = [];  
                before_sort = before_sort(:,1);                      
                % removing larger values - sort descendinlgy
                ascend_sort = sortrows(before_sort, -1);              
                indices = find(ascend_sort > x(i,k));
                if(~isempty(indices))
                    if(length(indices) > F)
                        % if # of values larger than x(i) > F, delete F larger ones
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        % else delete all larger values
                        ascend_sort(indices,:) = [];
                    end
                end
                % removing smaller values - sort ascendingly
                ascend_sort = sortrows(ascend_sort);
                indices = find(ascend_sort < x(i,k));
                if(~isempty(indices))
                    if(length(indices) > F)
                        for j = 1:F
                            ascend_sort(indices(j),:) = [];
                        end
                    else
                        ascend_sort(indices,:) = [];
                    end
                end
                remaining_count = length(ascend_sort);
                weight = 1/(remaining_count+1);
                sum_weights = sum(ones(remaining_count+1,1)*weight); % should be 1
                x(i,k+1) = sum(weight*ascend_sort) + weight* x(i,k);             
            end
        end
        k = k + 1;
    end
end