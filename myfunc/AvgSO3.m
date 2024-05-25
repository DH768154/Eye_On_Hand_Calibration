function avg_rq = AvgSO3(rq,varargin)
% Quaternion Averaging 
% https://ntrs.nasa.gov/api/citations/20070017872/downloads/20070017872.pdf

if size(rq,3)>1
    qs = R2Q(rq);
else
    qs = rq;
end

if size(qs,2)~=4
    error('Wrong Size, Input quat or matrix')
end

if nargin==2
    w = varargin{1};
else
    w = ones(size(qs,1),1);
end

if numel(w)~=size(qs,1)
    error('wrong weight size')
end

if size(w,1) == 1
    w = w';
end

%%
M = (w.*qs)'*qs;
[V,D] = eig(M);
[~,ind] = max(diag(D));
q = V(:,ind)';
q = q*sign(q(1)*mean(qs(:,1)));

%%
if size(rq,3)>1
    avg_rq = Q2R(q);
else
    avg_rq = q;
end

end