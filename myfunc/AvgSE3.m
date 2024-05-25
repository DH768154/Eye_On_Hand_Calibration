function avg_pos = AvgSE3(rot,tran,varargin)
% Input: 
% rot: 3*3*n SO3 Matrix or n*4 quat
% tran: 3*n or 3*1*n Position Column Vector
% 
% Optional Input
% w: 1*n weight vector

if size(tran,3)>1 && size(tran,2)==1
    tran = reshape(tran,3,[]);
end

if nargin == 3
    w = varargin{1};
    if numel(w)==1
        w = ones(1,size(tran,2));
    end
elseif nargin == 2
    w = ones(1,size(tran,2));
end

w = w/sum(w);

R_avg = AvgSO3(rot,w);
p_avg = sum(tran.*w,2);
avg_pos = R2T(R_avg,p_avg);
end