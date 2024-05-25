function T_inv = HomInv(T)
% Inverse for SE3, Also Works for 3D Matrix
[~,~,p] = size(T);
if p==1
    T_inv = R2T(T(1:3,1:3)',-T(1:3,1:3)'*T(1:3,4));
else
    Rinv = pagectranspose(T(1:3,1:3,:));
    T_inv = R2T(Rinv,-pagemtimes(Rinv,T(1:3,4,:)));
end