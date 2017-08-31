function [ similar_cluster ] = clustering_results( agents_signal_fingerprints )
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
    
    k = 7;
    similar_cluster = kmeans(agents_signal_fingerprints,k,'Distance','correlation');
    Y = pdist(agents_signal_fingerprints);
    Z = linkage(Y)
    c = cophenet(Z,Y)
    dendrogram(Z)
    
    
end

