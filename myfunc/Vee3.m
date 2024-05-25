function V = Vee3(R)
% Inverse of Hat, Skew to Vector
% R: 3x3xn
% V: 3xn
[r,c,p] = size(R);

if r~=3 || c~=3
    error('3x3 Matrix Needed')
end

if p~=1 && isa(R,'sym')
    error('Symbolic Calculation only support 3x3 2D matrix')
end

if isa(R,'sym')
    V = sym(NaN(3,1));
    V(1,1) = R(3,2);
    V(2,1) = R(1,3);
    V(3,1) = R(2,1);
else
    W = NaN(3,1,p);
    W(1,1,:) = R(3,2,:);
    W(2,1,:) = R(1,3,:);
    W(3,1,:) = R(2,1,:);
    V = reshape(W,3,p);
end


end