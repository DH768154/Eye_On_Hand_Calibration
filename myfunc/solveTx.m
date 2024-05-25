function tx = solveTx( RA,tA, tB, RX )
% A*X = X*B, find Translation Part for X
% RA: 3x3xN Rotation
% tA,tB: 3x1xN or 3xN

sets = size(RA,3);
%%
% HW Requirement, input tA is 3*n
% For me, input 3*1*n direct from 3D Matrix is Better
% So this section to handle both 

if size(tA,3)~=3
    tA = reshape(tA,[3,1,sets]);
end
if size(tB,3)~=3
    tB = reshape(tB,[3,1,sets]);
end

%%

lf  = mx3cat(RA-eye(3));
rt = pagemtimes(RX.*ones([1,1,sets]),tB)-tA;
rt = reshape(rt,[3*sets,1]);
tx = lf\rt;

end