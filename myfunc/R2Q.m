function q = R2Q(R)
% Input R : 3*3*n rotation matrix to Quaternion
% return q: n*4 row vector [v0,v123]

[~,~,p] = size(R);
if p == 1
    q(1) = sqrt(R(1,1)+R(2,2)+R(3,3)+1)/2;
    q(2) = sqrt(abs(R(1,1)-R(2,2)-R(3,3)+1))/2*sign(R(3,2)-R(2,3));
    q(3) = sqrt(abs(R(2,2)-R(1,1)-R(3,3)+1))/2*sign(R(1,3)-R(3,1));
    q(4) = sqrt(abs(R(3,3)-R(1,1)-R(2,2)+1))/2*sign(R(2,1)-R(1,2));
else
    q = NaN(p,4);
    q(:,1) = sqrt(R(1,1,:)+R(2,2,:)+R(3,3,:)+1)/2;
    q(:,2) = sqrt(abs(R(1,1,:)-R(2,2,:)-R(3,3,:)+1))./2.*sign(R(3,2,:)-R(2,3,:));
    q(:,3) = sqrt(abs(R(2,2,:)-R(1,1,:)-R(3,3,:)+1))./2.*sign(R(1,3,:)-R(3,1,:));
    q(:,4) = sqrt(abs(R(3,3,:)-R(1,1,:)-R(2,2,:)+1))./2.*sign(R(2,1,:)-R(1,2,:));
end


%% From CIS, Have Mistakes
% [rxx,rxy,rxz,ryx,ryy,ryz,rzx,rzy,rzz] = ...
%     deal(R(1,1),R(2,1),R(3,1),R(1,2),R(2,2),R(3,2),R(1,3),R(2,3),R(3,3));
% 
% 
% a0 = 1+rxx+ryy+rzz;
% a1 = 1+rxx-ryy-rzz;
% a2 = 1-rxx+ryy-rzz;
% a3 = 1-rxx-ryy+rzz;
% 
% [~,ind] = max([a0;a1;a2;a3]);
% 
% switch ind
%     case 1
%         q0 = sqrt(a0)/2;
%         q1 = (rxy-ryx)/4/q0;
%         q2 = (rzx-rxz)/4/q0;
%         q3 = (ryz-rzy)/4/q0;
%     case 2
%         q1 = sqrt(a1)/2;
%         q0 = (ryz-rzy)/4/q1;
%         q2 = (rxy+ryz)/4/q1;
%         q3 = (rxz+rzx)/4/q1;
%     case 3
%         q2 = sqrt(a2)/2;
%         q0 = (rzx-rxz)/4/q2;
%         q1 = (rxy+ryx)/4/q2;
%         q3 = (ryz+rzy)/4/q2;
%     case 4
%         q3 = sqrt(a0)/2;
%         q0 = (rxy-ryx)/4/q3;
%         q1 = (rxz+rzx)/4/q3;
%         q2 = (ryz+rzy)/4/q3;
% end
% 
% qq = [q0,q1,q2,q3];
end











