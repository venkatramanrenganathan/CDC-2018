function d = fun_cos_similarity(u, v)
% Function fun_cos_similarity returns the cosine similarity between two vectors
% 
% INPUT
% u,v - two random vectors to compare similarities between them
% OUTPUT
% d = cosine similarity value
%
d = dot(u,v)/(norm(u)*norm(v));
end