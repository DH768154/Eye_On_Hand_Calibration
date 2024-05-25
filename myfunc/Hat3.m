function M = Hat3(W)

[r,c] = size(W);
if r~=3
    error('3xn Vector Needed')
end

if isa(W,'sym')
    M = sym(zeros(3,3));
else
    M = zeros(3,3,c);
end

M(1,2,:) = -W(3,:);
M(2,1,:) =  W(3,:);
M(1,3,:) =  W(2,:);
M(3,1,:) = -W(2,:);
M(2,3,:) = -W(1,:);
M(3,2,:) =  W(1,:);

end