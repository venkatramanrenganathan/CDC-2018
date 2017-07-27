A = [1 2 3 2 4 3 5 6 2 2 7 8 9 2 2 2];
u=unique(A);
d = u(histc(A,u) > 1);
for i = 1:length(d)
    out = find(ismember(A,d(i)))
    c = nchoosek(1:length(out), 2)
end
