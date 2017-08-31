% THIS FILE IS JUST FOR PLAYING AROUND CODING BEFORE USING THEM
% A = [1 2 3 4 5 6 7 8 9 10;1 2 3 2 4 3 5 6 2 7]';
% u=unique(A);
% d = u(histc(A,u) > 1);
% for i = 1:length(d)
%     out = find(ismember(A,d(i)));
%     c = nchoosek(1:length(out), 2);
% end

% condition = A(:,2) == 2;
% B = [10];
% C = ismember(8, A(:,2))
%A(condition,:) = [];

% A = [1 2 3 4 5 6 7 8 9 -1];
% B = [3 6 8 10];
% A(B) = A(B) + 1
% find(A~=0);
% indices = randperm(length(A),length(A)-1)
% C = A(indices)
% sort(C,'descend')

x = simplecluster_dataset;
net = selforgmap([6 6]);
net = train(net,x);