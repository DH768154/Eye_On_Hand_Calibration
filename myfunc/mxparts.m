function [R,P] = mxparts(T)
if size(T,1)~=4 || size(T,2)~=4
    error('Need 4x4xn Matrix')
end
R = T(1:3,1:3,:);
P = T(1:3,4,:);
end