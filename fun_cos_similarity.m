function d = fun_cos_similarity(u, v)
% Function fun_cos_similarity returns the cosine similarity between two vectors
    d = dot(u,v)/(norm(u)*norm(v));
end