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
    
    dt = 0.001; %or sample rate = 1/dt (Hz)
    tMax = 10;
    t = (0 : dt : tMax)';
    norm_max_xcorr_mag = @(x,y)(max(abs(xcorr(x,y)))/(norm(x,2)*norm(y,2)));
    neighbor_1 = randn(length(t), 1);
    coin = rand;
    if(coin >= 0.5)
        neighbor_2 = randn(length(t), 1);
    else
        neighbor_2 = [zeros(2,1); 3.*neighbor_1(1:length(t)-4,:); 1;-2];
    end       
    signal_similarity = norm_max_xcorr_mag(neighbor_1,neighbor_2);
    % if the neighbor fingerprints are similar, then signal_similarity will be close to 1 
    spoof_flag = 0; % 1 - spoof detected, 0 - spoof not detected
    if(signal_similarity >= spoof_threshold)
        spoof_flag = 1;
    else
        spoof_flag = 0;
    end
    
    % After Detecting Spoofing Attack    
    D_2 = D_1(1:end-1, 1:end-1); % Removing Spoofed Node
    A_2 = A_1(1:end-1, 1:end-1); % Removing Spoofed Node 
    L_2 = D_2 - A_2;
    
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
                before_sort = check_neighbor_fingerprints(i, m, before_sort, condition);
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