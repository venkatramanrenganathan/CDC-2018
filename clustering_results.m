function [ similar_cluster ] = clustering_results( m, agents_signal_fingerprints )
% clustering_results takes signal fingerprints of all agents as input and
% returns the clusters that have more than 1 elements depicting that the
% fingerprints grouped in same clusters are similar and are spoofed.
%
% INPUT
% agents_signal_fingerprints - m x t matrix, m agents fingerprints for t
% time steps
% k - number of physically present agents
%
% OUTPUT
% similar_cluster - array having agents indices that have similar
% fingerprints.
%
%     similar_cluster = [];
    agents_signal_fingerprints = [];
    angle_of_arrival = [240 160 285 90 290 20 330 325]';
    reflected_arrival_angles = [210 140 295 115 300 35 320 330]';
    first_amplitude = [10 40 58 25 60 75 55 55]';
    second_aplitude = 0.5*first_amplitude;
    a = 50;
    b = 100;
    arrival_time = (b-a).*rand(m,1) + a;
    agents_signal_fingerprints = [angle_of_arrival reflected_arrival_angles first_amplitude second_aplitude arrival_time];
    Y = pdist(agents_signal_fingerprints);
    Z = linkage(Y)
    for i = 1:size(Z,1)
        if(max(Z(i,1:2)) > m)
            cutoff_distance = Z(i,3);
            break;
        end
    end
    % Lower the cutoff_distance value by some epsilon for pruning
    cutoff_distance = cutoff_distance - 0.01 
    I = inconsistent(Z);
    T = cluster(Z,'cutoff',cutoff_distance,'criterion','distance')
    u = unique(T);
    n = histc(T,u);
    find(ismember(T,u(n>1)))
    %T = cluster(Z,'maxclust',m-1)
    figure;
    dendrogram(Z,'ColorThreshold','default')
    print 'hi'
end

