function [ similar_cluster ] = clustering_results(i,m)
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
    angle_of_arrival = [normrnd(200,2) normrnd(130,2) normrnd(285,2) normrnd(90,2) normrnd(220,2) normrnd(20,2) normrnd(300,2) normrnd(305,2)]';
    reflected_arrival_angles = [normrnd(210,2) normrnd(140,2) normrnd(295,2) normrnd(100,2) normrnd(230,2) normrnd(30,2) normrnd(305,2) normrnd(310,2)]';
    first_amplitude = [normrnd(3,2) normrnd(15,2) normrnd(45,2) normrnd(85,2) normrnd(60,2) normrnd(78,2) normrnd(28,2) normrnd(30,2)]';
    second_amplitude = 0.5*first_amplitude;
    arrival_time = [normrnd(5,2) normrnd(25,2) normrnd(55,2) normrnd(95,2) normrnd(70,2) normrnd(88,2) normrnd(38,2) normrnd(39,2)]';
    agents_signal_fingerprints = [angle_of_arrival reflected_arrival_angles first_amplitude second_amplitude arrival_time];
    naive_bayes_classifier( i, agents_signal_fingerprints );
    agents_signal_fingerprints(i,:) = zeros(size(agents_signal_fingerprints,2),1);
    Y = pdist(agents_signal_fingerprints);
    Z = linkage(Y);
    for i = 1:size(Z,1)
        if(max(Z(i,1:2)) > m)
            cutoff_distance = Z(i,3);
            break;
        end
    end
    % Lower the cutoff_distance value by some epsilon for pruning
    cutoff_distance = cutoff_distance - 0.01; 
    I = inconsistent(Z);
    T = cluster(Z,'cutoff',cutoff_distance,'criterion','distance');
    u = unique(T);
    n = histc(T,u);
    similar_cluster = find(ismember(T,u(n>1)));
    if(size(similar_cluster,1)>2)
%         figure;
%         dendrogram(Z,'ColorThreshold','default')
%         print 'Hi';
    end

end

